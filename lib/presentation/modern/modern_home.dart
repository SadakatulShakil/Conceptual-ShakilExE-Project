import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/controllers/desktop_selection_controller.dart';
import '../../core/controllers/era_controller.dart';
import '../../core/controllers/portfolio_controller.dart';
import '../../core/enums/section_id.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/url_utils.dart';
import '../../domain/entities/contact_link.dart';
import '../../domain/entities/project.dart';
import '../shared/layout_breakpoints.dart';
import '../shared/project_visuals.dart';
import '../shared/section_config.dart';
import 'modern_project_detail.dart';
import 'modern_section_screen.dart';
import 'widgets/commit_heatmap_widget.dart';
import 'widgets/identity_card.dart';
import 'widgets/modern_status_bar.dart';
import 'widgets/now_building_widget.dart';
import 'widgets/section_icon_tile.dart';
import 'widgets/time_frame_control.dart';

class ModernHome extends StatelessWidget {
  const ModernHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    final isWide =
        MediaQuery.sizeOf(context).width >= LayoutBreakpoints.wide;
    final bandGap = isWide ? 14.h : 10.h;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: bandGap),
          const ModernStatusBar(),
          SizedBox(height: bandGap),
          _BandA(controller: controller),
          SizedBox(height: bandGap),
          _BandB(controller: controller),
          SizedBox(height: bandGap),
          _BandC(controller: controller),
          SizedBox(height: bandGap),
          const IdentityCard(),
        ],
      ),
    );
  }
}

class _BandA extends StatelessWidget {
  const _BandA({required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    final desktopSelection = Get.find<DesktopSelectionController>();
    final hasPanel =
        MediaQuery.sizeOf(context).width >= LayoutBreakpoints.desktopPanel;
    final isWide =
        MediaQuery.sizeOf(context).width >= LayoutBreakpoints.wide;
    final bandGap = isWide ? 14.h : 5.h;

    return Obx(() {
      final selectedValue = desktopSelection.selected.value;
      final selected = hasPanel ? selectedValue : null;

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(flex: 3, child: NowBuildingWidget()),
            SizedBox(width: 10.w),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _sectionTile(
                          context,
                          SectionId.projects,
                          hasPanel,
                          selected,
                        ),
                      ),
                      SizedBox(width: 11.w),
                      Expanded(
                        child: _sectionTile(
                          context,
                          SectionId.experience,
                          hasPanel,
                          selected,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: bandGap),
                  Row(
                    children: [
                      Expanded(
                        child: _sectionTile(
                          context,
                          SectionId.skills,
                          hasPanel,
                          selected,
                        ),
                      ),
                      SizedBox(width: 11.w),
                      Expanded(
                        child: _sectionTile(
                          context,
                          SectionId.about,
                          hasPanel,
                          selected,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _sectionTile(
    BuildContext context,
    SectionId id,
    bool hasPanel,
    SectionId? selected,
  ) {
    final section = kSections.firstWhere((s) => s.id == id);

    return SectionIconTile(
      icon: section.icon,
      color: section.color,
      label: section.shortTitle,
      selected: selected == id,
      onTap: () {
        if (hasPanel) {
          Get.find<DesktopSelectionController>().selected.value = id;
        } else {
          Get.to(() => ModernSectionScreen(id: id));
        }
      },
    );
  }
}

class _BandB extends StatelessWidget {
  const _BandB({required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    final github = controller.profile.links
        .firstWhereOrNull((l) => l.type == ContactType.github);
    final era = Get.find<EraController>();


    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SectionIconTile(
              icon: Icons.code_rounded,
              color: AppColors.iconWhite,
              label: 'GitHub',
              onTap: () => launchExternal(github?.url ?? ''),
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: SectionIconTile(
              icon: Icons.description_outlined,
              color: AppColors.iconCoral,
              label: 'Résumé',
              onTap: () {
                final assetPath = controller.profile.resumeAssetPath;
                if (assetPath != null) {
                  openResumeAsset(assetPath);
                } else {
                  launchExternal(controller.profile.resumeUrl ?? '');
                }
              },
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            flex: 4,
            child: TimeFrameControl(
              era: era.era.value,
              onTap: era.toggleEra,
            ),
          ),
        ],
      ),
    );
  }
}

class _BandC extends StatelessWidget {
  const _BandC({required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    final projects = controller.projects;
    final hasPanel =
        MediaQuery.sizeOf(context).width >= LayoutBreakpoints.desktopPanel;

    final isWide =
        MediaQuery.sizeOf(context).width >= LayoutBreakpoints.wide;
    final bandGap = isWide ? 14.h : 5.h;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(flex: 3, child: CommitHeatmapWidget()),
          SizedBox(width: 11.w),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                for (var i = 0; i + 1 < projects.length; i += 2) ...[
                  if (i > 0) SizedBox(height: bandGap),
                  Row(
                    children: [
                      Expanded(
                        child: _projectTile(projects[i], hasPanel),
                      ),
                      SizedBox(width: 11.w),
                      Expanded(
                        child: _projectTile(projects[i + 1], hasPanel),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _projectTile(Project project, bool hasPanel) {
    final visual = projectVisual(project.id);
    return SectionIconTile(
      icon: visual.icon,
      color: visual.color,
      label: project.name.split(' ').first,
      onTap: () {
        if (hasPanel) {
          Get.find<DesktopSelectionController>().selected.value =
              SectionId.projects;
        } else {
          Get.to(() => ModernProjectDetail(project: project));
        }
      },
    );
  }
}
