/// Shared viewport breakpoints for the modern shell's responsive layout.
class LayoutBreakpoints {
  LayoutBreakpoints._();

  /// Above this width the launcher is composited inside [PhoneFrame]
  /// instead of filling the real screen.
  static const double wide = 600;

  /// Above this width a [DesktopContentPanel] appears beside the mockup.
  static const double desktopPanel = 900;
}
