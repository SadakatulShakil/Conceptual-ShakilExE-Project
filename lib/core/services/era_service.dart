import 'package:shared_preferences/shared_preferences.dart';
import '../enums/app_era.dart';

/// Persists the visitor's chosen era and whether they've seen the intro.
/// All access is guarded — a storage failure must never crash the launcher.
class EraService {
  static const _eraKey = 'app_era';
  static const _seenIntroKey = 'seen_time_intro';

  Future<AppEra> loadEra() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return AppEra.fromKey(prefs.getString(_eraKey));
    } catch (_) {
      return AppEra.modern;
    }
  }

  Future<void> saveEra(AppEra era) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_eraKey, era.key);
    } catch (_) {
      // Non-fatal: the choice just won't persist this session.
    }
  }

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
