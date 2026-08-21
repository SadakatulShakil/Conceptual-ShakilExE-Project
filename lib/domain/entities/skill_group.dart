/// A named cluster of skills, e.g. "Languages" -> [Dart, Kotlin].
class SkillGroup {
  final String category;
  final List<String> skills;

  const SkillGroup({
    required this.category,
    required this.skills,
  });
}
