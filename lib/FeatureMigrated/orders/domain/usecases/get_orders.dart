import '../entities/order_product.dart';
import '../repositories/orders_repository.dart';

class GetOrders {
  final OrdersRepository repository;

  GetOrders(this.repository);

  Future<List<OrderProduct>> call({filterByUser = true}) =>
      repository.fetchOrders(filterUser: filterByUser);
}
