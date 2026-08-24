import 'package:flutter/material.dart';

/// Wraps [child] so it shows a hand cursor on hover (desktop/web) in
/// addition to responding to taps — the shared tap wrapper used by every
/// interactive tile, key, row, and button across both shells.
///
/// [onTap] is nullable: pass `null` for a target that's conditionally
/// non-interactive (e.g. a project row with no store link) and the cursor
/// falls back to the platform default instead of falsely promising a tap.
class Clickable extends StatelessWidget {
  const Clickable({
    super.key,
    required this.onTap,
    required this.child,
    this.cursor = SystemMouseCursors.click,
  });

  final VoidCallback? onTap;
  final Widget child;
  final MouseCursor cursor;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onTap == null ? MouseCursor.defer : cursor,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: child,
      ),
    );
  }
}
