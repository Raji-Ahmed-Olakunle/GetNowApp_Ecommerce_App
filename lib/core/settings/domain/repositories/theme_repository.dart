abstract class ThemeRepository {
  Future<bool> getThemeMode();
  Future<void> setThemeMode(bool isLightMode);
} 