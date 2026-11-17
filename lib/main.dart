import 'package:material_ui/material_ui.dart';

import 'pages/landing_page/landing_page_view.dart';
import 'util/app_theme.dart';

void main() {
  runApp(const EduSnapApp());
}

/// Root widget of the EDU SNAP app.
///
/// The project follows the MVC folder layout introduced in Session 1:
/// * `models/`     – plain data classes only (no widgets, no network)
/// * `components/` – reusable widgets shared by pages
/// * `pages/`      – one folder per page, holding its view and controller
/// * `util/`       – shared helpers such as theme, formatting and networking
class EduSnapApp extends StatelessWidget {
  const EduSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDU SNAP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LandingPageView(),
    );
  }
}
