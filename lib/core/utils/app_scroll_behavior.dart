import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Enables mouse/trackpad/stylus drag-to-scroll everywhere on web/desktop,
/// on top of Flutter's touch-only default — every `SingleChildScrollView`
/// (launcher, side panels, detail routes) becomes draggable with a mouse,
/// and desktop gets normal scrollbar behaviour.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}
