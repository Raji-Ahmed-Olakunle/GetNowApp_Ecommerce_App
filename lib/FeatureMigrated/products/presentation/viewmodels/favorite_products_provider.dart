import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'products_provider.dart';

final favoriteProductsProvider = Provider((ref) {
  final productsAsync = ref.watch(productsProvider(false));
  return productsAsync.maybeWhen(
    data:
        (products) => products.where((product) => product.isFavourite).toList(),
    orElse: () => [],
  );
});
