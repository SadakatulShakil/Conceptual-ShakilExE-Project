import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Small "Live"/"Building" indicator, shared by the section list and the
/// project detail screen.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.isLive});

  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final color = isLive ? AppColors.accentSoft : AppColors.iconAmber;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isLive ? 'Live' : 'Building',
        style: AppTheme.sans(size: 9, weight: FontWeight.w600, color: color),
      ),
    );
  }
}

/// A single tech-stack chip, shared by the section list and the project
/// detail screen.
class TechChip extends StatelessWidget {
  const TechChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.tile,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTheme.sans(size: 10, color: AppColors.textSecondary),
      ),
    );
  }
}
