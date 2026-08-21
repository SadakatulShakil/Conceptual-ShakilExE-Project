import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/portfolio_controller.dart';
import '../../../core/enums/section_id.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/section_config.dart';
import '../../shared/section_placeholder_screen.dart';

/// Card highlighting the project currently in progress
/// ([Project.isBuilding]) — a mock "now playing" transport strip.
class NowBuildingWidget extends StatelessWidget {
  const NowBuildingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final building = controller.projects.firstWhere((p) => p.isBuilding);
    final nowSection = kSections.firstWhere((s) => s.id == SectionId.now);

    return GestureDetector(
      onTap: () =>
          Get.to(() => SectionPlaceholderScreen(title: nowSection.title)),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: AppColors.tile,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.shield_outlined,
                    color: AppColors.accentSoft,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'NOW BUILDING',
                        style: AppTheme.sans(
                          size: 9.sp,
                          weight: FontWeight.w600,
                          color: AppColors.accentSoft,
                        ).copyWith(letterSpacing: 0.5),
                      ),
                      Text(
                        building.name,
                        style: AppTheme.sans(
                          size: 13.sp,
                          weight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (building.buildingNote != null)
                        Text(
                          building.buildingNote!,
                          style: AppTheme.sans(
                            size: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Stack(
              children: [
                Container(
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.call_split, size: 16.sp, color: AppColors.textMuted),
                Icon(Icons.skip_previous, size: 18.sp, color: AppColors.textMuted),
                Icon(Icons.play_arrow, size: 18.sp, color: AppColors.accentSoft),
                Icon(Icons.skip_next, size: 18.sp, color: AppColors.textMuted),
                Icon(
                  Icons.rocket_launch,
                  size: 16.sp,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
