import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/enums/section_id.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../shared/section_config.dart';
import 'widgets/retro_section_view.dart';

/// In-character mobile destination for a retro section: an LCD-framed panel
/// matching the handset's own screen (mono, [AppColors.retroScreen]), pushed
/// when [RetroController.openHighlighted] fires on a narrow viewport.
class RetroSectionScreen extends StatelessWidget {
  const RetroSectionScreen({super.key, required this.id});

  final SectionId id;

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.escape:
      case LogicalKeyboardKey.backspace:
        Get.back();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    final section = kSections.firstWhere((s) => s.id == id);

    return Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        backgroundColor: AppColors.pageBlack,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.retroScreen,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(section.icon, size: 18.sp, color: section.color),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          section.title,
                          style: AppTheme.mono(
                            size: 14.sp,
                            weight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: Get.back,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          '‹ Back',
                          style: AppTheme.mono(
                            size: 11.sp,
                            color: AppColors.accentSoft,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(height: 1, color: Colors.white.withOpacity(0.06)),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: RetroSectionView(id: id),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
