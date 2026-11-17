import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../util/journal_repository.dart';
import '../../util/local_storage.dart';
import '../../util/locale_controller.dart';

/// Controller of the settings page.
///
/// Owns the language choice, the "storage used" number and the app version read
/// from the platform (Session 4).
class SettingPageController extends ChangeNotifier {
  bool _isLoading = true;
  int _bytes = 0;
  String _version = '1.1.0';
  String _buildNumber = '2';

  bool get isLoading => _isLoading;

  int get bytes => _bytes;

  String get version => _version;

  String get buildNumber => _buildNumber;

  /// `1.1.0 (2)` – the version plus the build number from pubspec.yaml.
  String get versionLabel =>
      _buildNumber.isEmpty ? _version : '$_version ($_buildNumber)';

  Locale get locale => LocaleController.instance.locale;

  /// Human readable size, e.g. `0 B`, `812 B`, `12.4 KB`.
  String get formattedSize {
    if (_bytes < 1024) {
      return '$_bytes B';
    }

    final double kb = _bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }

    return '${(kb / 1024).toStringAsFixed(2)} MB';
  }

  Future<void> load() async {
    _bytes = await LocalStorage.instance.storageSizeBytes();

    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      _version = info.version;
      _buildNumber = info.buildNumber;
    } catch (_) {
      // Platform channel unavailable (e.g. widget tests) – keep the fallback.
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    await LocaleController.instance.setLocale(locale);
    notifyListeners();
  }

  /// Clears every entry, photo and preference, then refreshes the size.
  Future<void> clearData() async {
    await JournalRepository.instance.clearAll();
    await load();
  }
}
