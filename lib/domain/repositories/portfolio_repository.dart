import '../entities/experience_item.dart';
import '../entities/profile.dart';
import '../entities/project.dart';
import '../entities/skill_group.dart';

/// The contract both shells depend on. Today the data is static/in-code;
/// swapping to JSON assets or a remote source later means one new impl,
/// with zero changes to the UI.
abstract class PortfolioRepository {
  Profile getProfile();
  List<Project> getProjects();
  List<ExperienceItem> getExperience();
  List<SkillGroup> getSkills();
}
