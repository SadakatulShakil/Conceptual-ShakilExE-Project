import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/url_utils.dart';
import '../../domain/entities/project.dart';
import '../shared/project_visuals.dart';
import 'widgets/modern_chips.dart';

/// Play-Store-style detail screen for a single [Project], pushed when a
/// project tile (mobile) or project row (either viewport) is tapped.
class ModernProjectDetail extends StatelessWidget {
  const ModernProjectDetail({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final visual = projectVisual(project.id);

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.screenBg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          project.name,
          style: AppTheme.sans(size: 16, weight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.tileHover,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Icon(visual.icon, color: visual.color, size: 38),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style:
                            AppTheme.sans(size: 18, weight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        project.subtitle,
                        style: AppTheme.sans(
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      StatusPill(isLive: project.isLive),
                    ],
                  ),
                ),
              ],
            ),
            if (project.rating != null || project.installs != null) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  if (project.rating != null) ...[
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: AppColors.iconAmber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      project.rating!.toStringAsFixed(1),
                      style: AppTheme.sans(size: 13, weight: FontWeight.w600),
                    ),
                  ],
                  if (project.rating != null && project.installs != null)
                    const SizedBox(width: 16),
                  if (project.installs != null)
                    Text(
                      '${project.installs} installs',
                      style: AppTheme.sans(
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Text(
              project.description,
              style: AppTheme.sans(size: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in project.tech) TechChip(label: t),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              project.platforms.join(' · '),
              style: AppTheme.sans(size: 11.5, color: AppColors.textMuted),
            ),
            const SizedBox(height: 24),
            if (project.storeUrl != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => launchExternal(project.storeUrl!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'View on Play Store',
                    style: AppTheme.sans(size: 14, weight: FontWeight.w600),
                  ),
                ),
              )
            else
              Text(
                'In progress',
                style: AppTheme.sans(size: 12, color: AppColors.textMuted),
              ),
          ],
        ),
      ),
    );
  }
}
