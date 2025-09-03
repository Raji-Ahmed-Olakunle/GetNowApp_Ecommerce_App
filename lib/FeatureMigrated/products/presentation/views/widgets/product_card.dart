import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/product_model.dart';

//
// import '../../../../../Feature/product/data/models/products_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddToCart;
  final int index;

  const ProductCard({
    Key? key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onAddToCart,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              //padding: EdgeInsets.zero,
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to product detail screen using GoRouter
                  context.pushNamed(
                    'productDetailScreen',
                    pathParameters: {'prodId': product.id},
                  );
                  // context.go('/details?data=${product.id}');
                },
                child: Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      height: 100,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                        onPressed: onFavoriteToggle,
                      ),
                    ],
                  ),

                  Text(
                    product.category.join(', '),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (product.quantity == 0)
                        Text(
                          'Out of stock',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      else if (product.quantity >= 20)
                        Text(
                          'In stock',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Colors.green),
                        )
                      else
                        Text(
                          '${product.quantity} remaining',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.orangeAccent),
                        ),
                    ],
                  ),
                  Text(
                    '\$${product.price}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 25),
                      const SizedBox(width: 4),
                      Text(
                        product.reviews.isNotEmpty
                            ? (product.reviews
                                        .map((r) => r.rating ?? 0.0)
                                        .reduce((a, b) => a + b) /
                                    product.reviews.length)
                                .toStringAsFixed(1)
                            : '0.0',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: Colors.grey,
                        ),
                        onPressed: onAddToCart,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
