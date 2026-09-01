import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/desktop_selection_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/glass_card.dart';
import '../../shared/section_config.dart';
import 'modern_section_view.dart';

/// Desktop-only companion panel shown beside the [PhoneFrame] mockup: a
/// richer view of whichever section is active (Projects by default).
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
    final selection = Get.find<DesktopSelectionController>();

    return SizedBox(
      width: double.infinity,
      height: height,
      child: GlassCard(
        radius: 20,
        padding: const EdgeInsets.all(22),
        child: Column(
          // `stretch`, not `start`: gives the Expanded/SingleChildScrollView
          // below a TIGHT (full panel) width, so its scrollbar hugs the
          // panel's true right edge. `start` gave it a LOOSE width instead,
          // so it shrank to match the capped-width content, leaving the
          // scrollbar stranded with a gap of empty panel to its right. The
          // inner ConstrainedBox still caps and left-aligns the content.
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: ModernSectionView(id: selection.selected.value),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
