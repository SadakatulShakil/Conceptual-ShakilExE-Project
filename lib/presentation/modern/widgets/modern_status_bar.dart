import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Top status row: fake clock and three decorative signal/battery-style
/// squares. The era switcher lives in [TimeFrameControl] further down the
/// launcher, not here.
class ModernStatusBar extends StatelessWidget {
  const ModernStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '18:10',
          style: AppTheme.sans(size: 12.sp, color: AppColors.textPrimary),
        ),
        Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: 4.w),
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textMuted, width: 1),
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
