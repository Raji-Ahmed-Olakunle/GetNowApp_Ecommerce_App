import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/order_product.dart';
import '../../domain/usecases/add_order.dart';
import '../../domain/usecases/fetch_orders.dart';
import '../../domain/usecases/has_order.dart';
import '../../domain/usecases/remove_order.dart';
import 'orders_usecase_providers.dart';

final ordersProvider =
    AsyncNotifierProvider.family<OrdersNotifier, List<OrderProduct>, bool>(
      () => OrdersNotifier(),
    );

class OrdersNotifier extends FamilyAsyncNotifier<List<OrderProduct>, bool> {
  late final FetchOrders fetchOrdersUseCase;
  late final AddOrder addOrderUseCase;
  late final RemoveOrder removeOrderUseCase;
  late final HasOrder hasOrderUseCase;
  late final bool filter;

  OrdersNotifier();

  @override
  Future<List<OrderProduct>> build(filter) async {
    fetchOrdersUseCase = ref.read(fetchOrdersUseCaseProvider);
    addOrderUseCase = ref.read(addOrderUseCaseProvider);
    removeOrderUseCase = ref.read(removeOrderUseCaseProvider);
    hasOrderUseCase = ref.read(hasOrderUseCaseProvider);
    return await fetchOrders(filterByUser: filter);
  }

  Future<List<OrderProduct>> fetchOrders({bool filterByUser = true}) async {
    state = const AsyncValue.loading();
    try {
      final orders = await fetchOrdersUseCase(filterByUser: filterByUser);
      state = AsyncValue.data(orders);
      return orders;
    } catch (e, st) {
      print("gh");
      print(e);
      print(st);

      state = AsyncValue.error(e, st);
      return [];
    }
  }

  Future<void> addOrder(OrderProduct order) async {
    await addOrderUseCase(order);
    await fetchOrders();
  }

  Future<void> removeOrder(String orderId) async {
    await removeOrderUseCase(orderId);
    await fetchOrders();
  }

  Future<bool> hasOrder(String title) async {
    return await hasOrderUseCase(title);
  }
}
