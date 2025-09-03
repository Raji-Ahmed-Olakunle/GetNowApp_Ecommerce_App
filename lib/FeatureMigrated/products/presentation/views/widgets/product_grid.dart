import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../cart/presentation/viewmodels/cart_provider.dart';
import '../../viewmodels/products_provider.dart';
import 'product_item.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider(false));
    return productsAsync.when(
      data:
          (products) => GridView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) {
              final product = products[index];
              // TODO: Provide isFavorite, onFavoriteToggle, onAddToCart from provider/usecase
              return ProductItem(
                index: index,
                product: product,
                isFavorite: product.isFavourite,
                onFavoriteToggle: () {
                  // Implement favorite toggle logic via provider/usecase
                  ref
                      .read(productsProvider(false).notifier)
                      .toggleFavoriteStatus(product.id, !product.isFavourite);
                },
                onAddToCart: () {
                  // Implement add to cart logic via provider/usecase
                  ref
                      .read(cartProvider.notifier)
                      .addCartProduct(
                        productId: product.id,
                        title: product.title,
                        price: product.price,
                        imageUrl: product.imageUrl,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${product.title} added to cart"),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .removeProduct(product.id);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
      error: (e, stack) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
