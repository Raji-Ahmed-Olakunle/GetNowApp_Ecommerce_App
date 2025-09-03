import '../repositories/orders_repository.dart';

class HasOrder {
  final OrdersRepository repository;
  HasOrder(this.repository);

  Future<bool> call(String title) => repository.hasOrder(title);
} 