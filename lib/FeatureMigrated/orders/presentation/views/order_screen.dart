import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/orders/presentation/views/widgets/order_item.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/bottombar_widget.dart';
import '../viewmodels/orders_provider.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderData = ref.watch(ordersProvider(true));
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Your Orders")),
      body: orderData.when(
        data: (orders) {
          print(orders.length == 0);
          if (orders.length == 0)
            return Center(
              child: Text(
                "No Order Order Made Yet",
                style: TextStyle(fontSize: 20),
              ),
            );
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (ctx, index) => OrderItem(orders, index),
          );
        },
        error: (e, st) => const Center(child: Text("Something went wrong")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: BottomBar(2, context),
    );
  }
}
