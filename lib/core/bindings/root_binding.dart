import 'package:get/get.dart';
import '../../data/repositories/portfolio_repository_impl.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../controllers/desktop_selection_controller.dart';
import '../controllers/era_controller.dart';
import '../controllers/portfolio_controller.dart';
import '../controllers/retro_controller.dart';
import '../services/era_service.dart';

/// Wires up the app-wide singletons before the first screen builds.
class RootBinding extends Bindings {
  @override
  void dependencies() {
    // Era / time travel
    Get.put<EraService>(EraService(), permanent: true);
    Get.put<EraController>(EraController(Get.find()), permanent: true);

    // Content layer (shared by both shells)
    Get.put<PortfolioRepository>(
      const PortfolioRepositoryImpl(),
      permanent: true,
    );
    Get.put<PortfolioController>(
      PortfolioController(Get.find()),
      permanent: true,
    );

    // Desktop-only: which section the content panel beside the phone
    // mockup is showing.
    Get.put<DesktopSelectionController>(
      DesktopSelectionController(),
      permanent: true,
    );

    // Retro handset keypad/d-pad navigation state.
    Get.lazyPut<RetroController>(() => RetroController(), fenix: true);
  }
}
