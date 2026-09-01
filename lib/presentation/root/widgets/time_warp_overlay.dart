import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../core/controllers/era_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Background clip illustrating every warp between worlds. Bundled at
/// 10.41666s (250 frames @ 24fps) — longer than [EraController.warpDuration],
/// so its playback speed is scaled up to fit; the full clip still plays
/// through once per trip, just faster.
const String _kWarpVideoAsset = 'assets/videos/time_warp.mp4';

/// Year milestones shown, in order, while travelling forward — modern
/// (2026) back to retro (2003). The reverse trip plays the same list back
/// to front, via [_kReverseYears].
const List<String> _kForwardYears = ['2026', '2020', '2010', '2005', '2003'];
const List<String> _kReverseYears = ['2003', '2005', '2010', '2020', '2026'];

/// The full-screen "time rift" that plays over [_kWarpVideoAsset] whenever
/// [EraController] travels between worlds — hiding the shell swap behind
/// it, with a year readout that steps through the milestones in sync with
/// the clip.
///
/// No [BackdropFilter]/[ImageFilter] — the video itself carries the
/// effect; the only compositing on top is a flat scrim and text opacity,
/// both cheap under CanvasKit. Always [IgnorePointer]-wrapped so it never
/// intercepts taps; input blocking during travel is handled separately by
/// an `AbsorbPointer` around the shell.
class TimeWarpOverlay extends StatefulWidget {
  const TimeWarpOverlay({
    super.key,
    required this.progress,
    required this.targetYear,
  });

  /// 0..1 across the warp's duration.
  final double progress;

  /// The era being travelled to (its full year, e.g. "2003"), which decides
  /// whether the milestone readout counts down or up.
  final String targetYear;

  @override
  State<TimeWarpOverlay> createState() => _TimeWarpOverlayState();
}

class _TimeWarpOverlayState extends State<TimeWarpOverlay> {
  late final VideoPlayerController _video;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _video = VideoPlayerController.asset(_kWarpVideoAsset)
      ..setLooping(false)
      ..setVolume(0);
    _video.initialize().then((_) => _matchPlaybackToWarpDuration());
    _syncPlayback();
  }

  /// Speeds the clip's own playback up so its full length fits exactly
  /// inside one warp, however short [EraController.warpDuration] is set to.
  void _matchPlaybackToWarpDuration() {
    if (!mounted) return;
    final clipMs = _video.value.duration.inMilliseconds;
    final warpMs = EraController.warpDuration.inMilliseconds;
    if (clipMs <= 0) return;
    _video.setPlaybackSpeed(clipMs / warpMs);
  }

  @override
  void didUpdateWidget(covariant TimeWarpOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPlayback();
  }

  /// Plays the clip from the start the moment a warp begins, and pauses it
  /// the moment one ends — driven by [widget.progress] rather than a timer
  /// of its own, so it always matches the overlay's own lifecycle exactly.
  ///
  /// [didUpdateWidget] calls this every frame while a warp is running, so
  /// if the clip is still loading when the very first warp starts, this
  /// simply retries on the next frame instead of marking itself "playing"
  /// for a controller that never actually started — otherwise the first
  /// trip after a fresh load would silently skip the video for good.
  void _syncPlayback() {
    final active = widget.progress > 0 && widget.progress < 1;
    if (active && !_playing) {
      if (!_video.value.isInitialized) return;
      _playing = true;
      _video.seekTo(Duration.zero);
      _video.play();
    } else if (!active && _playing) {
      _playing = false;
      _video.pause();
    }
  }

  @override
  void dispose() {
    _video.dispose();
    super.dispose();
  }

  /// Smooth in/out envelope so the clip and readout never hard-cut at
  /// either end of the warp.
  double get _edgeFade {
    const edge = 0.08;
    final p = widget.progress.clamp(0.0, 1.0);
    if (p < edge) return p / edge;
    if (p > 1 - edge) return (1 - p) / edge;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.progress <= 0) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: _edgeFade,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_video.value.isInitialized)
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _video.value.size.width,
                    height: _video.value.size.height,
                    child: VideoPlayer(_video),
                  ),
                )
              else
                const ColoredBox(color: AppColors.pageBlack),
              ColoredBox(color: AppColors.pageBlack.withOpacity(0.35)),
              Center(
                child: _YearReadout(
                  progress: widget.progress,
                  targetYear: widget.targetYear,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The centred year milestone readout, crossfading between adjacent
/// entries of the active sequence as [progress] runs 0..1 — dwelling on
/// each year before a short blend into the next, like a stepped counter
/// rather than a continuous morph.
class _YearReadout extends StatelessWidget {
  const _YearReadout({required this.progress, required this.targetYear});

  final double progress;
  final String targetYear;

  /// Fraction of each step spent blending into the next one (the rest is
  /// spent holding steady on the current year).
  static const double _blendWidth = 0.25;

  @override
  Widget build(BuildContext context) {
    final sequence = targetYear == '2003' ? _kForwardYears : _kReverseYears;
    final steps = sequence.length - 1;
    final scaled = progress.clamp(0.0, 1.0) * steps;
    final index = scaled.floor().clamp(0, steps - 1);
    final stepFrac = scaled - index;
    final blend = stepFrac <= (1 - _blendWidth)
        ? 0.0
        : (stepFrac - (1 - _blendWidth)) / _blendWidth;

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 1 - blend, child: _yearChip(sequence[index])),
        Opacity(opacity: blend, child: _yearChip(sequence[index + 1])),
      ],
    );
  }

  Widget _yearChip(String year) {
    return Text(
      year,
      style: AppTheme.mono(
        size: 45,
        weight: FontWeight.bold,
        color: AppColors.timeWarpSoft,
      ),
    );
  }
}
