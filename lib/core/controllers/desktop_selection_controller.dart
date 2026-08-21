import 'package:get/get.dart';
import '../enums/section_id.dart';

/// Which section the desktop [DesktopContentPanel] is showing. Tapping the
/// Projects/Experience/Skills/About tiles inside the phone mockup updates
/// this instead of navigating, so the panel and the mockup stay in sync.
/// Irrelevant on phones, where those tiles navigate to a placeholder screen
/// instead.
class DesktopSelectionController extends GetxController {
  final Rx<SectionId> selected = SectionId.projects.obs;
}
