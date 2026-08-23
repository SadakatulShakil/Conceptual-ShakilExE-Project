import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/era_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// LCD status row: signal glyph, clock, and the era pill — tapping the pill
/// travels to the modern (2026) shell.
class RetroStatusBar extends StatelessWidget {
  const RetroStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final era = Get.find<EraController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.signal_cellular_alt,
          size: 10.sp,
          color: AppColors.accentSoft,
        ),
        Text(
          '18:10',
          style: AppTheme.mono(size: 10.sp, color: AppColors.textSecondary),
        ),
        Obx(
          () => GestureDetector(
            onTap: era.toggleEra,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.timeWarp, width: 1.5),
                color: AppColors.timeWarp.withOpacity(0.14),
              ),
              child: Text(
                era.era.value.yearLabel,
                style:
                    AppTheme.mono(size: 9.sp, color: AppColors.timeWarpSoft),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
