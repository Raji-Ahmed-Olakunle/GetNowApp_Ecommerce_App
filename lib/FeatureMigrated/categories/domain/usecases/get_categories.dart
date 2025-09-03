import '../entities/category.dart';
import '../repositories/categories_repository.dart';

class GetCategories {
  final CategoriesRepository repository;
  GetCategories(this.repository);

  Future<List<Category>> call() => repository.getCategories();
} 