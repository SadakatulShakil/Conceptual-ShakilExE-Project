import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/portfolio_controller.dart';
import '../../../core/enums/section_id.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/url_utils.dart';
import '../../../domain/entities/contact_link.dart';
import '../../../domain/entities/education.dart';
import '../../../domain/entities/experience_item.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/skill_group.dart';
import '../../shared/clickable.dart';
import '../../shared/contact_visuals.dart';
import '../../shared/project_visuals.dart';
import '../../shared/resume_viewer_screen.dart';

/// Full content for a given [SectionId], rendered mono/screenutil — the
/// single source shared by [RetroContentPanel] (wide viewport) and
/// [RetroSectionScreen] (mobile push destination).
class RetroSectionView extends StatelessWidget {
  const RetroSectionView({super.key, required this.id});

  final SectionId id;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    switch (id) {
      case SectionId.projects:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final p in controller.projects) _ProjectRow(project: p),
          ],
        );
      case SectionId.experience:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final e in controller.experience) _ExperienceRow(item: e),
          ],
        );
      case SectionId.skills:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final g in controller.skills) _SkillRow(group: g),
          ],
        );
      case SectionId.about:
        return _AboutContent(
          profile: controller.profile,
          education: controller.education,
        );
      case SectionId.resume:
        return _ResumeRow(controller: controller);
      case SectionId.contact:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final l in controller.profile.links) _ContactRow(link: l),
          ],
        );
      case SectionId.github:
        final github = controller.profile.links
            .firstWhereOrNull((l) => l.type == ContactType.github);
        return github != null
            ? _ContactRow(link: github)
            : const _TextBlock(text: 'Not set yet.');
      case SectionId.now:
        final building = controller.projects.where((p) => p.isBuilding).toList();
        return building.isEmpty
            ? const _TextBlock(text: 'Nothing in progress right now.')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [for (final p in building) _ProjectRow(project: p)],
              );
      case SectionId.extras:
        return const _TextBlock(text: 'More extras coming soon.');
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
      padding: EdgeInsets.only(bottom: 16.h),
      child: Clickable(
        onTap: project.storeUrl != null
            ? () => launchExternal(project.storeUrl!)
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Icon(visual.icon, size: 18.sp, color: visual.color),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.name,
                          style: AppTheme.mono(
                            size: 12.sp,
                            weight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        project.isLive ? 'LIVE' : 'WIP',
                        style: AppTheme.mono(
                          size: 8.sp,
                          color: project.isLive
                              ? AppColors.accentSoft
                              : AppColors.timeWarpSoft,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    project.subtitle,
                    style: AppTheme.mono(
                      size: 9.sp,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    project.description,
                    style:
                        AppTheme.mono(size: 9.sp, color: AppColors.textMuted),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'tech: ${project.tech.join(', ')}',
                    style: AppTheme.mono(
                      size: 8.5.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    project.platforms.join(' · '),
                    style:
                        AppTheme.mono(size: 8.5.sp, color: AppColors.textMuted),
                  ),
                  if (project.storeUrl != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      '> view on play store',
                      style: AppTheme.mono(
                        size: 9.sp,
                        color: AppColors.accentSoft,
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
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.role,
            style: AppTheme.mono(size: 12.sp, weight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 3.h),
          Text(
            '${item.company} · ${item.period}',
            style: AppTheme.mono(size: 9.sp, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (item.bullets.isNotEmpty) ...[
            SizedBox(height: 4.h),
            for (final bullet in item.bullets)
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  '- $bullet',
                  style:
                      AppTheme.mono(size: 9.sp, color: AppColors.textMuted),
                ),
              ),
          ],
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
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.category,
            style: AppTheme.mono(size: 10.sp, weight: FontWeight.w500),
          ),
          SizedBox(height: 3.h),
          Text(
            group.skills.join(' · '),
            style: AppTheme.mono(size: 9.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({required this.profile, required this.education});

  final Profile profile;
  final List<Education> education;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.tagline,
          style: AppTheme.mono(
            size: 11.sp,
            weight: FontWeight.w500,
            color: AppColors.accentSoft,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          profile.bio,
          style: AppTheme.mono(size: 10.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: 10.h),
        Text(
          '${profile.location} · ${profile.yearsExperience}+ yrs',
          style: AppTheme.mono(size: 9.sp, color: AppColors.textMuted),
        ),
        if (education.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text(
            'EDUCATION',
            style: AppTheme.mono(size: 10.sp, weight: FontWeight.w500),
          ),
          SizedBox(height: 6.h),
          for (final e in education)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                '${e.degree} — ${e.institution} — ${e.period} · ${e.grade}',
                style: AppTheme.mono(
                  size: 9.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
        SizedBox(height: 6.h),
        Text(
          'Languages: Bangla (native), English (professional)',
          style: AppTheme.mono(size: 9.sp, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _ResumeRow extends StatelessWidget {
  const _ResumeRow({required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: () => openResume(controller.profile),
      child: Row(
        children: [
          Icon(
            Icons.description_outlined,
            size: 16.sp,
            color: AppColors.iconCoral,
          ),
          SizedBox(width: 8.w),
          Text(
            'Download résumé',
            style: AppTheme.mono(size: 10.sp, color: AppColors.accentSoft),
          ),
        ],
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
      padding: EdgeInsets.only(bottom: 10.h),
      child: Clickable(
        onTap: () => launchExternal(link.url),
        child: Row(
          children: [
            Icon(
              contactIcon(link.type),
              size: 14.sp,
              color: AppColors.accentSoft,
            ),
            SizedBox(width: 8.w),
            Text(
              link.label,
              style: AppTheme.mono(size: 10.sp, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTheme.mono(size: 10.sp, color: AppColors.textSecondary),
    );
  }
}
