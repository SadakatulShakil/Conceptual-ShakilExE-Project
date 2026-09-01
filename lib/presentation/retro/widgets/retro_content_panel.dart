import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/retro_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'retro_section_view.dart';

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
          // `stretch`, not `start`: gives the Expanded/SingleChildScrollView
          // below a TIGHT (full panel) width, so its scrollbar hugs the
          // panel's true right edge. `start` gave it a LOOSE width instead,
          // so it shrank to match the capped-width content, leaving the
          // scrollbar stranded with a gap of empty panel to its right. The
          // inner ConstrainedBox still caps and left-aligns the content.
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: RetroSectionView(id: retro.current.id),
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
