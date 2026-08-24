import '../../domain/entities/contact_link.dart';
import '../../domain/entities/education.dart';
import '../../domain/entities/experience_item.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/skill_group.dart';
import '../../domain/repositories/portfolio_repository.dart';

/// In-code source of truth for the portfolio content.
///
/// This is the ONE file you edit to update the site. Nothing here is
/// fetched from the network.
class PortfolioRepositoryImpl implements PortfolioRepository {
  const PortfolioRepositoryImpl();

  @override
  Profile getProfile() => const Profile(
        name: 'Sadakatul Ajam Md. Shakil',
        role: 'Senior Flutter Mobile Engineer',
        location: 'Mohammadpur, Dhaka, Bangladesh',
        initials: 'SS',
        yearsExperience: 5,
        tagline:
            "I build Bangladesh's national weather, flood, and disaster apps.",
        bio:
            'Senior Flutter Mobile Application Engineer with 5+ years '
            'building scalable, high-performance apps across government, '
            'enterprise, and SaaS platforms. Specialised in clean '
            'architecture, state management (GetX, Bloc), and real-time '
            'systems — geolocation, mapping, and notification-driven '
            'features — delivering production-grade apps with strong '
            'performance optimisation and offline support.',
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
            url: 'https://www.linkedin.com/in/sadakatulshakil/',
          ),
          ContactLink(
            type: ContactType.email,
            label: 'Email',
            url: 'mailto:sadakatulshakil94@gmail.com',
          ),
          ContactLink(
            type: ContactType.whatsapp,
            label: 'WhatsApp / +8801751-330394',
            url: 'https://wa.me/8801751330394',
          ),
        ],
      );

  @override
  List<Project> getProjects() => const [
        // Featured — shown on the modern home's 2x2 app-tile cluster.
        Project(
          id: 'abohawa',
          name: 'BMD Abohawa',
          subtitle: 'Weather · national forecasts & alerts',
          category: 'Weather',
          description:
              'Official Bangladesh Meteorological Department app — live '
              'forecasts, radar, and severe-weather alerts.',
          tech: ['Flutter', 'GetX', 'Firebase FCM', 'REST APIs'],
          storeUrl:
              'https://play.google.com/store/apps/details?id=bd.gov.bmd.abohawa',
          status: ProjectStatus.live,
          featured: true,
        ),
        Project(
          id: 'ffwc',
          name: 'FFWC App',
          subtitle: 'Flood forecasting · river levels',
          category: 'Flood',
          description:
              'National Flood Forecasting & Warning Centre app with '
              'real-time water-level data and inundation maps.',
          tech: ['Flutter', 'GetX', 'flutter_map', 'REST APIs'],
          storeUrl:
              'https://play.google.com/store/apps/details?id=com.rimes.ffwc_app',
          status: ProjectStatus.live,
          featured: true,
        ),
        Project(
          id: 'aware',
          name: 'AWARE',
          subtitle: 'Disaster management · in progress',
          category: 'Disaster',
          description:
              'Disaster-management app for the Department of Disaster '
              'Management (DDM).',
          tech: ['Flutter', 'GetX', 'Firebase FCM'],
          storeUrl: null, // TODO: add Play Store link once published
          status: ProjectStatus.building,
          buildingNote: 'In development',
          featured: true,
        ),
        Project(
          id: 'bipod',
          name: 'Bipod Bondhu',
          subtitle: 'Disaster prep for children · in progress',
          category: 'Education',
          description:
              'Disaster-preparedness app for children (flood, lightning, '
              'earthquake, first aid) with narrated activities and a parent '
              'zone.',
          tech: ['Flutter', 'GetX', 'Floor', 'flutter_tts'],
          storeUrl: null,
          status: ProjectStatus.building,
          buildingNote: 'Phase 5 · Parent Zone',
          featured: true,
        ),

        // Non-featured — appear in the Projects section list only.
        Project(
          id: 'landslide',
          name: 'Landslide Reporting',
          subtitle: 'Geo-based field reporting',
          category: 'Disaster',
          description:
              'Geo-based landslide reporting tool for field data collection '
              '(RIMES).',
          tech: ['Flutter', 'GetX', 'Google Maps', 'Shapefile', 'Firebase'],
          storeUrl:
              'https://play.google.com/store/apps/details?id=com.rimes.lanslide_report',
          status: ProjectStatus.live,
        ),
        Project(
          id: 'wzpdcl',
          name: 'WZPDCL App',
          subtitle: 'Electricity service platform',
          category: 'Utility',
          description:
              'West Zone Power Distribution electricity service platform '
              'for customers.',
          tech: ['Flutter', 'REST APIs'],
          storeUrl:
              'https://play.google.com/store/apps/details?id=com.adndiginet.wzpdcl_app_flutter',
          status: ProjectStatus.live,
        ),
        Project(
          id: 'laalsobuj_user',
          name: 'Laalsobuj (User)',
          subtitle: 'E-commerce · customer app',
          category: 'E-commerce',
          description: 'Customer-side e-commerce shopping app.',
          tech: ['Flutter', 'REST APIs'],
          storeUrl:
              'https://play.google.com/store/apps/details?id=com.laalsobuj.user',
          status: ProjectStatus.live,
        ),
        Project(
          id: 'laalsobuj_seller',
          name: 'Laalsobuj (Seller)',
          subtitle: 'E-commerce · merchant app',
          category: 'E-commerce',
          description: 'Merchant/seller e-commerce management app.',
          tech: ['Flutter', 'REST APIs'],
          storeUrl:
              'https://play.google.com/store/apps/details?id=com.laalsobuj.seller',
          status: ProjectStatus.live,
        ),
      ];

  @override
  List<ExperienceItem> getExperience() => const [
        ExperienceItem(
          company: 'RIMES',
          role: 'Mobile Application Developer',
          location: 'Mirpur DOHS, Dhaka',
          period: 'Feb 2025 — Present',
          isCurrent: true,
          bullets: [
            'Led development of government-scale disaster-management apps: '
                'real-time geolocation-based landslide reporting and '
                'scalable architectures for live weather.',
            'Integrated Google Maps, Shapefile, Firebase, and REST APIs '
                'for real-time visualization; optimised performance and '
                'reduced latency using GetX.',
            'Key apps: Landslide Reporting, FFWC, BMD Abohawa (live); '
                'AWARE and Bipod Bondhu (in progress); BWDB (ongoing).',
          ],
        ),
        ExperienceItem(
          company: 'Softwindtech Ltd.',
          role: 'Senior Mobile Application Developer',
          location: 'Banani, Dhaka',
          period: 'Oct 2023 — Jan 2025',
          bullets: [
            'Led high-traffic enterprise apps focused on scalability and '
                'performance; collaborated with product/design for '
                'user-centric solutions; robust API integration.',
            'Projects: EMS App, Community App, Health Data App.',
          ],
        ),
        ExperienceItem(
          company: 'ADN Diginet (ADN Group)',
          role: 'Mobile Application Developer',
          location: 'Gulshan 1, Dhaka',
          period: 'Nov 2021 — Aug 2023',
          bullets: [
            'Built and maintained cross-platform apps; reduced load time '
                'by ~30%; worked with QA and backend for stable releases.',
            'Projects: WZPDCL, Cocomaya, E-Learning, Voter Tottho.',
          ],
        ),
        ExperienceItem(
          company: 'Future Sky Limited',
          role: 'Mobile Application Developer',
          location: 'Mirpur DOHS, Dhaka',
          period: 'Oct 2020 — Sep 2021',
          bullets: [
            'Developed native Android apps; integrated REST APIs; '
                'optimised UX; ensured stable releases with QA and backend '
                'teams.',
            'Projects: Laal-Sobuj, Field Tracking, Admin Dashboard.',
          ],
        ),
      ];

  @override
  List<SkillGroup> getSkills() => const [
        SkillGroup(
          category: 'Languages & Frameworks',
          skills: [
            'Dart',
            'Java',
            'Flutter (Android & iOS)',
            'React',
            'FastAPI',
          ],
        ),
        SkillGroup(
          category: 'Architecture & State',
          skills: ['Clean Architecture', 'MVC', 'GetX', 'Provider', 'Bloc'],
        ),
        SkillGroup(
          category: 'Backend & Integration',
          skills: [
            'REST APIs',
            'DIO',
            'HTTP',
            'Firebase (Auth, Firestore, Notifications)',
          ],
        ),
        SkillGroup(
          category: 'Core Features',
          skills: [
            'Google Maps & Geolocation',
            'Push Notifications',
            'Background Services',
            'Offline Storage (Hive)',
            'Real-time data',
          ],
        ),
        SkillGroup(
          category: 'Tools',
          skills: [
            'Git (GitHub/GitLab)',
            'JIRA',
            'GitHub Actions CI/CD',
            'Render',
            'Vercel',
            'Neon',
          ],
        ),
        SkillGroup(
          category: 'Practices',
          skills: ['Agile / Scrum', 'Sprint management'],
        ),
      ];

  @override
  List<Education> getEducation() => const [
        Education(
          degree: 'MSc in Computer Science & Engineering',
          institution: 'Jagannath University',
          period: '2019 — 2023',
          location: 'Dhaka',
          grade: 'CGPA 3.76/4.00',
        ),
        Education(
          degree: 'BSc in Computer Science & Engineering',
          institution: 'State University of Bangladesh',
          period: '2014 — 2018',
          location: 'Dhaka',
          grade: 'CGPA 3.76/4.00',
        ),
        Education(
          degree: 'HSC (Science)',
          institution: 'Carmichael College',
          period: '2012 — 2014',
          location: 'Rangpur',
          grade: 'CGPA 4.40/5.00',
        ),
        Education(
          degree: 'SSC (Science)',
          institution: 'Pirgachha J.N. High School',
          period: '2009 — 2012',
          location: 'Rangpur',
          grade: 'CGPA 5.00/5.00',
        ),
      ];
}
