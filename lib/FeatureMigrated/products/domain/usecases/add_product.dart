import '../entities/product.dart';
import '../repositories/products_repository.dart';

class AddProduct {
  final ProductsRepository repository;
  AddProduct(this.repository);

  Future<void> call(Product product) => repository.addProduct(product);
} 