import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A vector-drawn phone bezel (body, screen cutout, camera pill, side
/// buttons) used to present the launcher as "a phone" on wide viewports.
/// Drawn with Flutter primitives rather than a raster asset so it stays
/// crisp at any size.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  final double width;
  final double height;
  final Widget child;

  static const double _bezelWidth = 12;
  static const double _outerRadiusFactor = 0.16;

  @override
  Widget build(BuildContext context) {
    final outerRadius = width * _outerRadiusFactor;
    final innerRadius = (outerRadius - _bezelWidth).clamp(0.0, outerRadius);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Side buttons — drawn first so the body sits on top of their
          // inner edge, matching how buttons peek out from a real chassis.
          _SideButton(
            top: height * 0.16,
            height: height * 0.05,
            width: 3,
            left: -3,
          ),
          _SideButton(
            top: height * 0.23,
            height: height * 0.09,
            width: 3,
            left: -3,
          ),
          _SideButton(
            top: height * 0.34,
            height: height * 0.09,
            width: 3,
            left: -3,
          ),
          _SideButton(
            top: height * 0.2,
            height: height * 0.11,
            width: 3,
            right: -3,
          ),

          // Body: metallic border + screen cutout.
          Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(_bezelWidth),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(outerRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.textMuted.withOpacity(0.5),
                  AppColors.key,
                  AppColors.pageBlack,
                ],
                stops: const [0, 0.5, 1],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.pageBlack.withOpacity(0.6),
                  blurRadius: 36,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(innerRadius),
              child: ColoredBox(
                color: AppColors.pageBlack,
                child: child,
              ),
            ),
          ),

          // Camera / speaker pill.
          Positioned(
            top: _bezelWidth * 1.6,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: width * 0.28,
                height: 7,
                decoration: BoxDecoration(
                  color: AppColors.pageBlack,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.textMuted.withOpacity(0.4),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small rounded bump on the frame's edge standing in for a volume
/// rocker or power button.
class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.top,
    required this.height,
    required this.width,
    this.left,
    this.right,
  });

  final double top;
  final double height;
  final double width;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.key,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
