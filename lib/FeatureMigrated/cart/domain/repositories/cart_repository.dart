import '../entities/cart_product.dart';

abstract class CartRepository {
  Map<String, CartProduct> getCart();
  void addCartProduct(String productId, String title, double price, String imageUrl);
  void increaseQuantity(String productId);
  void decreaseQuantity(String productId);
  void removeProduct(String productId);
  void clearCart();
  double getTotalPrice();
} 