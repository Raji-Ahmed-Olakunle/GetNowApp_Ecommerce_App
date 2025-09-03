import '../../domain/entities/cart_product.dart';

class CartProductModel extends CartProduct {
  CartProductModel({
    required String id,
    required String title,
    required double price,
    required int quantity,
    required String imageUrl,
  }) : super(
         id: id,
         title: title,
         price: price,
         quantity: quantity,
         imageUrl: imageUrl,
       );

  factory CartProductModel.fromJson(Map<String, dynamic> json) =>
      CartProductModel(
        id: json['id'],
        title: json['title'],
        price: (json['price'] ?? 0).toDouble(),
        quantity: json['quantity'] ?? 1,
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'quantity': quantity,
    'imageUrl': imageUrl,
  };

  CartProductModel copyWith({
    String? id,
    String? title,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartProductModel(
      id: id! ?? this.id,
      title: title! ?? this.title,
      price: price!.toDouble() ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl! ?? this.imageUrl,
    );
  }
}
