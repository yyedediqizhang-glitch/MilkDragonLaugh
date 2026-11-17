import 'dart:async';

import 'package:itchi_flutter_duo_layout/itchi_flutter_duo_layout.dart';
import 'package:material_ui/material_ui.dart';

/// Wraps the native iPhone Duo plugin (Session 4).
///
/// The plugin is iOS only: on every other platform the calls return
/// `unsupportedPlatform` and the app simply keeps its normal layout.
class DuoLayoutService extends ChangeNotifier {
  DuoLayoutService._();

  static final DuoLayoutService instance = DuoLayoutService._();

  DuoFoldSnapshot? _fold;
  bool _railVisible = false;
  bool _initialised = false;

  StreamSubscription<DuoFoldSnapshot>? _foldSub;
  StreamSubscription<void>? _backSub;
  VoidCallback? _onBack;

  DuoFoldSnapshot? get fold => _fold;

  bool get railVisible => _railVisible;

  /// The page that wants to react to the native rail Back button.
  void setBackHandler(VoidCallback? handler) {
    _onBack = handler;
  }

  bool get isFullyOpen =>
      _fold != null &&
      _fold!.isAvailable &&
      _fold!.pose == DuoFoldPose.fullyOpen;

  /// Starts listening to the hinge stream and the native back button.
  Future<void> init({VoidCallback? onNativeBack}) async {
    if (_initialised) {
      return;
    }
    _initialised = true;

    try {
      _foldSub = ItchiDuoFold.snapshots.listen((DuoFoldSnapshot snapshot) {
        _fold = snapshot;
        notifyListeners();
      });
    } catch (_) {
      // Not available on this platform – keep the fallback layout.
    }

    try {
      _backSub = ItchiDuoSideBack.onBack.listen((_) {
        _onBack?.call();
        onNativeBack?.call();
      });
    } catch (_) {}
  }

  /// Puts the Back control on Duo's native side rail.
  ///
  /// Returns `true` when the rail is actually shown, so the page can hide its
  /// own AppBar back arrow.
  Future<bool> enableRailBack() async {
    try {
      final ItchiSideBackStatus status = await ItchiDuoSideBack.setVisible(true);
      _railVisible = status == ItchiSideBackStatus.available;
    } catch (_) {
      _railVisible = false;
    }

    notifyListeners();
    return _railVisible;
  }

  Future<void> disableRailBack() async {
    try {
      await ItchiDuoSideBack.setVisible(false);
    } catch (_) {}

    if (_railVisible) {
      _railVisible = false;
      notifyListeners();
    }
  }

  /// Two-pane layout: used when the Duo is fully open, or on a wide window
  /// such as a tablet / desktop build.
  bool wantsTwoPanes(Size size) {
    if (isFullyOpen && size.width >= 600) {
      return true;
    }
    return size.width >= 900;
  }

  @override
  void dispose() {
    _foldSub?.cancel();
    _backSub?.cancel();
    super.dispose();
  }
}
