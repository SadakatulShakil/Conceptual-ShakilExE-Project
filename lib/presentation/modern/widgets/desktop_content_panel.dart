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

/// Desktop-only companion panel shown beside the [PhoneFrame] mockup: a tab
/// row over Projects/Experience/Skills/About (Projects selected by default)
/// with a richer list view of whichever section is active. Selection is
/// shared with [DesktopSelectionController] so tapping the matching tile
/// inside the phone mockup switches this panel too. Sizes are plain logical
/// pixels rather than ScreenUtil's `.w/.h/.sp` — this panel isn't part of
/// the phone's scaled screen, so it isn't affected by whatever ScreenUtil
/// is currently re-pointed at.
class DesktopContentPanel extends StatelessWidget {
  const DesktopContentPanel({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  static const _tabs = [
    SectionId.projects,
    SectionId.experience,
    SectionId.skills,
    SectionId.about,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final selection = Get.find<DesktopSelectionController>();

    return SizedBox(
      width: width,
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
            Text(
              'CONTENT',
              style: AppTheme.sans(
                size: 11,
                weight: FontWeight.w600,
                color: AppColors.textMuted,
              ).copyWith(letterSpacing: 1),
            ),
            const SizedBox(height: 14),
            Obx(
              () => Row(
                children: [
                  for (final id in _tabs) ...[
                    _TabChip(
                      id: id,
                      selected: selection.selected.value == id,
                      onTap: () => selection.selected.value = id,
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
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

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.id,
    required this.selected,
    required this.onTap,
  });

  final SectionId id;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final section = kSections.firstWhere((s) => s.id == id);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? section.color.withOpacity(0.22)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selected ? section.color.withOpacity(0.6) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              section.icon,
              size: 14,
              color: selected ? section.color : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              section.title,
              style: AppTheme.sans(
                size: 11,
                weight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
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
