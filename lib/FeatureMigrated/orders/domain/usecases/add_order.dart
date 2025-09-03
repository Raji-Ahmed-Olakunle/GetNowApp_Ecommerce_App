import '../entities/order_product.dart';
import '../repositories/orders_repository.dart';

class AddOrder {
  final OrdersRepository repository;
  AddOrder(this.repository);

  Future<void> call(OrderProduct order) => repository.addOrder(order);
} 