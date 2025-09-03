import '../entities/product.dart';
import '../repositories/products_repository.dart';

class UpdateProduct {
  final ProductsRepository repository;
  UpdateProduct(this.repository);

  Future<void> call(String productId, Product product) => repository.updateProduct(productId, product);
} 