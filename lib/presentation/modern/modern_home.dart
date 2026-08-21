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
import '../shared/section_placeholder_screen.dart';
import 'widgets/commit_heatmap_widget.dart';
import 'widgets/identity_card.dart';
import 'widgets/modern_status_bar.dart';
import 'widgets/now_building_widget.dart';
import 'widgets/section_icon_tile.dart';
import 'widgets/time_frame_control.dart';

/// The scrollable body of the modern launcher: status bar and feature bands.
/// The dock is anchored separately by [ModernShell] so it stays pinned to
/// the bottom of the screen regardless of content height. All content is
/// read from [PortfolioController] — nothing here duplicates portfolio data.
class ModernHome extends StatelessWidget {
  const ModernHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 18.h),
          const ModernStatusBar(),
          SizedBox(height: 20.h),
          _BandA(controller: controller),
          SizedBox(height: 20.h),
          _BandB(controller: controller),
          SizedBox(height: 20.h),
          _BandC(controller: controller),
          SizedBox(height: 20.h),
          const IdentityCard(),
        ],
      ),
    );
  }
}

/// Now Building (left) beside a 2x2 cluster of Projects/Experience/
/// Skills/About tiles (right).
class _BandA extends StatelessWidget {
  const _BandA({required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    final desktopSelection = Get.find<DesktopSelectionController>();
    final hasPanel =
        MediaQuery.sizeOf(context).width >= LayoutBreakpoints.desktopPanel;

    // The observable must be read unconditionally inside the builder — a
    // short-circuited `hasPanel ? selected.value : null` means Obx sees zero
    // observables read on narrow viewports, and GetX's own safety check
    // throws ("the improper use of a GetX has been detected") instead of
    // silently no-op'ing.
    return Obx(() {
      final selectedValue = desktopSelection.selected.value;
      final selected = hasPanel ? selectedValue : null;

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(flex: 2, child: NowBuildingWidget()),
            SizedBox(width: 11.w),
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
                  SizedBox(height: 11.w),
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

  /// On wide viewports with the [DesktopContentPanel] showing, tapping one
  /// of these tiles switches the panel's content instead of navigating away
  /// (which would leave the mockup+panel composition). On phones (or a
  /// narrower desktop window without the panel) it navigates as normal.
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
          Get.to(() => SectionPlaceholderScreen(title: section.title));
        }
      },
    );
  }
}

/// GitHub + Résumé quick-launch tiles beside the Time Frame era switcher.
class _BandB extends StatelessWidget {
  const _BandB({required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    final github = controller.profile.links
        .firstWhereOrNull((l) => l.type == ContactType.github);
    final era = Get.find<EraController>();

    // Obx wraps IntrinsicHeight from the outside — see the comment in
    // _BandA for why it can't sit nested inside the subtree it measures.
    return Obx(
      () => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              flex: 2,
              child: TimeFrameControl(
                era: era.era.value,
                onTap: era.toggleEra,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Commit heatmap (left) beside a 2x2 cluster of the four project app tiles.
class _BandC extends StatelessWidget {
  const _BandC({required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    final projects = controller.projects;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(flex: 2, child: CommitHeatmapWidget()),
          SizedBox(width: 11.w),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                for (var i = 0; i + 1 < projects.length; i += 2) ...[
                  if (i > 0) SizedBox(height: 11.w),
                  Row(
                    children: [
                      Expanded(child: _projectTile(projects[i])),
                      SizedBox(width: 11.w),
                      Expanded(child: _projectTile(projects[i + 1])),
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

  Widget _projectTile(Project project) {
    final visual = projectVisual(project.id);
    return SectionIconTile(
      icon: visual.icon,
      color: visual.color,
      label: project.name.split(' ').first,
      onTap: () => Get.to(
        () => SectionPlaceholderScreen(
          title: project.name,
          subtitle: project.subtitle,
        ),
      ),
    );
  }
}
