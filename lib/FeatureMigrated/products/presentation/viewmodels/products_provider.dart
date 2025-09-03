import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/auth/presentation/viewmodels/auth_provider.dart';

import '../../../orders/presentation/viewmodels/orders_usecase_providers.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/remove_product.dart';
import 'products_usecase_providers.dart';

final productByIdProvider = FutureProvider.autoDispose.family<Product, String>((
  ref,
  productId,
) async {
  final product = await ref
      .read(productsProvider(true).notifier)
      .findById(productId);
  if (product == null) {
    throw Exception('Product not found with ID: $productId');
  }
  return product;
});

final hasRatedProvider = FutureProvider.autoDispose.family<bool, String>((
  ref,
  productId,
) async {
  return ref.read(productsProvider(true).notifier).HasRated(productId);
});

// final reviewsProvider = FutureProvider.autoDispose.family<List<Review>, String>(
//   (ref, productId) async {
//     return ref.read(getReviewsUseCaseProvider)(productId);
//   },
// );

final hasOrderProvider = FutureProvider.autoDispose.family<bool, String>((
  ref,
  productTitle,
) async {
  return ref.read(hasOrderUseCaseProvider)(productTitle);
});
final productsProvider = StateNotifierProvider.family<
  ProductsNotifier,
  AsyncValue<List<Product>>,
  bool // <--- argument type (filterByUser)
>((ref, filterByUser) {
  final getProducts = ref.read(getProductsUseCaseProvider);
  final addProduct = ref.read(addProductUseCaseProvider);
  final removeProduct = ref.read(removeProductUseCaseProvider);

  return ProductsNotifier(
    getProducts,
    addProduct,
    removeProduct,
    ref,
    filterByUser,
  );
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final GetProducts getProductsUseCase;
  final AddProduct addProductUseCase;
  final RemoveProduct removeProductUseCase;
  final Ref ref;
  final bool filterByuser;

  ProductsNotifier(
    this.getProductsUseCase,
    this.addProductUseCase,
    this.removeProductUseCase,
    this.ref,
    this.filterByuser,
  ) : super(const AsyncValue.loading()) {
    loadProducts(filterby: filterByuser);
  }

  Future<void> loadProducts({bool filterby = true}) async {
    state = const AsyncValue.loading();
    try {
      final products = await getProductsUseCase(filterByUser: filterby);
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProduct(Product product) async {
    await addProductUseCase(product);
    await loadProducts();
  }

  Future<void> removeProduct(String productId) async {
    await removeProductUseCase(productId);
    await loadProducts();
  }

  Future<void> toggleFavoriteStatus(
    String productId,
    bool currentStatus,
  ) async {
    final toggleFavoriteStatusUseCase = ref.read(
      toggleFavoriteStatusUseCaseProvider,
    );
    await toggleFavoriteStatusUseCase(productId, currentStatus);
    // await loadProducts();
  }

  Product? findById(String id) {
    try {
      return state.value!.firstWhere((product) => product.id == id);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Product? findByIndex(int index) {
    try {
      return state.value?[index];
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> HasRated(String ProdId) async {
    print('getting ready');
    print(ProdId);
    for (var review
        in state.value!.firstWhere((prod) => prod.id == ProdId).reviews) {
      print(review.userId);
      final user = await ref.watch(authProvider.notifier).fetchAuthDetails();

      print(review);
      print(review.userId);
      if (review.userId == user?.id) {
        print('letgo');
        return true;
      }
    }
    print('could not find');
    return false;
  }
}
