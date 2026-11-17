import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

import 'l10n/app_localizations.dart';
import 'pages/home_page/home_page_view.dart';
import 'util/app_theme.dart';
import 'util/locale_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Date symbols for every supported language.
  await initializeDateFormatting();
  await LocaleController.instance.load();
  runApp(const EduSnapApp());
}

/// Root widget of the EDU SNAP app.
///
/// The project follows the MVC folder layout introduced in Session 1:
/// * `models/`     – plain data classes only (no widgets, no network)
/// * `components/` – reusable widgets shared by pages
/// * `pages/`      – one folder per page, holding its view and controller
/// * `util/`       – shared helpers such as theme, storage and localization
class EduSnapApp extends StatelessWidget {
  const EduSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: LocaleController.instance.locale,
          // `GlobalMaterialLocalizations.delegates` also brings the matching
          // Cupertino and Widgets delegates for every supported language.
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePageView(),
        );
      },
    );
  }
}
