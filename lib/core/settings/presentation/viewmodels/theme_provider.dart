import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_theme_mode.dart';
import '../../domain/usecases/set_theme_mode.dart';
import '../../domain/repositories/theme_repository.dart';
import 'theme_usecase_providers.dart';

final themeProvider = AsyncNotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);

class ThemeNotifier extends AsyncNotifier<bool> {
  late final GetThemeMode getThemeModeUseCase;
  late final SetThemeMode setThemeModeUseCase;

  @override
  Future<bool> build() async {
    final themeRepository = ref.read(themeRepositoryProvider);
    getThemeModeUseCase = GetThemeMode(themeRepository);
    setThemeModeUseCase = SetThemeMode(themeRepository);
    return await getThemeModeUseCase();
  }

  Future<void> setThemeMode(bool isLightMode) async {
    await setThemeModeUseCase(isLightMode);
    state = AsyncValue.data(isLightMode);
  }
}
