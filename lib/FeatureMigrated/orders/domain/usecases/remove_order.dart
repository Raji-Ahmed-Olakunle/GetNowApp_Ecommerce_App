import '../repositories/orders_repository.dart';

class RemoveOrder {
  final OrdersRepository repository;
  RemoveOrder(this.repository);

  Future<void> call(String orderId) => repository.removeOrder(orderId);
} 