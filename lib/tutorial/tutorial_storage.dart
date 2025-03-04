import 'package:shared_preferences/shared_preferences.dart';

class TutorialStorage {
  static const _key = 'seen-tutorial';

  static Future<void> saveSeenTutorial(bool seenTutorial) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, seenTutorial);
  }

  static Future<bool> getSeenTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    bool? seenTutorial = prefs.getBool(_key);
    if (seenTutorial == null) return false;

    return seenTutorial;
  }

  static Future<void> clearSeenTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

}
