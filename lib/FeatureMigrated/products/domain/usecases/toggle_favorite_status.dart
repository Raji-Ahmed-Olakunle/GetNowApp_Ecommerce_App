import '../repositories/products_repository.dart';

class ToggleFavoriteStatus {
  final ProductsRepository repository;
  ToggleFavoriteStatus(this.repository);

  Future<void> call(String productId, bool currentStatus) => repository.toggleFavoriteStatus(productId, currentStatus);
} 