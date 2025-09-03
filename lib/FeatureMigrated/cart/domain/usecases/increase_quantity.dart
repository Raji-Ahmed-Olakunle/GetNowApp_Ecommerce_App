import '../repositories/cart_repository.dart';

class IncreaseQuantity {
  final CartRepository repository;
  IncreaseQuantity(this.repository);

  void call(String productId) {
    repository.increaseQuantity(productId);
  }
} 