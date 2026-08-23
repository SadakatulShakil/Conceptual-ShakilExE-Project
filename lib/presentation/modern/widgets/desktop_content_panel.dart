import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/desktop_selection_controller.dart';
import '../../../core/controllers/portfolio_controller.dart';
import '../../../core/enums/section_id.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/experience_item.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/skill_group.dart';
import '../../shared/project_visuals.dart';
import '../../shared/section_config.dart';

/// Desktop-only companion panel shown beside the [PhoneFrame] mockup: a
/// richer list view of whichever section is active (Projects by default).
/// Selection is entirely driven by [DesktopSelectionController] — tapping a
/// section or project tile inside the phone mockup is the only navigation;
/// this panel has no tabs of its own, just a heading reflecting the current
/// selection. Sizes are plain logical pixels rather than ScreenUtil's
/// `.w/.h/.sp` — this panel isn't part of the phone's scaled screen, so it
/// isn't affected by whatever ScreenUtil is currently re-pointed at.
class DesktopContentPanel extends StatelessWidget {
  const DesktopContentPanel({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final selection = Get.find<DesktopSelectionController>();

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.tile,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final section = kSections
                  .firstWhere((s) => s.id == selection.selected.value);
              return Row(
                children: [
                  Icon(section.icon, size: 18, color: section.color),
                  const SizedBox(width: 8),
                  Text(
                    section.title,
                    style: AppTheme.sans(size: 15, weight: FontWeight.w600),
                  ),
                ],
              );
            }),
            const SizedBox(height: 18),
            Expanded(
              child: Obx(
                () => SingleChildScrollView(
                  child: _buildContent(controller, selection.selected.value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(PortfolioController controller, SectionId selected) {
    switch (selected) {
      case SectionId.projects:
        return Column(
          children: [
            for (final p in controller.projects) _ProjectRow(project: p),
          ],
        );
      case SectionId.experience:
        return Column(
          children: [
            for (final e in controller.experience) _ExperienceRow(item: e),
          ],
        );
      case SectionId.skills:
        return Column(
          children: [
            for (final g in controller.skills) _SkillRow(group: g),
          ],
        );
      case SectionId.about:
        return _AboutContent(
          tagline: controller.profile.tagline,
          bio: controller.profile.bio,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _ProjectRow extends StatelessWidget {
  const _ProjectRow({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final visual = projectVisual(project.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.tileHover,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(visual.icon, color: visual.color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name,
                        style:
                            AppTheme.sans(size: 14, weight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _StatusPill(isLive: project.isLive),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  project.subtitle,
                  style:
                      AppTheme.sans(size: 11, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  project.description,
                  style: AppTheme.sans(
                    size: 11.5,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isLive});

  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final color = isLive ? AppColors.accentSoft : AppColors.iconAmber;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isLive ? 'Live' : 'Building',
        style: AppTheme.sans(size: 9, weight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _ExperienceRow extends StatelessWidget {
  const _ExperienceRow({required this.item});

  final ExperienceItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.tileHover,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.work_outline_rounded,
              color: AppColors.iconAmber,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.role,
                  style: AppTheme.sans(size: 14, weight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.company} · ${item.period}',
                  style:
                      AppTheme.sans(size: 11, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.bullets.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.bullets.first,
                    style: AppTheme.sans(
                      size: 11.5,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.group});

  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.category,
            style: AppTheme.sans(size: 12, weight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            group.skills.join(' · '),
            style: AppTheme.sans(size: 11.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({required this.tagline, required this.bio});

  final String tagline;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tagline,
          style: AppTheme.sans(
            size: 13,
            weight: FontWeight.w600,
            color: AppColors.accentSoft,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          bio,
          style: AppTheme.sans(size: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
