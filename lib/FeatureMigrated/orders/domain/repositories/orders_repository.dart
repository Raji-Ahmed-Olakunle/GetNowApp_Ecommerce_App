import '../entities/order_product.dart';

abstract class OrdersRepository {
  Future<List<OrderProduct>> fetchOrders({bool filterUser = true});

  Future<void> addOrder(OrderProduct order);

  Future<void> removeOrder(String orderId);

  Future<bool> hasOrder(String title);
}
