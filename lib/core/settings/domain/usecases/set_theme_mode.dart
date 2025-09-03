import '../repositories/theme_repository.dart';

class SetThemeMode {
  final ThemeRepository repository;
  SetThemeMode(this.repository);

  Future<void> call(bool isLightMode) => repository.setThemeMode(isLightMode);
} 