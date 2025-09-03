import '../entities/cart_product.dart';
import '../repositories/cart_repository.dart';

class GetCartProducts {
  final CartRepository repository;

  GetCartProducts(this.repository);

  Map<String, CartProduct> call() => repository.getCart();
}
