import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/entities/cart_product.dart';
import '../../domain/usecases/add_cart_product.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/decrease_quantity.dart';
import '../../domain/usecases/get_total_price.dart';
import '../../domain/usecases/increase_quantity.dart';
import '../../domain/usecases/remove_cart_product.dart';
import 'cart_usecase_providers.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartProduct>>(
      (ref) => CartNotifier(
        ref.read(addCartProductUseCaseProvider),
        ref.read(increaseQuantityUseCaseProvider),
        ref.read(decreaseQuantityUseCaseProvider),
        ref.read(removeCartProductUseCaseProvider),
        ref.read(clearCartUseCaseProvider),
        ref.read(getTotalPriceUseCaseProvider),
        ref.read(cartRepositoryProvider),
      ),
    );

class CartNotifier extends StateNotifier<Map<String, CartProduct>> {
  final AddCartProduct addCartProductUseCase;
  final IncreaseQuantity increaseQuantityUseCase;
  final DecreaseQuantity decreaseQuantityUseCase;
  final RemoveCartProduct removeCartProductUseCase;
  final ClearCart clearCartUseCase;
  final GetTotalPrice getTotalPriceUseCase;
  final CartRepositoryImpl repository;

  CartNotifier(
    this.addCartProductUseCase,
    this.increaseQuantityUseCase,
    this.decreaseQuantityUseCase,
    this.removeCartProductUseCase,
    this.clearCartUseCase,
    this.getTotalPriceUseCase,
    this.repository,
  ) : super({});

  void addCartProduct({
    required String productId,
    required String title,
    required double price,
    required String imageUrl,
  }) {
    addCartProductUseCase(productId, title, price, imageUrl);
    state = Map.from(repository.getCart());
  }

  void increaseQuantity(String productId) {
    increaseQuantityUseCase(productId);
    state = Map.from(repository.getCart());
  }

  void decreaseQuantity(String productId) {
    decreaseQuantityUseCase(productId);
    state = Map.from(repository.getCart());
  }

  void removeProduct(String productId) {
    removeCartProductUseCase(productId);
    state = Map.from(repository.getCart());
  }

  void clearCart() {
    clearCartUseCase();
    state = Map.from(repository.getCart());
  }

  double getTotalPrice() {
    return getTotalPriceUseCase();
  }
}
