import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/enums/app_era.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/clickable.dart';
import '../../shared/glass_card.dart';

/// Prominent, labeled era switcher — replaces the small status-bar pill so
/// time-travel reads as a first-class feature rather than a corner control.
/// Tapping travels to the opposite era (a real warp animation lands in
/// Phase 5).
///
/// Deliberately a plain (non-GetX-reactive) widget: it sits inside an
/// [IntrinsicHeight] band, and wrapping it in `Obx` there corrupts the
/// row's intrinsic-height measurement. The caller reads [EraController]
/// reactively and passes the current [era] down instead.
class TimeFrameControl extends StatelessWidget {
  const TimeFrameControl({super.key, required this.era, required this.onTap});

  final AppEra era;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: onTap,
      child: Container(
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppColors.timeWarp, width: 1.5),
          color: AppColors.timeWarp.withOpacity(0.14),
        ),
        child: GlassCard(
          radius: 24.r,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.timeWarp.withOpacity(0.3),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.history_toggle_off,
                  size: 15.sp,
                  color: AppColors.timeWarpSoft,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Time Frame',
                      style: AppTheme.sans(
                        size: 11.sp,
                        weight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Travel to ${era.opposite.fullYear}',
                      style: AppTheme.sans(
                        size: 9.sp,
                        color: AppColors.timeWarpSoft,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 16.sp,
                color: AppColors.timeWarpSoft,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
