import '../entities/product.dart';
import '../repositories/products_repository.dart';

class RefreshProducts {
  final ProductsRepository repository;
  RefreshProducts(this.repository);

  Future<List<Product>> call({bool filterByUser = true}) => repository.refreshProducts(filterByUser: filterByUser);
} 