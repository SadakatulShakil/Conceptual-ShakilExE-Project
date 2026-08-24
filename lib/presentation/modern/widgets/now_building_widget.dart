import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/portfolio_controller.dart';
import '../../../core/enums/section_id.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/project.dart';
import '../../shared/glass_card.dart';
import '../modern_section_screen.dart';

/// Card highlighting the project(s) currently in progress
/// ([Project.isBuilding]) — a mock "now playing" transport strip. Rotates
/// through every building project with a cross-fade every ~3.5s; stays on
/// a single static card when there's only one.
class NowBuildingWidget extends StatefulWidget {
  const NowBuildingWidget({super.key});

  @override
  State<NowBuildingWidget> createState() => _NowBuildingWidgetState();
}

class _NowBuildingWidgetState extends State<NowBuildingWidget> {
  static const _rotateInterval = Duration(milliseconds: 3500);

  late final List<Project> _building;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _building = Get.find<PortfolioController>()
        .projects
        .where((p) => p.isBuilding)
        .toList();
    if (_building.length > 1) {
      _timer = Timer.periodic(_rotateInterval, (_) {
        setState(() => _index = (_index + 1) % _building.length);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final building = _building.isEmpty ? null : _building[_index];

    return GestureDetector(
      onTap: () => Get.to(() => const ModernSectionScreen(id: SectionId.now)),
      behavior: HitTestBehavior.opaque,
      child: GlassCard(
        radius: 18.r,
        padding: EdgeInsets.all(14.w),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: building == null
              ? const SizedBox(key: ValueKey('empty'))
              : _BuildingContent(
                  key: ValueKey(building.id),
                  project: building,
                ),
        ),
      ),
    );
  }
}

class _BuildingContent extends StatelessWidget {
  const _BuildingContent({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    project.name,
                    style: AppTheme.sans(
                      size: 13.sp,
                      weight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (project.buildingNote != null)
                    Text(
                      project.buildingNote!,
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
        SizedBox(height: 14.h),
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
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.call_split, size: 16.sp, color: AppColors.textMuted),
            Icon(
              Icons.skip_previous,
              size: 18.sp,
              color: AppColors.textMuted,
            ),
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
    );
  }
}
