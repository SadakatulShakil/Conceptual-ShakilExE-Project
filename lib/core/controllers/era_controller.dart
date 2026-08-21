import 'package:get/get.dart';
import '../enums/app_era.dart';
import '../services/era_service.dart';

/// Single source of truth for which world is showing.
/// Both shells and the time-travel control listen to this.
class EraController extends GetxController {
  EraController(this._service);
  final EraService _service;

  final Rx<AppEra> era = AppEra.retro.obs;

  /// True while the warp animation plays (Phase 5 uses this to block input).
  final RxBool isTravelling = false.obs;

  bool get isModern => era.value == AppEra.modern;
  bool get isRetro => era.value == AppEra.retro;

  /// Toggle to the other world (real warp animation added in Phase 5).
  Future<void> toggleEra() => travelTo(era.value.opposite);

  Future<void> travelTo(AppEra target) async {
    if (target == era.value || isTravelling.value) return;
    isTravelling.value = true;
    era.value = target;
    await _service.saveEra(target);
    // Placeholder timing; replaced by the warp controller in Phase 5.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    isTravelling.value = false;
  }
}
