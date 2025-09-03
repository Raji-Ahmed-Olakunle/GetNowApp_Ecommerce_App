import '../../domain/entities/cart_product.dart';
import '../../domain/repositories/cart_repository.dart';
import '../models/cart_product_model.dart';

class CartRepositoryImpl implements CartRepository {
  final String token;
  final String userId;

  CartRepositoryImpl({required this.token, required this.userId});

  final Map<String, CartProductModel> _cart = {};

  @override
  Map<String, CartProduct> getCart() => _cart;

  @override
  void addCartProduct(
    String productId,
    String title,
    double price,
    String imageUrl,
  ) {
    if (!_cart.containsKey(productId)) {
      _cart[productId] = CartProductModel(
        id: productId,
        title: title,
        price: price,
        quantity: 1,
        imageUrl: imageUrl,
      );
    }
  }

  @override
  void increaseQuantity(String productId) {
    if (_cart.containsKey(productId)) {
      final item = _cart[productId]!;
      _cart[productId] = item.copyWith(
        id: item.id,
        title: item.title,
        price: item.price,
        imageUrl: item.imageUrl,
        quantity: item.quantity + 1,
      );
    }
  }

  @override
  void decreaseQuantity(String productId) {
    if (_cart.containsKey(productId)) {
      final item = _cart[productId]!;
      if (item.quantity > 1) {
        _cart[productId] = item.copyWith(
          id: item.id,
          title: item.title,
          price: item.price,
          imageUrl: item.imageUrl,
          quantity: item.quantity - 1,
        );
      } else {
        _cart.remove(productId);
      }
    }
  }

  @override
  void removeProduct(String productId) {
    _cart.remove(productId);
  }

  @override
  void clearCart() {
    _cart.clear();
  }

  @override
  double getTotalPrice() {
    double sum = 0.0;
    _cart.forEach((key, item) {
      sum += item.price * item.quantity;
    });
    return sum;
  }
}
