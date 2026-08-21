import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import 'modern_home.dart';
import 'widgets/desktop_content_panel.dart';
import 'widgets/modern_dock.dart';
import 'widgets/phone_frame.dart';

/// Modern (2026) shell: the touch launcher. On phones it fills the real
/// screen edge-to-edge; on wide viewports it's composited inside a
/// vector-drawn [PhoneFrame] so it reads as "a phone" rather than a bare
/// column, and on genuinely wide desktop viewports a [DesktopContentPanel]
/// sits beside it. A dark wallpaper fills the backdrop — a portrait crop on
/// phones, a landscape crop on wide viewports — with a screenBg scrim over
/// it for legibility. The dock is pinned to the true bottom of the
/// screen/frame (not just the end of the content column), matching a real
/// launcher's home-row.
class ModernShell extends StatelessWidget {
  const ModernShell({super.key});

  static const double _wideBreakpoint = 600;
  static const double _panelBreakpoint = 900;
  static const _mobileWallpaper = 'assets/images/modern_bg_mobile.jpg';
  static const _desktopWallpaper = 'assets/images/modern_bg_desktop.jpg';

  // Design proportions of the phone mockup on wide viewports. Height is
  // capped well below "fill the whole window" — the launcher's content is
  // deliberately compact (a single glanceable grid, not a full scrolling
  // feed), so a mockup that always stretches to the window's height leaves
  // a large empty gap above the dock. A moderately-sized, correctly
  // proportioned phone reads better than an oversized one with dead space.
  static const double _frameAspect = 375 / 812;
  static const double _frameMaxWidth = 420;
  static const double _frameMaxHeight = 760;
  static const double _frameBezel = 12;

  // Companion content panel shown beside the mockup on very wide viewports.
  static const double _panelGap = 40;
  static const double _panelMaxWidth = 440;
  static const double _panelMinWidth = 260;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWide = mediaQuery.size.width >= _wideBreakpoint;

    final launcher = SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 96.h),
              child: const SafeArea(bottom: false, child: ModernHome()),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
                child: const ModernDock(),
              ),
            ),
          ),
        ],
      ),
    );

    if (isWide) {
      // Size the mockup by available height first (capped so it never
      // looks oversized on huge monitors), then derive width from the
      // frame's design aspect ratio.
      var frameHeight =
          math.min(mediaQuery.size.height * 0.92, _frameMaxHeight);
      var frameWidth = frameHeight * _frameAspect;
      if (frameWidth > _frameMaxWidth) {
        frameWidth = _frameMaxWidth;
        frameHeight = frameWidth / _frameAspect;
      }

      final screenWidth = frameWidth - _frameBezel * 2;
      final screenHeight = frameHeight - _frameBezel * 2;

      // Re-point ScreenUtil's `.w/.h/.sp` scale at the frame's screen
      // cutout (not the full browser window), so tiles are sized for that
      // cutout instead of overflowing it.
      ScreenUtil.configure(
        data: mediaQuery.copyWith(size: Size(screenWidth, screenHeight)),
      );

      final showPanel = mediaQuery.size.width >= _panelBreakpoint;
      Widget mockupGroup = PhoneFrame(
        width: frameWidth,
        height: frameHeight,
        child: launcher,
      );

      if (showPanel) {
        final availableForRow = mediaQuery.size.width * 0.9;
        final panelWidth = (availableForRow - frameWidth - _panelGap)
            .clamp(_panelMinWidth, _panelMaxWidth);

        mockupGroup = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            mockupGroup,
            SizedBox(width: _panelGap),
            DesktopContentPanel(width: panelWidth, height: frameHeight),
          ],
        );
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(_desktopWallpaper, fit: BoxFit.cover),
          ColoredBox(color: AppColors.screenBg.withOpacity(0.72)),
          Center(child: mockupGroup),
        ],
      );
    }

    // flutter_screenutil's `.w/.h/.sp` scale off the physical window size —
    // on a real phone that IS the window, so no re-pointing is needed here.
    ScreenUtil.configure(data: mediaQuery);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(_mobileWallpaper, fit: BoxFit.cover),
        ColoredBox(color: AppColors.screenBg.withOpacity(0.72)),
        launcher,
      ],
    );
  }
}
