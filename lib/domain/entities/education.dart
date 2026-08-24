/// One academic credential, shown in the About section's Education block.
class Education {
  final String degree;
  final String institution;
  final String period;
  final String location;
  final String grade;

  const Education({
    required this.degree,
    required this.institution,
    required this.period,
    required this.location,
    required this.grade,
  });
}
