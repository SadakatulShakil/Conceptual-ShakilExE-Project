import 'package:get/get.dart';
import '../enums/app_era.dart';
import '../services/era_service.dart';

/// Single source of truth for which world is showing.
/// Both shells and the time-travel control listen to this.
class EraController extends GetxController {
  EraController(this._service);
  final EraService _service;

  /// How long the [TimeWarpOverlay] plays for on every era change — the
  /// RootView's animation controller is built with this exact duration so
  /// the overlay and the input-blocking window stay in lockstep. The
  /// bundled `assets/videos/time_warp.mp4` clip is longer than this on its
  /// own (10.41666s), so [TimeWarpOverlay] speeds its playback up to fit —
  /// the full clip still plays through once per trip, just faster.
  static const Duration warpDuration = Duration(milliseconds: 3600);

  /// Every visit starts here, in retro (2003) — the era is never persisted
  /// across loads, only chosen freely (and warped between) within a
  /// session.
  final Rx<AppEra> era = AppEra.retro.obs;

  /// True while the warp animation plays; both shells and RootView use this
  /// to block input.
  final RxBool isTravelling = false.obs;

  /// True until the visitor dismisses (or skips) the first-visit intro.
  final RxBool showIntro = false.obs;

  bool get isModern => era.value == AppEra.modern;
  bool get isRetro => era.value == AppEra.retro;

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  Future<void> _restore() async {
    showIntro.value = !(await _service.hasSeenIntro());
  }

  /// Toggle to the other world.
  Future<void> toggleEra() => travelTo(era.value.opposite);

  Future<void> travelTo(AppEra target) async {
    if (target == era.value || isTravelling.value) return;
    isTravelling.value = true;
    era.value = target;
    // The RootView's warp overlay animation runs for the same duration.
    await Future<void>.delayed(warpDuration);
    isTravelling.value = false;
  }

  /// Dismisses the first-visit intro, permanently — a returning visitor
  /// never sees it again.
  void dismissIntro() {
    showIntro.value = false;
    _service.markIntroSeen();
  }
}
