import '../../domain/entities/category.dart';
import '../../domain/repositories/categories_repository.dart';
import '../models/category_model.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final List<CategoryModel> _categories = [
    CategoryModel(
      id: '1',
      title: 'Electronics',
      imageUrl: 'assets/image/computer.png',
    ),
    CategoryModel(
      id: '2',
      title: 'Clothes',
      imageUrl: 'assets/image/clothes.png',
    ),
    CategoryModel(id: '3', title: 'Shoes', imageUrl: 'assets/image/shoes.png'),
    CategoryModel(
      id: "4",
      title: "Tools",
      imageUrl: "assets/image/under-construction.png",
    ),
    CategoryModel(
      id: "5",
      title: "Cleaning Agents",
      imageUrl: "assets/image/cleaning-tools.png",
    ),
    CategoryModel(
      id: "6",
      title: "Sports Equipment",
      imageUrl: "assets/image/sports-ball.png",
    ),
    CategoryModel(
      id: "7",
      title: "Toys\n&\nGame",
      imageUrl: "assets/image/table-game.png",
    ),
    CategoryModel(id: "8", title: "Bags", imageUrl: "assets/image/luggage.png"),
    CategoryModel(
      id: "9",
      title: "Cosmetic",
      imageUrl: "assets/image/makeup.png",
    ),
    CategoryModel(
      id: "10",
      title: "Foot Wears",
      imageUrl: "assets/image/shoes.png",
    ),
  ];

  @override
  Future<List<Category>> getCategories() async {
    return _categories;
  }
}
