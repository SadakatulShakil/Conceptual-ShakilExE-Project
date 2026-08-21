import '../../domain/entities/contact_link.dart';
import '../../domain/entities/experience_item.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/skill_group.dart';
import '../../domain/repositories/portfolio_repository.dart';

/// In-code source of truth for the portfolio content.
///
/// This is the ONE file you edit to update the site — every value with a
/// `// TODO` is a placeholder for you to confirm or replace with your real
/// links / numbers / dates. Nothing here is fetched from the network.
class PortfolioRepositoryImpl implements PortfolioRepository {
  const PortfolioRepositoryImpl();

  @override
  Profile getProfile() => const Profile(
        name: 'Sadakatul Shakil',
        role: 'Senior Mobile Engineer',
        location: 'Dhaka, Bangladesh',
        initials: 'SS',
        yearsExperience: 5,
        tagline:
            "I build Bangladesh's national weather, flood, and disaster apps.",
        bio:
            'Flutter and Kotlin mobile engineer with 5+ years shipping '
            'production apps that millions of people rely on during real '
            'emergencies. I care about clean architecture, offline-first '
            'reliability, and interfaces that work for everyone — in both '
            'Bangla and English.',
        resumeUrl: null,
        resumeAssetPath: 'assets/resume/sadakatul_shakil_cv.pdf',
        links: [
          ContactLink(
            type: ContactType.github,
            label: 'SadakatulShakil',
            url: 'https://github.com/SadakatulShakil',
          ),
          ContactLink(
            type: ContactType.linkedin,
            label: 'LinkedIn',
            url: 'https://www.linkedin.com/in/', // TODO: your profile slug
          ),
          ContactLink(
            type: ContactType.email,
            label: 'Email',
            url: 'mailto:you@example.com', // TODO: your email
          ),
          ContactLink(
            type: ContactType.whatsapp,
            label: 'WhatsApp',
            url: 'https://wa.me/8801XXXXXXXXX', // TODO: your number
          ),
        ],
      );

  @override
  List<Project> getProjects() => const [
        Project(
          id: 'abohawa',
          name: 'BMD Abohawa',
          subtitle: 'Weather · national forecasts & alerts',
          category: 'Weather',
          description:
              'Official app of the Bangladesh Meteorological Department. '
              'Live forecasts, radar, severe-weather alerts via Firebase '
              'FCM, home-screen widgets, and TTS notifications.',
          tech: ['Flutter', 'GetX', 'Firebase FCM', 'Floor', 'Node.js'],
          storeUrl:
              'https://play.google.com/store/apps/details?id=bd.gov.bmd.abohawa',
          rating: 4.6, // TODO: confirm
          installs: '100K+', // TODO: confirm
          status: ProjectStatus.live,
        ),
        Project(
          id: 'ffwc',
          name: 'FFWC App',
          subtitle: 'Flood forecasting · river levels',
          category: 'Flood',
          description:
              'Flood Forecasting & Warning Centre (BWDB) app. Station data, '
              'river-level graphs, inundation maps, and shareable flood '
              'status posters.',
          tech: ['Flutter', 'GetX', 'flutter_map', 'REST API'],
          storeUrl:
              'https://play.google.com/store/apps/details?id=bd.gov.ffwc.app',
          rating: 4.5, // TODO: confirm
          installs: '50K+', // TODO: confirm
          status: ProjectStatus.live,
        ),
        Project(
          id: 'aware',
          name: 'AWARE',
          subtitle: 'Disaster management · hazards & alerts',
          category: 'Disaster',
          description:
              'Department of Disaster Management (DDM) app. Hazard and '
              'service listings, in-app WebViews, FCM alerts, and TTS '
              'notifications in Bangla and English.',
          tech: ['Flutter', 'GetX', 'Firebase FCM', 'flutter_tts'],
          storeUrl:
              'https://play.google.com/store/apps/details?id=bd.gov.ddm.aware',
          rating: 4.4, // TODO: confirm
          installs: '10K+', // TODO: confirm
          status: ProjectStatus.live,
        ),
        Project(
          id: 'bipod',
          name: 'Bipod Bondhu',
          subtitle: 'Disaster preparedness for children',
          category: 'Education',
          description:
              'A kids’ disaster-preparedness app (flood, lightning, '
              'earthquake, first aid) with narrated activities and a parent '
              'zone. Built on Clean Architecture with Floor and flutter_tts.',
          tech: ['Flutter', 'GetX', 'Floor', 'flutter_tts'],
          storeUrl: null, // in progress
          status: ProjectStatus.building,
          buildingNote: 'Phase 5 · Parent Zone',
        ),
      ];

  @override
  List<ExperienceItem> getExperience() => const [
        ExperienceItem(
          company: 'RIMES',
          role: 'Flutter & Kotlin Mobile Developer',
          location: 'Dhaka, Bangladesh',
          period: 'Present', // TODO: set your start year, e.g. "2023 — Present"
          isCurrent: true,
          bullets: [
            'Lead mobile developer for national weather, flood, and '
                'disaster-management apps used across Bangladesh.',
            'Shipped BMD Abohawa, FFWC, and AWARE with Firebase FCM '
                'alerting, offline caching, and Bangla/English localization.',
            'Built reusable Flutter components: animated weather gauges, '
                'video backgrounds, lightning effects, and TTS notifications.',
          ],
        ),
        // TODO: add your earlier roles below (5+ years across employers).
        ExperienceItem(
          company: 'Previous employer',
          role: 'Mobile Developer',
          location: 'Dhaka, Bangladesh',
          period: 'YYYY — YYYY',
          bullets: [
            'Describe a key responsibility or shipped result.',
            'Describe another measurable achievement.',
          ],
        ),
      ];

  @override
  List<SkillGroup> getSkills() => const [
        SkillGroup(category: 'Languages', skills: ['Dart', 'Kotlin']),
        SkillGroup(
          category: 'Framework & State',
          skills: ['Flutter', 'GetX', 'flutter_screenutil'],
        ),
        SkillGroup(
          category: 'Backend & Cloud',
          skills: ['Firebase (FCM)', 'REST APIs', 'Node.js'],
        ),
        SkillGroup(
          category: 'Storage',
          skills: ['Floor / SQLite', 'shared_preferences'],
        ),
        SkillGroup(
          category: 'Tooling & Delivery',
          skills: ['Git', 'GitHub Actions CI/CD', 'Play Console'],
        ),
        SkillGroup(
          category: 'Practices',
          skills: [
            'Clean Architecture',
            'Bangla/English localization',
            'Offline-first',
          ],
        ),
      ];
}
