import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/clickable.dart';
import '../../shared/glass_card.dart';

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
    return Clickable(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            foregroundDecoration: selected
                ? BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(13.r),
                    border: Border.all(color: color.withOpacity(0.7), width: 1.5),
                  )
                : null,
            child: GlassCard(
              radius: 13.r,
              child: Center(
                child: Icon(icon, color: color, size: 23.sp),
              ),
            ),
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
