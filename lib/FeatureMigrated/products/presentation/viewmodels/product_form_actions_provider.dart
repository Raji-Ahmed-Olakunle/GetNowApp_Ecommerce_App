import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../domain/entities/product.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/refresh_products.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/upload_product_image.dart';
import 'product_form_provider.dart';
import 'products_usecase_providers.dart';
import 'upload_product_image_provider.dart';

class ProductFormActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final ProductFormNotifier formNotifier;
  final AddProduct addProductUseCase;
  final UpdateProduct updateProductUseCase;
  final UploadProductImage uploadImageUseCase;
  final RefreshProducts refreshProductsUseCase;

  ProductFormActionsNotifier({
    required this.formNotifier,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.uploadImageUseCase,
    required this.refreshProductsUseCase,
  }) : super(const AsyncValue.data(null));

  Future<void> uploadImage(File imageFile) async {
    state = const AsyncValue.loading();
    try {
      final imageUrl = await uploadImageUseCase(imageFile);
      formNotifier.updateImageUrl(imageUrl);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      formNotifier.setError(e.toString());
    }
  }

  Future<void> saveProduct({int? index, String? productId}) async {
    state = const AsyncValue.loading();
    formNotifier.setLoading(true);
    print(productId);
    try {
      final formState = formNotifier.state;

      // Upload image if there's a new image file
      if (formState.imageFile != null) {
        await uploadImage(formState.imageFile!);
      }

      // Create product from form state
      final product = formState.toProduct(
        id:
            productId != null
                ? productId.toString()
                : DateTime.now().millisecondsSinceEpoch.toString(),
      );

      if (index != null) {
        print('updating');
        print(product.id);
        // Update existing product
        await updateProductUseCase(product.id, product);
      } else {
        print('adding');
        // Add new product
        await addProductUseCase(product);
      }
      // formNotifier.reset();
      // Refresh products list (like in original reFreshProduct)
      await refreshProductsUseCase();

      state = const AsyncValue.data(null);
    } catch (e, st) {
      print(st);
      print(e);
      state = AsyncValue.error(e, st);
      formNotifier.setError(e.toString());
    } finally {
      formNotifier.setLoading(false);
    }
  }

  void loadProductForEditing(Product product) {
    formNotifier.loadProduct(product);
  }
}

final productFormActionsProvider = StateNotifierProvider.family<
  ProductFormActionsNotifier,
  AsyncValue<void>,
  int?
>(
  (ref, index) => ProductFormActionsNotifier(
    formNotifier: ref.read(productFormProvider(index).notifier),
    addProductUseCase: ref.read(addProductUseCaseProvider),
    updateProductUseCase: ref.read(updateProductUseCaseProvider),
    uploadImageUseCase: ref.read(uploadProductImageProvider),
    refreshProductsUseCase: ref.read(refreshProductsUseCaseProvider),
  ),
);
