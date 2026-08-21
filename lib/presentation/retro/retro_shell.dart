import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/era_controller.dart';
import '../../core/controllers/portfolio_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class RetroShell extends StatelessWidget {
  const RetroShell({super.key});

  @override
  Widget build(BuildContext context) {
    final era = Get.find<EraController>();
    final data = Get.find<PortfolioController>();
    return Container(
      color: AppColors.retroScreen,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Retro · 2003',
              style: AppTheme.mono(size: 22, weight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(data.profile.name,
              style: AppTheme.mono(size: 13, color: AppColors.accentSoft)),
          const SizedBox(height: 4),
          Text('${data.projects.length} apps loaded',
              style: AppTheme.mono(size: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: era.toggleEra,
            child: Text('Travel to 2026', style: AppTheme.mono(size: 13)),
          ),
        ],
      ),
    );
  }
}
