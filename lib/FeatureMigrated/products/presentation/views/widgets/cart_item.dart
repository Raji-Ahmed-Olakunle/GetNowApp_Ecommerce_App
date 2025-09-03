import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../cart/presentation/viewmodels/cart_provider.dart';
import '../../viewmodels/products_provider.dart';

class CartItem extends ConsumerWidget {
  final double totalSum;

  const CartItem({required this.totalSum, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProduct = ref.watch(productsProvider(false));
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          child: ListView.builder(
            itemCount: cartProduct.value?.toList().length,
            itemBuilder: (BuildContext context, int index) {
              final item = cartProduct.value!.toList()[index];
              return Dismissible(
                onDismissed:
                    (_) => ref
                        .read(productsProvider(false).notifier)
                        .removeProduct(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.redAccent,
                  child: const Icon(
                    color: Colors.white,
                    Icons.delete,
                    size: 40,
                  ),
                ),
                key: ValueKey(item.id),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  leading: ClipRect(
                    child: Image.network(
                      item.imageUrl,
                      height: 500,
                      width: 90,
                      fit: BoxFit.fill,
                    ),
                  ),
                  title: Text(item.title),
                  subtitle: Text(item.price.toString()),
                  trailing: Container(
                    padding: EdgeInsets.zero,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black45),
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
                          icon: const Icon(
                            Icons.remove,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          item.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .increaseQuantity(item.id);
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
