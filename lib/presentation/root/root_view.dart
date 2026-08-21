import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/era_controller.dart';
import '../modern/modern_shell.dart';
import '../retro/retro_shell.dart';

/// Chooses the world. In Phase 5 the AnimatedSwitcher becomes the warp.
class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    final era = Get.find<EraController>();
    return Scaffold(
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: era.isModern
              ? const ModernShell(key: ValueKey('modern'))
              : const RetroShell(key: ValueKey('retro')),
        ),
      ),
    );
  }
}
