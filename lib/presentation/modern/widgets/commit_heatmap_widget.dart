import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/portfolio_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/url_utils.dart';
import '../../../domain/entities/contact_link.dart';

// TODO: wire real GitHub contributions later.
const List<int> _kCommitIntensities = [
  0, 1, 2, 3, 1, 0, 2, 3, 1, 0, //
  1, 2, 3, 0, 1, 2, 0, 3, 1, 2, //
  2, 1, 0, 3, 2, 1, 0, 2, 3, 1, //
];

/// Fake GitHub-style commit heatmap that links out to the real profile.
class CommitHeatmapWidget extends StatelessWidget {
  const CommitHeatmapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final github = controller.profile.links
        .firstWhereOrNull((l) => l.type == ContactType.github);

    return GestureDetector(
      onTap: () => launchExternal(github?.url ?? ''),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Commit activity',
                  style: AppTheme.sans(size: 12.sp, weight: FontWeight.w500),
                ),
                Text(
                  '2026',
                  style: AppTheme.sans(size: 9.sp, color: AppColors.textMuted),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            for (var row = 0; row < 3; row++) ...[
              if (row > 0) SizedBox(height: 4.w),
              Row(
                children: [
                  for (var col = 0; col < 10; col++) ...[
                    if (col > 0) SizedBox(width: 4.w),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: _colorFor(
                              _kCommitIntensities[row * 10 + col],
                            ),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
            SizedBox(height: 14.h),
            Text(
              '318 commits this year',
              style: AppTheme.sans(size: 9.sp, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFor(int intensity) => switch (intensity) {
        0 => Colors.white.withOpacity(0.08),
        1 => AppColors.commitLow,
        2 => Color.lerp(AppColors.commitLow, AppColors.commitHigh, 0.5)!,
        _ => AppColors.commitHigh,
      };
}
