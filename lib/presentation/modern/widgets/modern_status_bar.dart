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
      ],
    );
  }
}
