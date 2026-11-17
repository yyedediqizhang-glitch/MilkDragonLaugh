import 'package:material_ui/material_ui.dart';

import 'local_storage.dart';

/// Holds the language selected by the user and remembers it in local storage.
class LocaleController extends ChangeNotifier {
  LocaleController._();

  static final LocaleController instance = LocaleController._();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('ja'),
  ];

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> load() async {
    final String? code = await LocalStorage.instance.loadLanguageCode();

    if (code == null) {
      return;
    }

    final Locale stored = Locale(code);
    if (supportedLocales.contains(stored) && stored != _locale) {
      _locale = stored;
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (locale == _locale) {
      return;
    }

    _locale = locale;
    notifyListeners();
    await LocalStorage.instance.saveLanguageCode(locale.languageCode);
  }
}
