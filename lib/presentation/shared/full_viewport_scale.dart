import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Re-points ScreenUtil at the real, full viewport.
///
/// [ModernShell] and [RetroShell] each re-configure the same global
/// ScreenUtil singleton to their own design box during their own build —
/// on wide viewports that's a small phone-frame/handset cutout, not the
/// actual window. A full-screen overlay that sits OUTSIDE those shells
/// (e.g. the root time-travel overlays) builds as a later sibling in the
/// same frame and would otherwise inherit whichever tiny cutout the shell
/// last configured. Call this at the top of such an overlay's own
/// `build()`, the same defensive "set it myself right before I need it"
/// pattern the shells use.
void configureFullViewportScale(BuildContext context) {
  ScreenUtil.configure(
    designSize: const Size(375, 812),
    data: MediaQuery.of(context),
  );
}
