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

  // Sizing the phone mockup on wide viewports. The launcher's content is a
  // compact, glanceable dashboard rather than a full-height scrolling app,
  // so deriving the frame's height from a real phone's aspect ratio (or
  // from the browser window's height) leaves a large dead gap between the
  // content and the pinned dock. Instead, height comes from how tall the
  // content + dock actually are at the chosen width, so the mockup fits
  // itself — not the other way around.
  static const double _frameMaxWidth = 460;
  // Design-space height (at a 375-wide screen) needed for the status bar,
  // all four bands, the identity card, and the dock with comfortable
  // breathing room — measured from the actual widget sizes, not guessed.
  // Retune this if the content in ModernHome/ModernDock changes materially.
  static const double _designContentHeight = 620;
  static const double _frameBezel = 12;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWide = mediaQuery.size.width >= _wideBreakpoint;

    final launcher = SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              // Reserve room for the pinned dock below (~52.w button height +
              // 32.h vertical padding) plus its 10.h bottom margin plus the
              // bottom safe-area inset, with headroom so the last content
              // card (IdentityCard) never sits under it.
              padding: EdgeInsets.only(bottom: 148.h),
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
                padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
                child: const ModernDock(),
              ),
            ),
          ),
        ],
      ),
    );

    if (isWide) {
      // Pick the width first, then derive height from what the content
      // actually needs at that width — not a fixed aspect ratio. If that
      // would overflow the window, shrink both dimensions together so the
      // phone stays correctly proportioned.
      var frameWidth = _frameMaxWidth;
      var frameHeight =
          _designContentHeight * (frameWidth / 375) + _frameBezel * 2;

      final maxAvailableHeight = mediaQuery.size.height * 0.92;
      if (frameHeight > maxAvailableHeight) {
        final shrink = maxAvailableHeight / frameHeight;
        frameHeight = maxAvailableHeight;
        frameWidth *= shrink;
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

      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(_desktopWallpaper, fit: BoxFit.cover),
          ColoredBox(color: AppColors.screenBg.withOpacity(0.72)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              // Vertical centering only — the phone hugs the far left and
              // the panel fills the rest of the width, rather than the
              // whole group floating in the middle of the window.
              child: SizedBox(
                height: frameHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PhoneFrame(
                      width: frameWidth,
                      height: frameHeight,
                      child: launcher,
                    ),
                    if (showPanel) ...[
                      const SizedBox(width: 32),
                      Expanded(
                        child: DesktopContentPanel(height: frameHeight),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
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
