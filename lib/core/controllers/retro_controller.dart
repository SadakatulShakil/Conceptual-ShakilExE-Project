import 'package:get/get.dart';
import '../../presentation/shared/section_config.dart';
import '../../presentation/shared/section_placeholder_screen.dart';
import '../enums/section_id.dart';

/// Keypad/d-pad navigation state for the retro handset. Both the on-screen
/// controls and the physical keyboard (web) drive this same logic, so the
/// highlighted grid cell and the number keys always agree on what's
/// focused.
class RetroController extends GetxController {
  /// The focused 3x3 grid cell, 1-9 (row-major: 1,2,3 / 4,5,6 / 7,8,9).
  final RxInt highlighted = 1.obs;

  /// Whether a [RetroContentPanel] is currently showing beside the handset
  /// (wide viewport). [RetroShell] updates this every build. When true,
  /// "opening" a section just means the panel already reflects
  /// [highlighted] reactively — there's nothing to navigate to.
  bool hasPanel = false;

  /// The section the highlighted cell corresponds to.
  SectionNav get current =>
      kSections.firstWhere((s) => s.retroIndex == highlighted.value);

  int get _row => (highlighted.value - 1) ~/ 3;
  int get _col => (highlighted.value - 1) % 3;

  int _clampAxis(int v) => v < 0 ? 0 : (v > 2 ? 2 : v);

  void _moveTo(int row, int col) {
    final r = _clampAxis(row);
    final c = _clampAxis(col);
    highlighted.value = r * 3 + c + 1;
  }

  void moveUp() => _moveTo(_row - 1, _col);
  void moveDown() => _moveTo(_row + 1, _col);
  void moveLeft() => _moveTo(_row, _col - 1);
  void moveRight() => _moveTo(_row, _col + 1);

  /// Sets the highlighted cell directly (1-9); out-of-range indices are
  /// ignored so a stray key mapping can never desync the grid. This is
  /// all the numeric keypad (and physical digit keys) do — pressing a
  /// number moves the cursor, like dialing, but doesn't open anything on
  /// its own; OK/Enter confirms.
  void focus(int index) {
    if (index < 1 || index > 9) return;
    highlighted.value = index;
  }

  /// Focuses [index] then opens it. Used by the on-screen grid cells,
  /// where tapping an icon is a direct "open this now" gesture — unlike
  /// the physical keypad, where a number press only moves the highlight.
  void openIndex(int index) {
    focus(index);
    confirmOpen();
  }

  /// Opens the highlighted section, unless [hasPanel] is already showing
  /// it live — the OK button/Enter/left-soft-key's action. Mirrors how
  /// tapping a tile in the modern shell either navigates or updates the
  /// desktop panel depending on whether one is showing.
  void confirmOpen() {
    if (!hasPanel) {
      openHighlighted();
    }
  }

  /// Unconditionally navigates to the highlighted section's placeholder
  /// screen (Phase 4 will replace this with a real retro-native screen).
  void openHighlighted() {
    Get.to(() => SectionPlaceholderScreen(title: current.title));
  }

  /// Focuses and opens the Contact section — the green call key.
  void openContact() {
    final contact = kSections.firstWhere((s) => s.id == SectionId.contact);
    openIndex(contact.retroIndex);
  }

  /// Pops the current route if there's one to pop. Routes Back/Escape/the
  /// end-call key through here so they no-op safely on the retro home
  /// screen instead of crashing when there's nothing pushed.
  void goBack() {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    }
  }
}
