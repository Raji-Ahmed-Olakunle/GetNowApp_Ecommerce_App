import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/bottombar_widget.dart';
import '../../../orders/domain/entities/order_product.dart';
import '../../../orders/presentation/viewmodels/orders_provider.dart';
import '../viewmodels/cart_provider.dart';
import 'widgets/cart_item.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProduct = ref.watch(cartProvider);
    final totalSum = ref.watch(cartProvider.notifier).getTotalPriceUseCase();
    void displayDialog() {
      ref
          .read(ordersProvider(true).notifier)
          .addOrder(
            OrderProduct(
              id: DateTime.now().toString(),
              amount: totalSum,
              orderProducts: cartProduct.values.toList(),
              dateTime: DateTime.now(),
            ),
          );
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text(
                "Confirm Orders",
                style: TextStyle(fontSize: 20),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    const Text(
                      'Your Order List',
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartProduct.length,
                        itemBuilder: (ctx, index) {
                          final prod = cartProduct.values.toList()[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${prod.title} x${prod.quantity}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '\$${prod.quantity * prod.price}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total:"),
                        Text(
                          "\$${ref.read(cartProvider.notifier).getTotalPrice()}",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                    //ref.read(ordersProvider.notifier).removeOrderUseCase();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('OrderScreen');
                    ref.read(cartProvider.notifier).clearCartUseCase();
                  },
                  child: const Text("Proceed"),
                ),
              ],
            ),
      );
    }

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('My Cart'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          CartItem(totalSum: totalSum),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total:", style: TextStyle(fontSize: 20)),

                    Chip(
                      label: Text(
                        "\$${totalSum}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 50),
                    TextButton(
                      onPressed: displayDialog,
                      child: const Text("ORDER NOW"),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomBar(1, context),
    );
  }
}
