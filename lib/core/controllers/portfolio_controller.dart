import 'package:get/get.dart';
import '../../domain/entities/education.dart';
import '../../domain/entities/experience_item.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/skill_group.dart';
import '../../domain/repositories/portfolio_repository.dart';

/// Loads portfolio content once and exposes it to every screen in both
/// worlds. Data is static today, so this reads synchronously in onInit.
class PortfolioController extends GetxController {
  PortfolioController(this._repo);
  final PortfolioRepository _repo;

  late final Profile profile;
  late final List<Project> projects;
  late final List<ExperienceItem> experience;
  late final List<SkillGroup> skills;
  late final List<Education> education;

  @override
  void onInit() {
    super.onInit();
    profile = _repo.getProfile();
    projects = _repo.getProjects();
    experience = _repo.getExperience();
    skills = _repo.getSkills();
    education = _repo.getEducation();
  }

  /// Convenience lookups used by the Projects section.
  Project? projectById(String id) =>
      projects.firstWhereOrNull((p) => p.id == id);

  /// The subset of [projects] shown on the modern home's 2x2 app-tile
  /// cluster.
  List<Project> get featuredProjects =>
      projects.where((p) => p.featured).toList();
}
