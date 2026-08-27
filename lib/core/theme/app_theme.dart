import 'package:flutter/material.dart';

import 'theme_controller.dart';

class AppTheme {
  AppTheme._();

  static ThemeData themeFor(ZyncupThemeOption theme) {
    return switch (theme) {
      ZyncupThemeOption.light => light,
      ZyncupThemeOption.dark => dark,
      ZyncupThemeOption.warm => warm,
    };
  }

  static ThemeData get light => _theme(
    brightness: Brightness.light,
    seedColor: const Color(0xFF1F7AE0),
    primary: const Color(0xFF1769E0),
    secondary: const Color(0xFF00A99D),
    tertiary: const Color(0xFFFFB238),
    surface: const Color(0xFFF8FBFF),
    surfaceContainer: const Color(0xFFFFFFFF),
    extension: const ZyncupThemeColors(
      pageGradientStart: Color(0xFFFFFFFF),
      pageGradientMiddle: Color(0xFFEAF4FF),
      pageGradientEnd: Color(0xFFFFF4DC),
      panelColor: Color(0xF7FFFFFF),
      glowColor: Color(0x331769E0),
      accentGlowColor: Color(0x3300A99D),
    ),
  );

  static ThemeData get dark => _theme(
    brightness: Brightness.dark,
    seedColor: const Color(0xFF73D2FF),
    primary: const Color(0xFF83D7FF),
    secondary: const Color(0xFF71F2C8),
    tertiary: const Color(0xFFFFC86B),
    surface: const Color(0xFF101623),
    surfaceContainer: const Color(0xFF182133),
    extension: const ZyncupThemeColors(
      pageGradientStart: Color(0xFF0C1220),
      pageGradientMiddle: Color(0xFF14233A),
      pageGradientEnd: Color(0xFF261D36),
      panelColor: Color(0xF01A2436),
      glowColor: Color(0x5573D2FF),
      accentGlowColor: Color(0x3DFFB84D),
    ),
  );

  static ThemeData get warm => _theme(
    brightness: Brightness.light,
    seedColor: const Color(0xFFE75C86),
    primary: const Color(0xFFD94373),
    secondary: const Color(0xFFFF8A65),
    tertiary: const Color(0xFF7B61FF),
    surface: const Color(0xFFFFF8FA),
    surfaceContainer: const Color(0xFFFFFFFF),
    extension: const ZyncupThemeColors(
      pageGradientStart: Color(0xFFFFFCFD),
      pageGradientMiddle: Color(0xFFFFE9F0),
      pageGradientEnd: Color(0xFFFFF1DF),
      panelColor: Color(0xF9FFFFFF),
      glowColor: Color(0x33D94373),
      accentGlowColor: Color(0x33FF8A65),
    ),
  );

  static ThemeData _theme({
    required Brightness brightness,
    required Color seedColor,
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color surface,
    required Color surfaceContainer,
    required ZyncupThemeColors extension,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: surfaceContainer,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      extensions: [extension],
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.44),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
    );
  }
}

@immutable
class ZyncupThemeColors extends ThemeExtension<ZyncupThemeColors> {
  const ZyncupThemeColors({
    required this.pageGradientStart,
    required this.pageGradientMiddle,
    required this.pageGradientEnd,
    required this.panelColor,
    required this.glowColor,
    required this.accentGlowColor,
  });

  final Color pageGradientStart;
  final Color pageGradientMiddle;
  final Color pageGradientEnd;
  final Color panelColor;
  final Color glowColor;
  final Color accentGlowColor;

  @override
  ZyncupThemeColors copyWith({
    Color? pageGradientStart,
    Color? pageGradientMiddle,
    Color? pageGradientEnd,
    Color? panelColor,
    Color? glowColor,
    Color? accentGlowColor,
  }) {
    return ZyncupThemeColors(
      pageGradientStart: pageGradientStart ?? this.pageGradientStart,
      pageGradientMiddle: pageGradientMiddle ?? this.pageGradientMiddle,
      pageGradientEnd: pageGradientEnd ?? this.pageGradientEnd,
      panelColor: panelColor ?? this.panelColor,
      glowColor: glowColor ?? this.glowColor,
      accentGlowColor: accentGlowColor ?? this.accentGlowColor,
    );
  }

  @override
  ZyncupThemeColors lerp(ThemeExtension<ZyncupThemeColors>? other, double t) {
    if (other is! ZyncupThemeColors) return this;
    return ZyncupThemeColors(
      pageGradientStart: Color.lerp(
        pageGradientStart,
        other.pageGradientStart,
        t,
      )!,
      pageGradientMiddle: Color.lerp(
        pageGradientMiddle,
        other.pageGradientMiddle,
        t,
      )!,
      pageGradientEnd: Color.lerp(pageGradientEnd, other.pageGradientEnd, t)!,
      panelColor: Color.lerp(panelColor, other.panelColor, t)!,
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
      accentGlowColor: Color.lerp(accentGlowColor, other.accentGlowColor, t)!,
    );
  }
}
