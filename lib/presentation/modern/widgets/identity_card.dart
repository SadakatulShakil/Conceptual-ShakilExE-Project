import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/portfolio_controller.dart';
import '../../../core/enums/section_id.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/section_config.dart';
import '../../shared/section_placeholder_screen.dart';

/// Compact profile card: avatar initials, name, and a one-line subtitle.
class IdentityCard extends StatelessWidget {
  const IdentityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final profile = controller.profile;
    final about = kSections.firstWhere((s) => s.id == SectionId.about);

    return GestureDetector(
      onTap: () => Get.to(() => SectionPlaceholderScreen(title: about.title)),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.tile,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: const BoxDecoration(
                color: AppColors.iconBlue,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                profile.initials,
                style: AppTheme.sans(
                  size: 19.sp,
                  weight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profile.name,
                    style: AppTheme.sans(size: 13.sp, weight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Flutter engineer · Dhaka',
                          style: AppTheme.sans(
                            size: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.sports_soccer,
                        size: 12.sp,
                        color: AppColors.accentSoft,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
