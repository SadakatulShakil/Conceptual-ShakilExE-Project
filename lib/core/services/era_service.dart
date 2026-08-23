import 'package:shared_preferences/shared_preferences.dart';

/// Persists whether the visitor has seen the first-visit intro. Every visit
/// always lands in the retro (2003) world — the era itself is never
/// persisted across loads, only chosen freely within a session. All access
/// is guarded — a storage failure must never crash the launcher.
class EraService {
  static const _seenIntroKey = 'seen_time_intro';

  Future<bool> hasSeenIntro() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_seenIntroKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> markIntroSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_seenIntroKey, true);
    } catch (_) {}
  }
}
