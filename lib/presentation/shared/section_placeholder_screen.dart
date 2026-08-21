import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Temporary destination for section/project taps until the real detail
/// screens land in Phase 4.
class SectionPlaceholderScreen extends StatelessWidget {
  const SectionPlaceholderScreen({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.screenBg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTheme.sans(size: 20.sp, weight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                SizedBox(height: 8.h),
                Text(
                  subtitle!,
                  style: AppTheme.sans(
                    size: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
