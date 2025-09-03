import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../reviews/domain/entities/review.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final String token;
  final String userId;

  ProductsRepositoryImpl({required this.token, required this.userId});

  @override
  Future<List<Product>> getProducts({bool filterByUser = true}) async {
    print('it is ${filterByUser}');
    var uri;
    if (filterByUser) {
      uri = Uri.https(
        "brew-crew-88205-default-rtdb.firebaseio.com",
        "/products.json",
        {
          "orderBy": filterByUser ? json.encode('createdId') : '',
          "equalTo": filterByUser ? json.encode(userId) : '',
          "auth": token,
        },
      );
    } else {
      uri = Uri.https(
        "brew-crew-88205-default-rtdb.firebaseio.com",
        "/products.json",
        {"auth": token},
      );
    }

    final response = await http.get(uri);
    final extractedProduct = jsonDecode(response.body) as Map<String, dynamic>?;

    // Get favorites
    uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/userFavorites/$userId.json",
      {"auth": token},
    );
    final getFavourite = await http.get(uri);
    final favoriteData = json.decode(getFavourite.body);
    print(favoriteData);
    if (extractedProduct == null) return [];

    List<Product> loadedProduct = [];
    extractedProduct.forEach((prodId, prod) {
      final List<Review> reviewData;
      print(prod);
      if (prod['reviews'] != null) {
        reviewData =
            (prod['reviews'] as List<dynamic>?)
                ?.map(
                  (item) => Review(
                    item['userId'] ?? '',
                    item['Rating'] ?? 0.0,
                    item['comment'] ?? '',
                    item['date'] ?? '',
                  ),
                )
                .toList() ??
            [];
      } else {
        reviewData = <Review>[];
      }
      print(favoriteData);

      loadedProduct.add(
        Product(
          id: prodId,
          title: prod['title'] ?? '',
          description: prod['description'] ?? '',
          imageUrl: prod['imageUrl'] ?? '',
          price: (prod['price'] ?? 0).toDouble(),
          isFavourite:
              favoriteData != null ? favoriteData[prodId] ?? false : false,
          quantity: prod['quantity'].toInt() ?? 0.0,
          category: prod['category'] ?? [],
          reviews: reviewData,
        ),
      );
    });
    print(loadedProduct);

    return loadedProduct;
    return [];
  }

  @override
  Future<List<Product>> refreshProducts({bool filterByUser = true}) async {
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/products.json",
      {
        "orderBy": filterByUser ? json.encode('createdId') : '',
        "equalTo": filterByUser ? json.encode(userId) : '',
        "auth": token,
      },
    );

    final response = await http.get(uri);
    final extractedProduct = jsonDecode(response.body) as Map<String, dynamic>?;

    // Get favorites
    uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/userFavorites/$userId.json",
      {"auth": token},
    );
    final getFavourite = await http.get(uri);
    final favoriteData = json.decode(getFavourite.body);

    if (extractedProduct == null) return [];

    List<Product> loadedProduct = [];
    extractedProduct.forEach((prodId, prod) {
      final List<Review> reviewData;
      if (prod['reviews'].length == 0) {
        reviewData =
            (prod['reviews'] as List<dynamic>?)
                ?.map(
                  (item) => Review(
                    item['userId'] ?? '',
                    item['Rating'] ?? 0.0,
                    item['comment'] ?? '',
                    item['date'] ?? '',
                  ),
                )
                .toList() ??
            [];
      } else {
        reviewData =
            (prod['reviews'] as List<dynamic>?)
                ?.map(
                  (item) => Review(
                    item['userId'] ?? '',
                    item['Rating'] ?? 0.0,
                    item['comment'] ?? '',
                    item['date'] ?? '',
                  ),
                )
                .toList() ??
            [];
      }

      loadedProduct.add(
        Product(
          id: prodId,
          title: prod['title'] ?? '',
          description: prod['description'] ?? '',
          imageUrl: prod['imageUrl'] ?? '',
          price: (prod['price'] ?? 0).toDouble(),
          isFavourite: favoriteData[prodId] ?? false,
          quantity: prod['quantity'] ?? 0,
          category: prod['category'] ?? [],
          reviews: reviewData,
        ),
      );
    });

    return loadedProduct;
  }

  @override
  Future<void> addProduct(Product product) async {
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/products.json",
      {"auth": token},
    );
    final response = await http.post(
      uri,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'createdId': userId,
        'quantity': product.quantity,
        'category': product.category,
      }),
    );

    // Add to favorites with false
    final productId = json.decode(response.body)['name'];
    uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/userFavorites/$userId.json",
      {"auth": token},
    );
    await http.post(uri, body: json.encode({"$productId": false}));
  }

  @override
  Future<void> updateProduct(String productId, Product product) async {
    print(productId);
    print(product.title);
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/products/$productId.json",
      {"auth": token},
    );
    await http.patch(
      uri,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'quantity': product.quantity,
        'category': product.category,
      }),
    );
  }

  // @override
  // bool hasRatedProduct(String productId, String userId) {
  //   for (var review in state.value!.firstWhere((prod)=>prod.id==productId).reviews) {
  //     print(review.userId);
  //     if(review.userId==ref.watch(authProvider.notifier).value?.userId){
  //
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  Future<void> toggleFavoriteStatus(
    String productId,
    bool currentStatus,
  ) async {
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/userFavorites/$userId.json",
      {"auth": token},
    );
    await http.patch(uri, body: json.encode({'$productId': !currentStatus}));
  }

  Future<void> removeProduct(String productId) async {
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/products/$productId.json",
      {"auth": token},
    );
    final response = await http.delete(uri);

    if (response.statusCode >= 400) {
      throw Exception("Could not delete product");
    }
  }
}
