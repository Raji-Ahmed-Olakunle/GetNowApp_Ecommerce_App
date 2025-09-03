import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/theme_local_datasource.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../domain/usecases/get_theme_mode.dart';
import '../../domain/usecases/set_theme_mode.dart';

final themeLocalDatasourceProvider = Provider((ref) => ThemeLocalDatasource());
final themeRepositoryProvider = Provider((ref) => ThemeRepositoryImpl(ref.read(themeLocalDatasourceProvider)));
final getThemeModeUseCaseProvider = Provider((ref) => GetThemeMode(ref.read(themeRepositoryProvider)));
final setThemeModeUseCaseProvider = Provider((ref) => SetThemeMode(ref.read(themeRepositoryProvider))); 