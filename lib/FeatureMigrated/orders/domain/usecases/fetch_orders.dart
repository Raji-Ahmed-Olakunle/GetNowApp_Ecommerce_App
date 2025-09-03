import '../entities/order_product.dart';
import '../repositories/orders_repository.dart';

class FetchOrders {
  final OrdersRepository repository;

  FetchOrders(this.repository);

  Future<List<OrderProduct>> call({filterByUser = true}) =>
      repository.fetchOrders(filterUser: filterByUser);
}
