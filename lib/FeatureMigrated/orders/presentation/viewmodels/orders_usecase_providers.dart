import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/viewmodels/auth_provider.dart';
import '../../data/repositories/orders_repository_impl.dart';
import '../../domain/usecases/add_order.dart';
import '../../domain/usecases/fetch_orders.dart';
import '../../domain/usecases/has_order.dart';
import '../../domain/usecases/remove_order.dart';

// Assume you have an authProvider that exposes token and userId
// import '../../../FeatureMigrated/auth/presentation/viewmodels/auth_provider.dart';

final ordersRepositoryProvider = Provider((ref) {
  final auth = ref.watch(authProvider);
  final token = auth.value?.token ?? '';
  final userId = auth.value?.id ?? '';
  return OrdersRepositoryImpl(token: token, userId: userId);
});

final fetchOrdersUseCaseProvider = Provider(
  (ref) => FetchOrders(ref.read(ordersRepositoryProvider)),
);
final addOrderUseCaseProvider = Provider(
  (ref) => AddOrder(ref.read(ordersRepositoryProvider)),
);
final removeOrderUseCaseProvider = Provider(
  (ref) => RemoveOrder(ref.read(ordersRepositoryProvider)),
);
final hasOrderUseCaseProvider = Provider(
  (ref) => HasOrder(ref.read(ordersRepositoryProvider)),
);
