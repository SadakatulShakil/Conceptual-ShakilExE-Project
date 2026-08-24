import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/clickable.dart';

/// A single physical-style key on the retro keypad: a big glyph/number plus
/// an optional tiny sub-label (T9 letters).
class RetroKey extends StatelessWidget {
  const RetroKey({
    super.key,
    required this.label,
    required this.onTap,
    this.subLabel,
    this.selected = false,
    this.accentColor,
  });

  final String label;
  final String? subLabel;
  final VoidCallback onTap;
  final bool selected;

  /// Overrides the selection/tint colour (used for the `#` time-travel
  /// key, which is always subtly tinted regardless of grid selection).
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final tint = accentColor ?? AppColors.accentSoft;

    return Clickable(
      onTap: onTap,
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: selected ? tint.withOpacity(0.14) : AppColors.key,
          borderRadius: BorderRadius.circular(10.r),
          border: selected ? Border.all(color: tint, width: 1.5) : null,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTheme.mono(
                size: 15.sp,
                weight: FontWeight.w500,
                color: selected ? tint : AppColors.textPrimary,
              ),
            ),
            if (subLabel != null)
              Text(
                subLabel!,
                style: AppTheme.mono(size: 6.sp, color: AppColors.textMuted),
              ),
          ],
        ),
      ),
    );
  }
}
