import '../repositories/cart_repository.dart';

class DecreaseQuantity {
  final CartRepository repository;
  DecreaseQuantity(this.repository);

  void call(String productId) {
    repository.decreaseQuantity(productId);
  }
} 