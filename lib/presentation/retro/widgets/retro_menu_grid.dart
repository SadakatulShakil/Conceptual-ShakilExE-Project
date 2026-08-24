import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/retro_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/clickable.dart';
import '../../shared/section_config.dart';

/// The retro home screen's 3x3 app menu — the nine [kSections] laid out by
/// `retroIndex` (row-major: 1,2,3 / 4,5,6 / 7,8,9). Tapping a cell opens it
/// directly (like tapping an app icon); the physical keypad only moves the
/// highlight instead.
class RetroMenuGrid extends StatelessWidget {
  const RetroMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RetroController>();
    final cells = List<SectionNav>.generate(
      9,
      (i) => kSections.firstWhere((s) => s.retroIndex == i + 1),
    );
    final gap = 6.w;

    return Obx(
      () => Column(
        children: [
          for (var row = 0; row < 3; row++) ...[
            if (row > 0) SizedBox(height: gap),
            Row(
              children: [
                for (var col = 0; col < 3; col++) ...[
                  if (col > 0) SizedBox(width: gap),
                  Expanded(
                    child: _MenuCell(
                      section: cells[row * 3 + col],
                      selected: controller.highlighted.value ==
                          cells[row * 3 + col].retroIndex,
                      onTap: () => controller
                          .openIndex(cells[row * 3 + col].retroIndex),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MenuCell extends StatelessWidget {
  const _MenuCell({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final SectionNav section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: selected
                ? AppColors.accentSoft.withOpacity(0.12)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10.r),
            border: selected
                ? Border.all(color: AppColors.accentSoft, width: 1.5)
                : null,
          ),
          child: Stack(
            children: [
              Positioned(
                left: 4.w,
                top: 3.h,
                child: Text(
                  '${section.retroIndex}',
                  style: AppTheme.mono(
                    size: 7.sp,
                    color:
                        selected ? AppColors.accentSoft : AppColors.textMuted,
                  ),
                ),
              ),
              Center(
                child: Icon(section.icon, size: 19.sp, color: section.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
