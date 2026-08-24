import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/controllers/era_controller.dart';
import '../../../core/controllers/retro_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/clickable.dart';

/// The soft-key row, circular d-pad with an OK center, and the call/end
/// pills beneath the LCD.
class RetroNavCluster extends StatelessWidget {
  const RetroNavCluster({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RetroController>();
    final era = Get.find<EraController>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _PillButton(
              icon: Icons.call,
              background: AppColors.accent.withOpacity(0.18),
              foreground: AppColors.accentSoft,
              onTap: controller.openContact,
            ),
            _DPad(controller: controller),
            Clickable(
              onTap: era.toggleEra,
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.timeWarp, width: 1.5),
                  color: AppColors.timeWarp.withOpacity(0.14),
                ),
                child: Text(
                  'Travel 2026',
                  style:
                  AppTheme.mono(size: 9.sp, color: AppColors.timeWarpSoft),
                ),
              ),
            ),
          ],
        ),
        // SizedBox(height: 14.h),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     _PillButton(
        //       icon: Icons.call,
        //       background: AppColors.accent.withOpacity(0.18),
        //       foreground: AppColors.accentSoft,
        //       onTap: controller.openContact,
        //     ),
        //     SizedBox(width: 28.w),
        //     _PillButton(
        //       icon: Icons.call_end,
        //       background: AppColors.danger.withOpacity(0.16),
        //       foreground: AppColors.danger,
        //       onTap: controller.goBack,
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class _SoftKey extends StatelessWidget {
  const _SoftKey({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40.w,
        height: 26.h,
        decoration: BoxDecoration(
          color: AppColors.key,
          borderRadius: BorderRadius.circular(13.r),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 13.sp, color: AppColors.textSecondary),
      ),
    );
  }
}

class _DPad extends StatelessWidget {
  const _DPad({required this.controller});

  final RetroController controller;

  @override
  Widget build(BuildContext context) {
    final size = 84.w;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.key,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 6.h,
            child: _Chevron(
              icon: Icons.keyboard_arrow_up,
              onTap: controller.moveUp,
            ),
          ),
          Positioned(
            bottom: 6.h,
            child: _Chevron(
              icon: Icons.keyboard_arrow_down,
              onTap: controller.moveDown,
            ),
          ),
          Positioned(
            left: 6.w,
            child: _Chevron(
              icon: Icons.keyboard_arrow_left,
              onTap: controller.moveLeft,
            ),
          ),
          Positioned(
            right: 6.w,
            child: _Chevron(
              icon: Icons.keyboard_arrow_right,
              onTap: controller.moveRight,
            ),
          ),
          Clickable(
            onTap: controller.confirmOpen,
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                'OK',
                style: AppTheme.mono(size: 9.sp, color: AppColors.accentSoft),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Icon(icon, size: 16.sp, color: AppColors.textMuted),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: onTap,
      child: Container(
        height: 30.h,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(15.r),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(icon, size: 16.sp, color: foreground),
            SizedBox(width: 4.w),
            Text(
              icon == Icons.call ? 'Contact' : 'Dial',
              style: AppTheme.mono(size: 9.sp, color: foreground),
            ),
          ], ),
        ),
      ),
    );
  }
}
