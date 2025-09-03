import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProducts {
  final ProductsRepository repository;

  GetProducts(this.repository);

  Future<List<Product>> call({bool filterByUser = true}) =>
      repository.getProducts(filterByUser: filterByUser);
}
