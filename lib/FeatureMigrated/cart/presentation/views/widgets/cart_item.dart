import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/cart_provider.dart';

class CartItem extends ConsumerWidget {
  final double totalSum;

  const CartItem({required this.totalSum, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProduct = ref.watch(cartProvider);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: cartProduct.values.toList().length,
          itemBuilder: (BuildContext context, int index) {
            final item = cartProduct.values.toList()[index];

            return Dismissible(
              onDismissed:
                  (_) => ref.read(cartProvider.notifier).removeProduct(item.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.redAccent,
                child: const Icon(color: Colors.white, Icons.delete, size: 40),
              ),
              key: ValueKey(item.id),
              child: Card.filled(
                elevation: 0.5,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  leadingAndTrailingTextStyle: TextStyle(fontSize: 10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      item.imageUrl,
                      height: 650,
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    "\$" + cartProduct.values.toList()[index]!.price.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: Container(
                    padding: EdgeInsets.zero,
                    height: 35,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .decreaseQuantity(item.id);
                          },
                          style: IconButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.white,
                            minimumSize: Size(25, 25),
                          ),
                          icon: const Icon(
                            Icons.remove,
                            opticalSize: 12.5,
                            size: 12.5,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          item.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .increaseQuantity(item.id);
                          },
                          style: IconButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.white70,
                            minimumSize: Size(25, 25),
                          ),

                          icon: const Icon(
                            Icons.add,
                            opticalSize: 12.5,
                            size: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
