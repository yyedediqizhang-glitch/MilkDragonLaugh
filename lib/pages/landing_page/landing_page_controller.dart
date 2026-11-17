import 'package:flutter/foundation.dart';

/// Controller of the landing page.
///
/// It owns the page state, the view only renders it.
class LandingPageController extends ChangeNotifier {
  bool _isStarting = false;

  bool get isStarting => _isStarting;

  /// Simulates the start-up work (version check, session restore, ...).
  Future<void> start() async {
    if (_isStarting) {
      return;
    }

    _isStarting = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 450));

    _isStarting = false;
    notifyListeners();
  }
}
