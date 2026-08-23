import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/portfolio_controller.dart';
import '../../../core/controllers/retro_controller.dart';
import '../../../core/enums/section_id.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/url_utils.dart';
import '../../../domain/entities/contact_link.dart';
import '../../../domain/entities/experience_item.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/skill_group.dart';
import '../../shared/project_visuals.dart';

/// Desktop-only companion panel shown beside the retro handset on wide
/// viewports. Mirrors [RetroController.highlighted] live — moving the
/// highlight (d-pad, keypad, or on-screen grid) updates this panel
/// instead of navigating anywhere, the same way the modern shell's
/// desktop panel tracks its own tile selection.
///
/// Deliberately mono/retro styled rather than reusing the modern shell's
/// panel look, to stay in-character with the rest of this handset.
class RetroContentPanel extends StatelessWidget {
  const RetroContentPanel({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final retro = Get.find<RetroController>();

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Container(
        padding: EdgeInsets.all(22.w),
        decoration: BoxDecoration(
          color: AppColors.retroBody,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final section = retro.current;
              return Row(
                children: [
                  Icon(section.icon, size: 18.sp, color: section.color),
                  SizedBox(width: 8.w),
                  Text(
                    section.title,
                    style:
                        AppTheme.mono(size: 15.sp, weight: FontWeight.w500),
                  ),
                ],
              );
            }),
            SizedBox(height: 18.h),
            Expanded(
              child: Obx(
                () => SingleChildScrollView(
                  child: _buildContent(controller, retro.current.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(PortfolioController controller, SectionId id) {
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
        return _TextBlock(
          heading: controller.profile.tagline,
          text: controller.profile.bio,
        );
      case SectionId.resume:
        return _ResumeRow(controller: controller);
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
            : const _TextBlock(text: 'Not set yet.');
      case SectionId.now:
        final building =
            controller.projects.firstWhereOrNull((p) => p.isBuilding);
        return building != null
            ? _TextBlock(
                heading: building.name,
                text: building.buildingNote ?? building.description,
              )
            : const _TextBlock(text: 'Nothing in progress right now.');
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
                  style:
                      AppTheme.mono(size: 9.sp, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  project.description,
                  style: AppTheme.mono(size: 9.sp, color: AppColors.textMuted),
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
            Text(
              item.bullets.first,
              style: AppTheme.mono(size: 9.sp, color: AppColors.textMuted),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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

class _ResumeRow extends StatelessWidget {
  const _ResumeRow({required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final assetPath = controller.profile.resumeAssetPath;
        if (assetPath != null) {
          openResumeAsset(assetPath);
        } else {
          launchExternal(controller.profile.resumeUrl ?? '');
        }
      },
      behavior: HitTestBehavior.opaque,
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

  IconData get _icon => switch (link.type) {
        ContactType.github => Icons.code,
        ContactType.linkedin => Icons.person_pin,
        ContactType.email => Icons.mail_outline,
        ContactType.whatsapp => Icons.chat_bubble_outline,
        ContactType.website => Icons.link,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: GestureDetector(
        onTap: () => launchExternal(link.url),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Icon(_icon, size: 14.sp, color: AppColors.accentSoft),
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
  const _TextBlock({this.heading, required this.text});

  final String? heading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null) ...[
          Text(
            heading!,
            style: AppTheme.mono(
              size: 11.sp,
              weight: FontWeight.w500,
              color: AppColors.accentSoft,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        Text(
          text,
          style: AppTheme.mono(size: 10.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
