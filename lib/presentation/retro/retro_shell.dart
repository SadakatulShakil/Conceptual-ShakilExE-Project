import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/controllers/era_controller.dart';
import '../../core/controllers/retro_controller.dart';
import '../../core/theme/app_colors.dart';
import '../shared/layout_breakpoints.dart';
import 'retro_handset.dart';
import 'widgets/retro_content_panel.dart';

/// Digit-key -> grid-index mapping for both the top-row and numpad digits.
///
/// Not `const`: [LogicalKeyboardKey] overrides `==`/`hashCode`, which Dart
/// doesn't allow as a compile-time-constant map key.
final Map<LogicalKeyboardKey, int> _kDigitKeys = {
  LogicalKeyboardKey.digit1: 1,
  LogicalKeyboardKey.digit2: 2,
  LogicalKeyboardKey.digit3: 3,
  LogicalKeyboardKey.digit4: 4,
  LogicalKeyboardKey.digit5: 5,
  LogicalKeyboardKey.digit6: 6,
  LogicalKeyboardKey.digit7: 7,
  LogicalKeyboardKey.digit8: 8,
  LogicalKeyboardKey.digit9: 9,
  LogicalKeyboardKey.numpad1: 1,
  LogicalKeyboardKey.numpad2: 2,
  LogicalKeyboardKey.numpad3: 3,
  LogicalKeyboardKey.numpad4: 4,
  LogicalKeyboardKey.numpad5: 5,
  LogicalKeyboardKey.numpad6: 6,
  LogicalKeyboardKey.numpad7: 7,
  LogicalKeyboardKey.numpad8: 8,
  LogicalKeyboardKey.numpad9: 9,
};

class RetroShell extends StatefulWidget {
  const RetroShell({super.key});

  @override
  State<RetroShell> createState() => _RetroShellState();
}

class _RetroShellState extends State<RetroShell> {
  static const double _wideBreakpoint = LayoutBreakpoints.wide;
  static const double _panelBreakpoint = LayoutBreakpoints.desktopPanel;

  static const double _wideHandsetWidth = 380;
  static final double _designAspect =
      RetroHandset.designSize.width / RetroHandset.designSize.height;

  late final RetroController _retro;
  late final EraController _era;

  @override
  void initState() {
    super.initState();
    _retro = Get.find<RetroController>();
    _era = Get.find<EraController>();

    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKey);
    super.dispose();
  }

  bool _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final digit = _kDigitKeys[event.logicalKey];
    if (digit != null) {
      _retro.focus(digit);
      return true;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
        _retro.moveUp();
        return true;
      case LogicalKeyboardKey.arrowDown:
        _retro.moveDown();
        return true;
      case LogicalKeyboardKey.arrowLeft:
        _retro.moveLeft();
        return true;
      case LogicalKeyboardKey.arrowRight:
        _retro.moveRight();
        return true;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        _retro.confirmOpen();
        return true;
      case LogicalKeyboardKey.escape:
      case LogicalKeyboardKey.backspace:
        _retro.goBack();
        return true;
      case LogicalKeyboardKey.numberSign:
        _era.toggleEra();
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final isWide = size.width >= _wideBreakpoint;
    final showPanel = size.width >= _panelBreakpoint;
    _retro.hasPanel = showPanel;

    double handsetWidth;
    double handsetHeight;

    if (isWide) {
      handsetWidth = _wideHandsetWidth;
      handsetHeight = handsetWidth / _designAspect;

      final maxAvailableHeight = size.height * 0.92;
      if (handsetHeight > maxAvailableHeight) {
        final shrink = maxAvailableHeight / handsetHeight;
        handsetHeight = maxAvailableHeight;
        handsetWidth *= shrink;
      }
    } else {

      final availableWidth = size.width - 32;
      final availableHeight =
          size.height - mediaQuery.padding.vertical - 32;
      final widthFromHeight = availableHeight * _designAspect;
      if (widthFromHeight <= availableWidth) {
        handsetWidth = widthFromHeight;
        handsetHeight = availableHeight;
      } else {
        handsetWidth = availableWidth;
        handsetHeight = availableWidth / _designAspect;
      }
    }

    ScreenUtil.configure(
      designSize: RetroHandset.designSize,
      data: mediaQuery.copyWith(size: Size(handsetWidth, handsetHeight)),
    );

    // Deliberately NOT `const`: a canonical `const RetroHandset()` would be
    // the exact same object every time this method runs, and Flutter skips
    // calling `build()` again on an unchanged (`==`) widget — silently
    // freezing its `.w/.h/.sp` at whatever scale was active the first time
    // it was ever built. A fresh instance forces it to rebuild, and the
    // SizedBox + ClipRect hard-bound it so a wrong scale can never balloon
    // it past this box.
    final handset = SizedBox(
      width: handsetWidth,
      height: handsetHeight,
      child: ClipRect(child: RetroHandset()),
    );

    Widget content;
    if (showPanel) {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SizedBox(
            height: handsetHeight,
            child: Row(
              children: [
                handset,
                const SizedBox(width: 32),
                Expanded(child: RetroContentPanel(height: handsetHeight)),
              ],
            ),
          ),
        ),
      );
    } else {
      content = Center(child: handset);
    }

    return ColoredBox(
      color: AppColors.pageBlack,
      child: SafeArea(child: content),
    );
  }
}
