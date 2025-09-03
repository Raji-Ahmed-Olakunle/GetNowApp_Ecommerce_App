import '../repositories/products_repository.dart';

class RemoveProduct {
  final ProductsRepository repository;
  RemoveProduct(this.repository);

  Future<void> call(String productId) => repository.removeProduct(productId);
} 