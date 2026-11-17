import 'package:material_ui/material_ui.dart';

import '../../util/journal_repository.dart';
import '../../util/local_storage.dart';
import '../../util/locale_controller.dart';

/// Controller of the settings page.
///
/// Owns the language choice and the "storage used" number shown to the user.
class SettingPageController extends ChangeNotifier {
  static const String appVersion = '1.0.0';

  bool _isLoading = true;
  int _bytes = 0;

  bool get isLoading => _isLoading;

  int get bytes => _bytes;

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
