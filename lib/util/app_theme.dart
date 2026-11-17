import 'package:material_ui/material_ui.dart';

/// Colours derived from `assets/icon.png` (green field, orange tassel, peach
/// brackets) plus a neutral page background.
///
/// They are exposed as a [ThemeExtension] so widgets read the palette from the
/// theme instead of hard-coding hex values.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.surface,
    required this.background,
    required this.ink,
    required this.muted,
    required this.border,
    required this.card,
    required this.danger,
  });

  /// Logo green – AppBar, primary buttons.
  final Color primary;

  /// Logo orange – floating action button, highlights.
  final Color secondary;

  /// Bright orange – small accents.
  final Color accent;

  /// Logo peach – chips and soft highlights.
  final Color surface;

  /// Neutral page background.
  final Color background;

  final Color ink;
  final Color muted;
  final Color border;
  final Color card;
  final Color danger;

  static const AppPalette light = AppPalette(
    primary: Color(0xFF005828),
    secondary: Color(0xFFD86038),
    accent: Color(0xFFF2653A),
    surface: Color(0xFFF0B098),
    background: Color(0xFFF2F2F2),
    ink: Color(0xFF0B2A1B),
    muted: Color(0xFF5E6F64),
    border: Color(0xFFDCE3DD),
    card: Colors.white,
    danger: Color(0xFFC0392B),
  );

  @override
  AppPalette copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? surface,
    Color? background,
    Color? ink,
    Color? muted,
    Color? border,
    Color? card,
    Color? danger,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      border: border ?? this.border,
      card: card ?? this.card,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }

    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      card: Color.lerp(card, other.card, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

/// `context.palette` shortcut used by every widget.
extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    const AppPalette p = AppPalette.light;

    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: p.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: p.primary,
      onPrimary: Colors.white,
      secondary: p.secondary,
      onSecondary: Colors.white,
      tertiary: p.accent,
      surface: p.card,
      onSurface: p.ink,
    );

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      extensions: const <ThemeExtension<dynamic>>[p],
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: p.ink,
        displayColor: p.ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF005828),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.secondary,
        foregroundColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: p.primary),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.primary,
          side: BorderSide(color: p.primary.withValues(alpha: 0.35)),
        ),
      ),
      dividerTheme: DividerThemeData(color: p.border, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
