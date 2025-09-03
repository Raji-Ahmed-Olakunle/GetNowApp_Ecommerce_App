import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/viewmodels/products_provider.dart';

import '../../../reviews/domain/entities/review.dart';
import '../../domain/entities/product.dart';

// import '../../../domain/entities/product.dart';
// import '../../../Models/category.dart';
// import '../../../Models/review.dart';

class ProductFormState {
  final String title;
  final String description;
  final double? price;
  final int? quantity;
  final List<dynamic> categories;
  final String imageUrl;
  final File? imageFile;
  final bool isLoading;
  final String? error;

  ProductFormState({
    this.title = '',
    this.description = '',
    this.price,
    this.quantity,
    this.categories = const [],
    this.imageUrl = '',
    this.imageFile,
    this.isLoading = false,
    this.error,
  });

  ProductFormState copyWith({
    String? title,
    String? description,
    double? price,
    int? quantity,
    List<dynamic>? categories,
    String? imageUrl,
    File? imageFile,
    bool? isLoading,
    String? error,
  }) {
    return ProductFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      categories: categories ?? this.categories,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFile: imageFile ?? this.imageFile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  Product toProduct({required String id}) {
    return Product(
      title: title,
      description: description,
      price: price ?? 0.0,
      quantity: quantity ?? 0,
      category: categories,
      imageUrl: imageUrl,
      isFavourite: false,
      reviews: <Review>[],
      id: id,
    );
  }
}

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Ref? ref;

  ProductFormNotifier({int? index, this.ref}) : super(_loadState(index, ref!));

  static ProductFormState _loadState(int? index, Ref ref) {
    if (index != null) {
      final Product? p = ref
          .read(productsProvider(true).notifier)
          .findByIndex(index);
      if (p != null) {
        return ProductFormState(
          imageUrl: p.imageUrl,
          price: p.price,
          title: p.title,
          description: p.description,
          quantity: p.quantity,
          categories: p.category,
        );
      }
    }
    return ProductFormState();
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updatePrice(double price) {
    state = state.copyWith(price: price);
  }

  void updateQuantity(int quantity) {
    state = state.copyWith(quantity: quantity);
  }

  void updateCategories(List<String> categories) {
    state = state.copyWith(categories: categories);
  }

  void updateImageUrl(String imageUrl) {
    state = state.copyWith(imageUrl: imageUrl);
  }

  void updateImageFile(File imageFile) {
    state = state.copyWith(imageFile: imageFile);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  Future<void> loadProduct(Product product) async {
    state = state.copyWith(
      title: product.title,
      description: product.description,
      price: product.price,
      quantity: product.quantity,
      categories: product.category,
      imageUrl: product.imageUrl,
    );
  }

  Future<void> reset() async {
    state = ProductFormState();
  }
}

final productFormProvider =
    StateNotifierProvider.family<ProductFormNotifier, ProductFormState, int?>(
      (ref, index) => ProductFormNotifier(ref: ref, index: index),
    );
