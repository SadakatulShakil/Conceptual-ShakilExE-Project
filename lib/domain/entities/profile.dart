import 'contact_link.dart';

/// The person behind the portfolio. One instance, read by both shells.
class Profile {
  final String name;
  final String role;
  final String location;

  /// Two-letter monogram for the identity card avatar (e.g. "SS").
  final String initials;

  /// One-line hook shown on the home screen / identity card.
  final String tagline;

  /// Longer paragraph for the About section.
  final String bio;

  final int yearsExperience;

  /// Public URL to the résumé PDF (null hides the download action).
  final String? resumeUrl;

  /// Path to a résumé PDF bundled as an app asset (e.g.
  /// `assets/resume/cv.pdf`). Preferred over [resumeUrl] when both are set,
  /// since it works without depending on an external host.
  final String? resumeAssetPath;

  final List<ContactLink> links;

  const Profile({
    required this.name,
    required this.role,
    required this.location,
    required this.initials,
    required this.tagline,
    required this.bio,
    required this.yearsExperience,
    required this.links,
    this.resumeUrl,
    this.resumeAssetPath,
  });
}
