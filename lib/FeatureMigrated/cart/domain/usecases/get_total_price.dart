import '../repositories/cart_repository.dart';

class GetTotalPrice {
  final CartRepository repository;
  GetTotalPrice(this.repository);

  double call() {
    return repository.getTotalPrice();
  }
} 