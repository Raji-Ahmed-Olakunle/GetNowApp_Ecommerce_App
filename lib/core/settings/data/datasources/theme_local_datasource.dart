import 'package:shared_preferences/shared_preferences.dart';

class ThemeLocalDatasource {
  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isLightMode')) {
      return prefs.getBool('isLightMode')!;
    } else {
      prefs.setBool('isLightMode', true);
      return true;
    }
  }

  Future<void> setThemeMode(bool isLightMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLightMode', isLightMode);
  }
} 