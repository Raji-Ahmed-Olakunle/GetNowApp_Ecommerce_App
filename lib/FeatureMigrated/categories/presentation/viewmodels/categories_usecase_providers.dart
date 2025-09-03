import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/categories_repository_impl.dart';
import '../../domain/usecases/get_categories.dart';

final categoriesRepositoryProvider = Provider(
  (ref) => CategoriesRepositoryImpl(),
);
final getCategoriesUseCaseProvider = Provider(
  (ref) => GetCategories(ref.read(categoriesRepositoryProvider)),
);
