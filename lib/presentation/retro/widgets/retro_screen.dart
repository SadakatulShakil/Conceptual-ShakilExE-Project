import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/retro_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'retro_menu_grid.dart';
import 'retro_status_bar.dart';

/// The handset's LCD: status bar, 3x3 app menu, the highlighted section's
/// title, and the Open/Back soft-key hint row.
class RetroScreen extends StatelessWidget {
  const RetroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RetroController>();

    return Container(
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        color: AppColors.retroScreen,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Not const: see the note on `handset` in RetroShell.
          RetroStatusBar(),
          SizedBox(height: 10.h),
          RetroMenuGrid(),
          SizedBox(height: 8.h),
          Obx(
            () => Text(
              controller.current.title,
              style: AppTheme.mono(size: 11.sp, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8.h),
          Container(height: 1, color: Colors.white.withOpacity(0.06)),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }
}
