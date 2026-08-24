import 'package:flutter/material.dart';

/// Central dark palette for both eras. Never hard-code hex in widgets.
/// Both worlds share these — the shells differ in layout, not colour.
class AppColors {
  AppColors._();

  // Surfaces (dark-only by design)
  static const Color pageBlack = Color(0xFF0D0D0F); // web backdrop / deepest
  static const Color screenBg = Color(0xFF141416); // modern phone screen
  static const Color retroBody = Color(0xFF1B1B1E); // retro handset body
  static const Color retroScreen = Color(0xFF0A0A0C); // retro LCD
  static const Color key = Color(0xFF26262A); // retro keys / dock buttons

  // Translucent tile fills (use withOpacity in widgets when layering)
  static const Color tile = Color(0x0FFFFFFF); // ~6% white
  static const Color tileHover = Color(0x1AFFFFFF); // ~10% white

  // Frosted glass (modern shell only — see GlassCard)
  static const Color glassTop = Color(0x24FFFFFF); // ~14% white
  static const Color glassBottom = Color(0x14FFFFFF); // ~8% white
  static const Color glassBorder = Color(0x2EFFFFFF); // ~18% white hairline
  static const Color glassTopWeb = Color(0x30FFFFFF); // ~19%, no-blur fallback
  static const Color glassBottomWeb = Color(0x1FFFFFFF); // ~12%

  // Text
  static const Color textPrimary = Color(0xFFF2F2F4);
  static const Color textSecondary = Color(0xFF9A9A9E);
  static const Color textMuted = Color(0xFF6A6A6E);

  // Brand accents
  static const Color accent = Color(0xFF0F6E56); // deep teal (OK key, fills)
  static const Color accentSoft = Color(0xFF5DCAA5); // teal glow / selection
  static const Color timeWarp = Color(0xFF7F77DD); // purple — time travel
  static const Color timeWarpSoft = Color(0xFFAFA9EC);

  // Section / app icon accents (shared by both shells)
  static const Color iconBlue = Color(0xFF85B7EB); // Projects / Abohawa
  static const Color iconAmber = Color(0xFFEF9F27); // Experience / AWARE
  static const Color iconPurple = Color(0xFFAFA9EC); // Skills
  static const Color iconPink = Color(0xFFED93B1); // About
  static const Color iconCoral = Color(0xFFF0997B); // Résumé
  static const Color iconTeal = Color(0xFF5DCAA5); // Contact / FFWC
  static const Color iconGreen = Color(0xFF97C459); // Now / Bipod
  static const Color iconWhite = Color(0xFFE8E8EA); // GitHub
  static const Color iconGray = Color(0xFF888888); // Extras

  // States
  static const Color danger = Color(0xFFF09595); // retro end key
  static const Color commitLow = Color(0xFF0F6E56);
  static const Color commitHigh = Color(0xFF5DCAA5);
}
