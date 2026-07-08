import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final coachMarksServiceProvider = Provider<CoachMarksService>((ref) {
  return CoachMarksService();
});

/// Per-user dashboard tips (coach marks). Can be disabled in settings.
class CoachMarksService {
  static const _enabledKey = 'clivora_coach_marks_enabled';

  String _doneKey(int userId) => 'clivora_dashboard_coach_done_$userId';

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? true;
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, value);
  }

  Future<bool> isDashboardCompleteForUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_doneKey(userId)) ?? false;
  }

  Future<void> markDashboardCompleteForUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_doneKey(userId), true);
  }

  Future<bool> shouldShowForUser(int userId) async {
    if (!await isEnabled()) return false;
    return !(await isDashboardCompleteForUser(userId));
  }
}
