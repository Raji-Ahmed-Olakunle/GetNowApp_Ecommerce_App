import '../repositories/cart_repository.dart';

class AddCartProduct {
  final CartRepository repository;
  AddCartProduct(this.repository);

  void call(String productId, String title, double price, String imageUrl) {
    repository.addCartProduct(productId, title, price, imageUrl);
  }
} 