import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Full-screen first-visit intro: a purple rift forms, a year readout
/// scrambles down to "2003", the "SHAKIL.EXE" wordmark fades in beneath,
/// then everything fades out to reveal the shell underneath. Plays once,
/// ~2.2s, or is skipped by a tap anywhere.
class TimeIntroOverlay extends StatefulWidget {
  const TimeIntroOverlay({super.key, required this.onDone});

  /// Called exactly once, either when the sequence completes or when the
  /// visitor taps to skip it.
  final VoidCallback onDone;

  @override
  State<TimeIntroOverlay> createState() => _TimeIntroOverlayState();
}

class _TimeIntroOverlayState extends State<TimeIntroOverlay>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 2200);
  static const String _finalYear = '2003';

  late final AnimationController _controller;
  late final Animation<double> _riftOpacity;
  late final Animation<double> _riftScale;
  late final Animation<double> _yearReveal;
  late final Animation<double> _wordmarkOpacity;
  late final Animation<double> _fadeOut;

  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener(_handleStatus)
      ..forward();

    _riftOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _riftScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
    );
    _yearReveal = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.45, curve: Curves.easeIn),
    );
    _wordmarkOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 0.85, curve: Curves.easeIn),
    );
    _fadeOut = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
    );
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _finish();
  }

  void _finish() {
    if (_done) return;
    _done = true;
    widget.onDone();
  }

  void _skip() {
    if (_done) return;
    _controller.stop();
    _finish();
  }

  /// The year readout scrambles through pseudo-random digits before
  /// settling left-to-right on [_finalYear], e.g. "8461" -> … -> "2003".
  String _scrambledYear(double t) {
    if (t <= 0) return '----';
    if (t >= 1) return _finalYear;
    final settled = (t * _finalYear.length).floor();
    final buffer = StringBuffer();
    for (var i = 0; i < _finalYear.length; i++) {
      if (i < settled) {
        buffer.write(_finalYear[i]);
      } else {
        final digit = ((t * 97) + (i * 31)).remainder(10).floor().abs();
        buffer.write(digit);
      }
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _skip,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Opacity(
              opacity: 1 - _fadeOut.value,
              child: ColoredBox(
                color: AppColors.pageBlack,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: _riftOpacity.value,
                              child: Transform.scale(
                                scale: _riftScale.value,
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.timeWarpSoft
                                            .withOpacity(0.55),
                                        AppColors.timeWarp.withOpacity(0.25),
                                        AppColors.timeWarp.withOpacity(0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: _yearReveal.value,
                              child: Text(
                                _scrambledYear(_yearReveal.value),
                                style: AppTheme.mono(
                                  size: 36,
                                  weight: FontWeight.bold,
                                  color: AppColors.timeWarpSoft,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Opacity(
                        opacity: _wordmarkOpacity.value,
                        child: Text(
                          'SHAKIL.EXE',
                          style: AppTheme.mono(
                            size: 13,
                            color: AppColors.textSecondary,
                          ).copyWith(letterSpacing: 6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
