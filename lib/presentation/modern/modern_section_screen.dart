import 'package:flutter/material.dart';
import '../../core/enums/section_id.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../shared/section_config.dart';
import 'widgets/modern_section_view.dart';

/// Mobile push destination for a section — the sans/plain-px counterpart to
/// [DesktopContentPanel], used when no wide-viewport panel is showing.
class ModernSectionScreen extends StatelessWidget {
  const ModernSectionScreen({super.key, required this.id});

  final SectionId id;

  @override
  Widget build(BuildContext context) {
    final section = kSections.firstWhere((s) => s.id == id);

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.screenBg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(section.icon, size: 18, color: section.color),
            const SizedBox(width: 8),
            Text(
              section.title,
              style: AppTheme.sans(size: 16, weight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ModernSectionView(id: id),
      ),
    );
  }
}
