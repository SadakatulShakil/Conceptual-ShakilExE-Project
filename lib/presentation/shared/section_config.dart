import 'package:flutter/material.dart';
import '../../core/enums/section_id.dart';
import '../../core/theme/app_colors.dart';

/// UI metadata for a navigable section — the bridge between the shared
/// SectionId and how each shell draws it.
///
/// [retroIndex] is the 1-9 keypad position in the retro grid (row-major).
/// Modern uses the same list, laid out as app icons.
class SectionNav {
  final SectionId id;
  final String title;

  /// Short label for the tight modern grid (e.g. "Abohawa").
  final String shortTitle;
  final int retroIndex;
  final IconData icon;
  final Color color;

  const SectionNav({
    required this.id,
    required this.title,
    required this.retroIndex,
    required this.icon,
    required this.color,
    String? shortTitle,
  }) : shortTitle = shortTitle ?? title;
}

/// The canonical, ordered nav model. Both shells iterate this.
/// Icons are Material for now; we can swap to a Tabler set in Phase 2/3
/// to match the mockups exactly.
const List<SectionNav> kSections = [
  SectionNav(
    id: SectionId.projects,
    title: 'Projects',
    retroIndex: 1,
    icon: Icons.apps_rounded,
    color: AppColors.iconBlue,
  ),
  SectionNav(
    id: SectionId.experience,
    title: 'Experience',
    retroIndex: 2,
    icon: Icons.work_outline_rounded,
    color: AppColors.iconAmber,
  ),
  SectionNav(
    id: SectionId.skills,
    title: 'Skills',
    retroIndex: 3,
    icon: Icons.radar_rounded,
    color: AppColors.iconPurple,
  ),
  SectionNav(
    id: SectionId.about,
    title: 'About',
    retroIndex: 4,
    icon: Icons.person_outline_rounded,
    color: AppColors.iconPink,
  ),
  SectionNav(
    id: SectionId.resume,
    title: 'Résumé',
    retroIndex: 5,
    icon: Icons.description_outlined,
    color: AppColors.iconCoral,
  ),
  SectionNav(
    id: SectionId.contact,
    title: 'Contact',
    retroIndex: 6,
    icon: Icons.mail_outline_rounded,
    color: AppColors.iconTeal,
  ),
  SectionNav(
    id: SectionId.github,
    title: 'GitHub',
    retroIndex: 7,
    icon: Icons.code_rounded,
    color: AppColors.iconWhite,
  ),
  SectionNav(
    id: SectionId.now,
    title: 'Now',
    retroIndex: 8,
    icon: Icons.bolt_rounded,
    color: AppColors.iconGreen,
  ),
  SectionNav(
    id: SectionId.extras,
    title: 'Extras',
    retroIndex: 9,
    icon: Icons.grid_view_rounded,
    color: AppColors.iconGray,
  ),
];
