/// One role in the work history. `period` is a free string (e.g.
/// "2023 — Present") so you never have to fight DateTime formatting.
class ExperienceItem {
  final String company;
  final String role;
  final String location;
  final String period;
  final List<String> bullets;
  final bool isCurrent;

  const ExperienceItem({
    required this.company,
    required this.role,
    required this.location,
    required this.period,
    required this.bullets,
    this.isCurrent = false,
  });
}
