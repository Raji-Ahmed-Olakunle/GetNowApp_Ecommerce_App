import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_datasource.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDatasource localDatasource;
  ThemeRepositoryImpl(this.localDatasource);

  @override
  Future<bool> getThemeMode() => localDatasource.getThemeMode();

  @override
  Future<void> setThemeMode(bool isLightMode) => localDatasource.setThemeMode(isLightMode);
} 