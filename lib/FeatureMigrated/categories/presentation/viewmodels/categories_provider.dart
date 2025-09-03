import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories.dart';
import 'categories_usecase_providers.dart';

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, AsyncValue<List<Category>>>(
      (ref) => CategoriesNotifier(ref.read(getCategoriesUseCaseProvider)),
    );

class CategoriesNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  final GetCategories getCategoriesUseCase;

  CategoriesNotifier(this.getCategoriesUseCase)
    : super(const AsyncValue.loading()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await getCategoriesUseCase();
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
