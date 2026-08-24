import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Whether the web build uses a live [BackdropFilter] blur for [GlassCard].
/// Flip to `false` if it causes web scroll jank — the higher-opacity
/// [AppColors.glassTopWeb]/[AppColors.glassBottomWeb] fill still reads as
/// frosted (not see-through) without a live blur.
const bool kGlassBlurOnWeb = true;

/// iOS-style frosted-glass surface used by the modern shell's cards: a
/// translucent gradient fill, a hairline border, and — where affordable —
/// a live backdrop blur so the wallpaper behind genuinely frosts rather
/// than just tinting through.
///
/// Modern-only. Retro's flat LCD cards intentionally don't use this.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.radius = 18,
    this.padding,
    this.blurSigma = 16,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final useBlur = !kIsWeb || kGlassBlurOnWeb;
    final borderRadius = BorderRadius.circular(radius);

    final body = Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: useBlur
              ? const [AppColors.glassTop, AppColors.glassBottom]
              : const [AppColors.glassTopWeb, AppColors.glassBottomWeb],
        ),
        border: Border.all(color: AppColors.glassBorder, width: 1),
        borderRadius: borderRadius,
      ),
      child: child,
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: useBlur
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: body,
            )
          : body,
    );
  }
}
