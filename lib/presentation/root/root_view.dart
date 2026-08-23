import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/era_controller.dart';
import '../../core/enums/app_era.dart';
import '../modern/modern_shell.dart';
import '../retro/retro_shell.dart';
import 'widgets/time_intro_overlay.dart';
import 'widgets/time_warp_overlay.dart';

/// Chooses the world and drives the time-travel experience: a warp overlay
/// plays over every era change (the shell underneath swaps hidden behind
/// its peak), and a first-visit intro plays once before either shell is
/// ever seen.
class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView>
    with SingleTickerProviderStateMixin {
  late final EraController _era;
  late final AnimationController _warpController;
  late final Animation<double> _warp;
  late final Worker _eraWorker;

  /// Which shell is actually built. Deliberately decoupled from
  /// `_era.era.value` — that flips the instant travel starts, but this only
  /// follows once the warp's rift has peaked, so the swap happens hidden.
  late AppEra _shownEra;

  @override
  void initState() {
    super.initState();
    _era = Get.find<EraController>();
    _shownEra = _era.era.value;

    _warpController = AnimationController(
      vsync: this,
      duration: EraController.warpDuration,
    );
    _warp = CurvedAnimation(
      parent: _warpController,
      curve: Curves.easeInOutCubic,
    )..addListener(_handleWarpTick);

    // The era is never restored from storage asynchronously — it only ever
    // changes via a real user-triggered `travelTo()` — so every change here
    // is a real trip and always warps.
    _eraWorker = ever<AppEra>(_era.era, (_) {
      _warpController.forward(from: 0);
    });
  }

  void _handleWarpTick() {
    if (_warp.value >= 0.5 && _shownEra != _era.era.value) {
      setState(() => _shownEra = _era.era.value);
    }
  }

  @override
  void dispose() {
    _warp.removeListener(_handleWarpTick);
    _warpController.dispose();
    _eraWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final shell = _shownEra == AppEra.modern
          ? const ModernShell()
          : const RetroShell();

      return Scaffold(
        body: Stack(
          children: [
            AbsorbPointer(
              absorbing: _era.isTravelling.value,
              child: shell,
            ),
            AnimatedBuilder(
              animation: _warp,
              builder: (context, _) => TimeWarpOverlay(
                progress: _warp.value,
                targetYear: _era.era.value.fullYear,
              ),
            ),
            if (_era.showIntro.value)
              TimeIntroOverlay(onDone: _era.dismissIntro),
          ],
        ),
      );
    });
  }
}
