import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../cart/domain/entities/cart_product.dart';
import '../../domain/entities/order_product.dart';
import '../../domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final String token;
  final String userId;

  OrdersRepositoryImpl({required this.token, required this.userId});

  @override
  Future<List<OrderProduct>> fetchOrders({bool filterUser = true}) async {
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/orders.json",
      {
        "orderBy": filterUser ? json.encode('createdId') : '',
        "equalTo": filterUser ? json.encode(userId) : '',
        "auth": token,
      },
    );
    http.Response response = await http.get(uri);
    final loadedOrder = json.decode(response.body) as Map<String, dynamic>?;
    // if (loadedOrder == null) {
    //   return [];
    // }
    List<OrderProduct> extractedOrder = [];
    print(loadedOrder);
    int counter = 0;
    loadedOrder?.forEach((orderId, orderData) {
      counter++;
      print(orderData['ordersProduct']);
      final List<CartProduct> orderProducts =
          (orderData['ordersProduct'] as List<dynamic>)
              .map(
                (item) => CartProduct(
                  id: item['id'] ?? "",
                  price: item['price'] ?? 0.0,
                  quantity: double.parse('${item['quantity']}').toInt() ?? 0,
                  // quantity: 0,
                  title: item['title'] ?? "",
                  imageUrl: item['imageUrl'] ?? "",
                ),
              )
              .toList();
      print(orderProducts);
      extractedOrder.add(
        OrderProduct(
          id: orderId,
          amount: orderData["amount"] ?? 0.0,
          orderProducts: orderProducts,
          dateTime: DateTime.parse(
            orderData['datetime'] ?? DateTime.now().toIso8601String(),
          ),
        ),
      );
      print(extractedOrder);
    });
    // print(counter);
    //
    // print(extractedOrder);
    return extractedOrder;
  }

  @override
  Future<void> addOrder(OrderProduct order) async {
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/orders.json",
      {"auth": token},
    );
    await http.post(
      uri,
      body: json.encode({
        'amount': order.amount,
        'ordersProduct':
            order.orderProducts
                .map(
                  (cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                    'imageUrl': cp.imageUrl,
                  },
                )
                .toList(),
        'datetime': DateTime.now().toIso8601String(),
        'createdId': userId,
      }),
    );
  }

  @override
  Future<void> removeOrder(String orderId) async {
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/orders/$orderId.json",
      {"auth": token},
    );
    final response = await http.delete(uri);
    if (response.statusCode >= 400) {
      throw Exception("Could not delete order");
    }
  }

  @override
  Future<bool> hasOrder(String title) async {
    final orders = await fetchOrders();
    for (final order in orders) {
      for (final product in order.orderProducts) {
        if (product.title == title) {
          return true;
        }
      }
    }
    return false;
  }
}
