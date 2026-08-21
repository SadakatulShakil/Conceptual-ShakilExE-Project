import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Icon + colour pairing for a project's app-tile, shared by both shells.
class ProjectVisual {
  const ProjectVisual(this.icon, this.color);

  final IconData icon;
  final Color color;
}

/// Maps a [Project.id] to its display icon and accent colour.
ProjectVisual projectVisual(String id) => switch (id) {
      'abohawa' => const ProjectVisual(Icons.cloud_outlined, AppColors.iconBlue),
      'ffwc' => const ProjectVisual(
          Icons.water_drop_outlined,
          AppColors.iconTeal,
        ),
      'aware' => const ProjectVisual(
          Icons.warning_amber_rounded,
          AppColors.iconAmber,
        ),
      'bipod' => const ProjectVisual(
          Icons.child_care_rounded,
          AppColors.iconGreen,
        ),
      _ => const ProjectVisual(Icons.apps_rounded, AppColors.iconGray),
    };
