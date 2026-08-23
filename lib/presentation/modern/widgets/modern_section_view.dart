import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/portfolio_controller.dart';
import '../../../core/enums/section_id.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/url_utils.dart';
import '../../../domain/entities/contact_link.dart';
import '../../../domain/entities/experience_item.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/skill_group.dart';
import '../../shared/contact_visuals.dart';
import '../../shared/project_visuals.dart';
import '../modern_project_detail.dart';
import 'modern_chips.dart';

/// Full content for a given [SectionId], rendered in plain logical pixels
/// (sans) — the single source shared by [DesktopContentPanel] (wide
/// viewport) and [ModernSectionScreen] (mobile push destination).
class ModernSectionView extends StatelessWidget {
  const ModernSectionView({super.key, required this.id});

  final SectionId id;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    switch (id) {
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
        return _AboutContent(profile: controller.profile);
      case SectionId.resume:
        return _ResumeContent(profile: controller.profile);
      case SectionId.contact:
        return Column(
          children: [
            for (final l in controller.profile.links) _ContactRow(link: l),
          ],
        );
      case SectionId.github:
        final github = controller.profile.links
            .firstWhereOrNull((l) => l.type == ContactType.github);
        return github != null
            ? _ContactRow(link: github)
            : _EmptyNote(text: 'Not set yet.');
      case SectionId.now:
        final building =
            controller.projects.firstWhereOrNull((p) => p.isBuilding);
        return building != null
            ? _NowContent(project: building)
            : _EmptyNote(text: 'Nothing in progress.');
      case SectionId.extras:
        return _EmptyNote(text: 'More extras coming soon.');
    }
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTheme.sans(size: 12, color: AppColors.textSecondary),
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
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.to(() => ModernProjectDetail(project: project)),
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
                        ),
                      ),
                      StatusPill(isLive: project.isLive),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    project.subtitle,
                    style: AppTheme.sans(
                      size: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.description,
                    style: AppTheme.sans(
                      size: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final t in project.tech) TechChip(label: t),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.platforms.join(' · '),
                    style:
                        AppTheme.sans(size: 10.5, color: AppColors.textMuted),
                  ),
                  if (project.storeUrl != null) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => launchExternal(project.storeUrl!),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'View on Play Store',
                        style: AppTheme.sans(
                          size: 11.5,
                          weight: FontWeight.w600,
                          color: AppColors.accentSoft,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.only(bottom: 20),
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
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.company} · ${item.period}',
                  style:
                      AppTheme.sans(size: 11, color: AppColors.textSecondary),
                ),
                if (item.bullets.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  for (final bullet in item.bullets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '·  ',
                            style: AppTheme.sans(
                              size: 11.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              bullet,
                              style: AppTheme.sans(
                                size: 11.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
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
  const _AboutContent({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.tagline,
          style: AppTheme.sans(
            size: 13,
            weight: FontWeight.w600,
            color: AppColors.accentSoft,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          profile.bio,
          style: AppTheme.sans(size: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        Text(
          '${profile.location} · ${profile.yearsExperience}+ years',
          style: AppTheme.sans(size: 11.5, color: AppColors.textMuted),
        ),
        if (profile.links.isNotEmpty) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final l in profile.links) _ContactChip(link: l),
            ],
          ),
        ],
      ],
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.link});

  final ContactLink link;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchExternal(link.url),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.tile,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(contactIcon(link.type), size: 13, color: AppColors.accentSoft),
            const SizedBox(width: 6),
            Text(
              link.label,
              style: AppTheme.sans(size: 11, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeContent extends StatelessWidget {
  const _ResumeContent({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final assetPath = profile.resumeAssetPath;
        if (assetPath != null) {
          openResumeAsset(assetPath);
        } else {
          launchExternal(profile.resumeUrl ?? '');
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.tile,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.description_outlined,
              size: 18,
              color: AppColors.iconCoral,
            ),
            const SizedBox(width: 10),
            Text(
              'Download résumé',
              style: AppTheme.sans(
                size: 13,
                weight: FontWeight.w600,
                color: AppColors.accentSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.link});

  final ContactLink link;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => launchExternal(link.url),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.tileHover,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                contactIcon(link.type),
                size: 18,
                color: AppColors.accentSoft,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              link.label,
              style: AppTheme.sans(size: 13, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _NowContent extends StatelessWidget {
  const _NowContent({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.name,
          style: AppTheme.sans(
            size: 14,
            weight: FontWeight.w600,
            color: AppColors.accentSoft,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          project.buildingNote ?? project.description,
          style: AppTheme.sans(size: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
