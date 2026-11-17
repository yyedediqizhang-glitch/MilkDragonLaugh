import 'package:material_ui/material_ui.dart';

/// App-wide colours and the single [ThemeData] used by every page.
class AppTheme {
  const AppTheme._();

  static const Color primary = Color(0xFF2F6FED);
  static const Color primaryDark = Color(0xFF1B4BC4);
  static const Color accent = Color(0xFF16B8A6);
  static const Color ink = Color(0xFF14223B);
  static const Color canvas = Color(0xFFF4F7FC);

  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: primary);

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
