import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// A single square app-icon tile used across the modern launcher grid —
/// sections, projects, and quick links all render through this. When
/// [selected] is true (desktop viewports linking a tile to the active
/// [DesktopContentPanel] tab) it renders a highlighted border/fill in the
/// tile's own accent color.
class SectionIconTile extends StatelessWidget {
  const SectionIconTile({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: selected ? color.withOpacity(0.2) : AppColors.tile,
              borderRadius: BorderRadius.circular(14.r),
              border: selected
                  ? Border.all(color: color.withOpacity(0.7), width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 23.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: AppTheme.sans(
              size: 10.sp,
              color: Colors.white.withOpacity(0.72),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
