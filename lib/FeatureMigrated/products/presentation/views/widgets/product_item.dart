import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/product.dart';

class ProductItem extends ConsumerWidget {
  final int index;
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddToCart;

  const ProductItem({
    Key? key,
    required this.index,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed('/productDetailScreen', arguments: product.id);
        },
        child: Image.network(product.imageUrl, fit: BoxFit.fill),
      ),
      footer: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: GridTileBar(
          trailing: IconButton(
            onPressed: onAddToCart,
            icon: const Icon(Icons.shopping_cart),
          ),
          leading: IconButton(
            onPressed: onFavoriteToggle,
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
          backgroundColor: Colors.black26,
          title: Text(product.title, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
