import '../entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts({bool filterByUser = true});

  Future<List<Product>> refreshProducts({bool filterByUser = true});

  Future<void> addProduct(Product product);

  Future<void> updateProduct(String productId, Product product);

  // Product findById(String id);
  // Product findByIndex(int index);
  Future<void> removeProduct(String productId);

  Future<void> toggleFavoriteStatus(String productId, bool currentStatus);
}
