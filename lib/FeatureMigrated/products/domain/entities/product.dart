import 'package:getnowshopapp/FeatureMigrated/reviews/domain/entities/review.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool isFavourite;
  final int quantity;
  final List<dynamic> category;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isFavourite,
    required this.quantity,
    required this.category,
    required this.reviews,
  });
}
