import '../../../reviews/domain/entities/review.dart';
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required String title,
    required String description,
    required double price,
    required String imageUrl,
    required bool isFavourite,
    required int quantity,
    required List<dynamic> category,
    required List<Review> reviews,
  }) : super(
         id: id,
         title: title,
         description: description,
         price: price,
         imageUrl: imageUrl,
         isFavourite: isFavourite,
         quantity: quantity,
         category: category,
         reviews: reviews,
       );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    price: (json['price'] ?? 0).toDouble(),
    imageUrl: json['imageUrl'],
    isFavourite: json['isFavourite'] ?? false,
    quantity: (json['quantity'] ?? 0).toDouble(),
    category: List<String>.from(json['category']),
    reviews:
        (json['reviews'] as List<dynamic>?)
            ?.map((r) => Review.fromJson(r))
            .toList() ??
        [],
  );

  factory ProductModel.fromProduct(Product product) => ProductModel(
    id: product.id,
    title: product.title,
    description: product.description,
    price: product.price,
    imageUrl: product.imageUrl,
    isFavourite: product.isFavourite,
    quantity: product.quantity,
    category: product.category,
    reviews: product.reviews,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'isFavourite': isFavourite,
    'quantity': quantity,
    'category': category,
  };

  ProductModel fromProduct(Product p) {
    return ProductModel(
      id: p.id,
      title: p.title,
      description: p.description,
      price: p.price,
      imageUrl: p.imageUrl,
      isFavourite: p.isFavourite,
      quantity: p.quantity,
      category: p.category,
      reviews: p.reviews,
    );
  }
}
