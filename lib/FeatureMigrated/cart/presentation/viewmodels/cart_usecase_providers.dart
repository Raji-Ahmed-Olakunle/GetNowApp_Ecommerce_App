import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/viewmodels/auth_provider.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/usecases/add_cart_product.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/decrease_quantity.dart';
import '../../domain/usecases/get_total_price.dart';
import '../../domain/usecases/increase_quantity.dart';
import '../../domain/usecases/remove_cart_product.dart';

final cartRepositoryProvider = Provider((ref) {
  final auth = ref.watch(authProvider);
  final token = auth.value?.token ?? '';
  final userId = auth.value?.id ?? '';
  return CartRepositoryImpl(token: token, userId: userId);
});
final addCartProductUseCaseProvider = Provider(
  (ref) => AddCartProduct(ref.read(cartRepositoryProvider)),
);
final increaseQuantityUseCaseProvider = Provider(
  (ref) => IncreaseQuantity(ref.read(cartRepositoryProvider)),
);
final decreaseQuantityUseCaseProvider = Provider(
  (ref) => DecreaseQuantity(ref.read(cartRepositoryProvider)),
);
final removeCartProductUseCaseProvider = Provider(
  (ref) => RemoveCartProduct(ref.read(cartRepositoryProvider)),
);
final clearCartUseCaseProvider = Provider(
  (ref) => ClearCart(ref.read(cartRepositoryProvider)),
);
final getTotalPriceUseCaseProvider = Provider(
  (ref) => GetTotalPrice(ref.read(cartRepositoryProvider)),
);
