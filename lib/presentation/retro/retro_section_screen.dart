import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/enums/section_id.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../shared/clickable.dart';
import '../shared/layout_breakpoints.dart';
import '../shared/section_config.dart';
import 'widgets/retro_section_view.dart';

/// In-character mobile destination for a retro section: an LCD-framed panel
/// matching the handset's own screen (mono, [AppColors.retroScreen]), pushed
/// when [RetroController.openHighlighted] fires on a narrow viewport.
///
/// On a wide viewport the LCD-framed panel is centered in a capped-width
/// card instead of stretching edge-to-edge across the monitor.
class RetroSectionScreen extends StatelessWidget {
  const RetroSectionScreen({super.key, required this.id});

  final SectionId id;

  static const double _wideMaxWidth = 460;

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
    final isWide =
        MediaQuery.of(context).size.width >= LayoutBreakpoints.wide;

    final panel = Container(
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
                  style: AppTheme.mono(size: 14.sp, weight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Clickable(
                onTap: Get.back,
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
    );

    return Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        backgroundColor: AppColors.pageBlack,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: isWide
                ? Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: _wideMaxWidth),
                      child: panel,
                    ),
                  )
                : panel,
          ),
        ),
      ),
    );
  }
}
