import '../repositories/theme_repository.dart';

class GetThemeMode {
  final ThemeRepository repository;
  GetThemeMode(this.repository);

  Future<bool> call() => repository.getThemeMode();
} 