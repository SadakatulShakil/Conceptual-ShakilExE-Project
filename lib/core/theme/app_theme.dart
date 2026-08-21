import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Two type systems: [sans] for the modern shell, [mono] for the retro LCD.
/// Both defined once so a section widget can pick the right one via the era.
class AppTheme {
  AppTheme._();

  static TextTheme get _sansBase =>
      GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

  static TextStyle mono({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double? letterSpacing,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  static TextStyle sans({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textPrimary,
  }) =>
      GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.pageBlack,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.screenBg,
          primary: AppColors.accentSoft,
          secondary: AppColors.timeWarp,
          error: AppColors.danger,
        ),
        textTheme: _sansBase,
        splashColor: AppColors.accentSoft.withOpacity(0.08),
        highlightColor: Colors.transparent,
      );
}
