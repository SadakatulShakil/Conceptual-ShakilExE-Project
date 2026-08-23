import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/retro_keypad.dart';
import 'widgets/retro_nav_cluster.dart';
import 'widgets/retro_screen.dart';

/// The retro (2003) feature-phone handset: brand chrome, LCD screen, d-pad
/// nav cluster, and number keypad.
///
/// Sized via flutter_screenutil like the rest of the app; [RetroShell]
/// re-points ScreenUtil at this handset's own design box (320x784) before
/// building it, the same technique the modern shell uses for its phone
/// frame — so `.w/.h/.sp/.r` here scale uniformly to whatever box the
/// shell hands it, keeping the device's proportions exact.
class RetroHandset extends StatelessWidget {
  const RetroHandset({super.key});

  /// The design-space size this handset is authored against. Keep in sync
  /// with [RetroShell]'s re-pointing call.
  static const Size designSize = Size(300, 784);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 22.h),
      decoration: BoxDecoration(
        color: AppColors.retroBody,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: AppColors.pageBlack.withOpacity(0.6),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.key,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'SHAKIL',
            style: AppTheme.mono(size: 8.sp, color: AppColors.textMuted)
                .copyWith(letterSpacing: 3),
          ),
          SizedBox(height: 14.h),
          const RetroScreen(),
          SizedBox(height: 20.h),
          const RetroNavCluster(),
          SizedBox(height: 20.h),
          const RetroKeypad(),
        ],
      ),
    );
  }
}
