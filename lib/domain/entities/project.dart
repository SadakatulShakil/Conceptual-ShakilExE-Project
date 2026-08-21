/// Whether an app is shipped or still in the oven.
enum ProjectStatus { live, building }

/// One app in the portfolio. Rendered as a Play-Store-style row in modern
/// and a list entry in retro — same data, different chrome.
class Project {
  final String id;
  final String name;

  /// Short category line, e.g. "Weather · national forecasts".
  final String subtitle;

  /// One-word domain, e.g. "Weather", used for grouping/filters later.
  final String category;

  final String description;
  final List<String> tech;
  final List<String> platforms;

  /// Play Store / web URL (null = no public link yet).
  final String? storeUrl;
  final String? repoUrl;

  /// Display strings kept loose so you can write "4.6" / "100K+" freely.
  final double? rating;
  final String? installs;

  final ProjectStatus status;

  /// Short progress note shown on the "Now Building" card, e.g.
  /// "Phase 5 · Parent Zone" (null when the project isn't in progress).
  final String? buildingNote;

  const Project({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.description,
    required this.tech,
    required this.status,
    this.platforms = const ['Android', 'iOS'],
    this.storeUrl,
    this.repoUrl,
    this.rating,
    this.installs,
    this.buildingNote,
  });

  bool get isLive => status == ProjectStatus.live;
  bool get isBuilding => status == ProjectStatus.building;
}
