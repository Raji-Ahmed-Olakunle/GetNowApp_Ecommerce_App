import '../repositories/cart_repository.dart';

class RemoveCartProduct {
  final CartRepository repository;

  RemoveCartProduct(this.repository);

  void call(String id) => repository.removeProduct(id);
}
