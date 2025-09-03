import '../../domain/entities/order_product.dart';
import '../../../cart/data/models/cart_product_model.dart';

class OrderProductModel extends OrderProduct {
  OrderProductModel({
    required String id,
    required List<CartProductModel> orderProducts,
    required double amount,
    required DateTime dateTime,
  }) : super(
          id: id,
          orderProducts: orderProducts,
          amount: amount,
          dateTime: dateTime,
        );

  factory OrderProductModel.fromJson(Map<String, dynamic> json) => OrderProductModel(
        id: json['id'],
        orderProducts: (json['orderProducts'] as List<dynamic>?)?.map((item) => CartProductModel.fromJson(item)).toList() ?? [],
        amount: (json['amount'] ?? 0).toDouble(),
        dateTime: DateTime.parse(json['dateTime']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderProducts': orderProducts.map((cp) => (cp as CartProductModel).toJson()).toList(),
        'amount': amount,
        'dateTime': dateTime.toIso8601String(),
      };
} 