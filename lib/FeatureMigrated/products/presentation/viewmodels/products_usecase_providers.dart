import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/viewmodels/auth_provider.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/refresh_products.dart';
import '../../domain/usecases/remove_product.dart';
import '../../domain/usecases/toggle_favorite_status.dart';
import '../../domain/usecases/update_product.dart';

final productsRepositoryProvider = Provider((ref) {
  final auth = ref.watch(authProvider);
  final token = auth.value?.token ?? '';
  final userId = auth.value?.id ?? '';
  return ProductsRepositoryImpl(token: token, userId: userId);
});

final getProductsUseCaseProvider = Provider(
  (ref) => GetProducts(ref.read(productsRepositoryProvider)),
);
final addProductUseCaseProvider = Provider(
  (ref) => AddProduct(ref.read(productsRepositoryProvider)),
);
final updateProductUseCaseProvider = Provider(
  (ref) => UpdateProduct(ref.read(productsRepositoryProvider)),
);
final refreshProductsUseCaseProvider = Provider(
  (ref) => RefreshProducts(ref.read(productsRepositoryProvider)),
);
// final hasRatedProductUseCaseProvider = Provider(
//   (ref) => HasRatedProduct(ref.read(productsRepositoryProvider)),
// );
// final findProductByIdUseCaseProvider = Provider(
//   (ref) => FindProductById(ref.read(productsRepositoryProvider)),
// );
// final findProductByIndexUseCaseProvider = Provider(
//   (ref) => FindProductByIndex(ref.read(productsRepositoryProvider)),
// );
final removeProductUseCaseProvider = Provider(
  (ref) => RemoveProduct(ref.read(productsRepositoryProvider)),
);
final toggleFavoriteStatusUseCaseProvider = Provider(
  (ref) => ToggleFavoriteStatus(ref.read(productsRepositoryProvider)),
);
