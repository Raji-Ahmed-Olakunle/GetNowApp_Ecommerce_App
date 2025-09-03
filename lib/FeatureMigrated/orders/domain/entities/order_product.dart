class OrderProduct {
  final String id;
  final List<dynamic> orderProducts;
  final double amount;
  final DateTime dateTime;

  OrderProduct({
    required this.id,
    required this.orderProducts,
    required this.amount,
    required this.dateTime,
  });
}
