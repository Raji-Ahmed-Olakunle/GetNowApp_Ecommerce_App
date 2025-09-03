import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/core/utils/image_picker_service.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../../../core/utils/validators.dart';
import '../../../../categories/domain/entities/category.dart';
import '../../../../categories/presentation/viewmodels/categories_provider.dart';
import '../../viewmodels/product_form_actions_provider.dart';
import '../../viewmodels/product_form_provider.dart';
import '../../viewmodels/products_provider.dart';

class ProductInputForm extends ConsumerStatefulWidget {
  final int? index; // For editing existing product

  ProductInputForm({this.index});

  @override
  ConsumerState<ProductInputForm> createState() => _ProductInputFormState();
}

class _ProductInputFormState extends ConsumerState<ProductInputForm> {
  final _formkey = GlobalKey<FormState>();
  var Categories;
  final ImagePickerService _imagePickerService = ImagePickerService();
  final categoriesControler = MultiSelectController<Category>();

  FocusNode _priceFocusNode = FocusNode();
  FocusNode _descriptionNode = FocusNode();
  FocusNode _ImageUrlNode = FocusNode();
  FocusNode _quantityNode = FocusNode();

  var _isInit = true;
  String? prodid;

  @override
  void initState() {
    super.initState();
    print('in init it is ${widget.index}');

    _ImageUrlNode.addListener(_updateImageUrl);

    Future<void> _loadCategories() async {
      final categoriesAsync = ref.read(categoriesProvider);
      categoriesAsync.when(
        data: (allCategory) {
          Categories = List.generate(allCategory.length, (index) {
            return DropdownItem(
              label: allCategory[index].title,
              value: allCategory[index],
            );
          });
        },
        loading: () {},
        error: (e, st) {},
      );
    }

    // }
    //
    _loadCategories();
  }

  @override
  void didChangeDependencies() {
    if (widget.index != null) {
      // Load existing product for editing
      final product = ref
          .read(productsProvider(true).notifier)
          .findByIndex(widget.index!);
      prodid = product!.id;
      print(prodid);
      // // Load product into form
      // _initValues = {
      //   'title': product.title,
      //   'description': product.description,
      //   'price': product.price.toString(),
      //   'imageUrl': product.imageUrl,
      //   'isFavourite': product.isFavourite.toString(),
      //   'quantity': product.quantity.toString(),
      // };
      // await formNotifier.loadProduct((await product)!);

      categoriesControler.setItems(Categories);
      (product.category as List<dynamic>).forEach((cat) {
        try {
          final selectedItem = categoriesControler.items.firstWhere(
            (dropd) => dropd.value.title == cat,
          );
          selectedItem.selected = true;
        } catch (e) {
          print("Category '$cat' not found in dropdown items.");
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _ImageUrlNode.removeListener(_updateImageUrl);
    categoriesControler.dispose();
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _ImageUrlNode.dispose();
    _quantityNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_ImageUrlNode.hasFocus) {
      final formNotifier = ref.read(productFormProvider(widget.index).notifier);
      final imageUrl = formNotifier.state.imageUrl;

      if ((!imageUrl.startsWith('http') && !imageUrl.startsWith('https')) ||
          (!imageUrl.endsWith('.png') &&
              !imageUrl.endsWith('.jpg') &&
              !imageUrl.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _pickImageFromGallery() async {
    final file = await _imagePickerService.pickImageFromGallery();
    if (file != null) {
      final formActions = ref.read(
        productFormActionsProvider(widget.index).notifier,
      );
      await formActions.uploadImage(file);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final file = await _imagePickerService.pickImageFromCamera();
    if (file != null) {
      final formActions = ref.read(
        productFormActionsProvider(widget.index).notifier,
      );
      await formActions.uploadImage(file);
    }
  }

  void _saveForm() async {
    final formNotifier = ref.read(productFormProvider(widget.index).notifier);
    final formActions = ref.read(
      productFormActionsProvider(widget.index).notifier,
    );
    print(_formkey.currentState?.validate());
    // Validate form
    if (!_formkey.currentState!.validate()) {
      return;
    }

    // Get selected categories
    List<String> catTemp = [];
    categoriesControler.selectedItems.forEach((cat) {
      catTemp.add(cat.label);
    });

    // Update form with categories
    formNotifier.updateCategories(catTemp);

    // Save the form
    _formkey.currentState!.save();
    print(prodid);
    // Call the action to save product
    await formActions.saveProduct(index: widget.index, productId: prodid);

    // Navigate back
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(productFormProvider(widget.index));
    final formNotifier = ref.read(productFormProvider(widget.index).notifier);
    final formActions = ref.watch(productFormActionsProvider(widget.index));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.index != null ? 'Edit Product' : 'Add Product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formkey,
              // key:
              //_formkey,
              child: ListView(
                children: [
                  // Title Field
                  TextFormField(
                    //initialValue: '',
                    initialValue: formState.title,
                    onSaved: (value) => formNotifier.updateTitle(value ?? ''),
                    validator: validateTitle,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    decoration: InputDecoration(labelText: 'Title'),
                  ),

                  // Price Field
                  TextFormField(
                    initialValue:
                        formState.price == null
                            ? ''
                            : formState.price.toString(),
                    onSaved: (value) {
                      final price = double.tryParse(value ?? '0') ?? 0;
                      formNotifier.updatePrice(price);
                    },

                    validator: validatePrice,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_quantityNode);
                    },
                    decoration: InputDecoration(labelText: 'Price'),
                  ),

                  // Quantity Field
                  TextFormField(
                    initialValue:
                        formState.quantity == null
                            ? ''
                            : formState.quantity.toString(),
                    onSaved: (value) {
                      final quantity = int.tryParse(value ?? '0') ?? 0;
                      formNotifier.updateQuantity(quantity);
                    },
                    validator: validateQuantity,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_descriptionNode);
                    },
                    decoration: InputDecoration(labelText: 'Quantity'),
                  ),

                  // Description Field
                  TextFormField(
                    initialValue: formState.description,
                    onSaved:
                        (value) => formNotifier.updateDescription(value ?? ''),
                    validator: validateDescription,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_ImageUrlNode);
                    },
                    decoration: InputDecoration(labelText: 'Description'),
                  ),

                  // Product Category
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Product Category'),
                  ),

                  MultiDropdown<Category>(
                    items: Categories,
                    maxSelections: 2,
                    controller: categoriesControler,
                    searchEnabled: true,
                    enabled: true,
                    chipDecoration: const ChipDecoration(
                      wrap: true,
                      spacing: 10,
                      runSpacing: 2,
                    ),
                    dropdownItemDecoration: DropdownItemDecoration(
                      selectedIcon: const Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                      disabledIcon: const Icon(Icons.check_box_outline_blank),
                    ),
                    dropdownDecoration: DropdownDecoration(
                      marginTop: 10,
                      maxHeight: 400,
                      header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Select Product Categories (pick 2)",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    fieldDecoration: FieldDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black87),
                      ),
                    ),
                    validator: validateCategories,
                  ),

                  // Image URL Field
                  // TextFormField(
                  //   initialValue: formState.imageUrl,
                  //   onSaved:
                  //       (value) => formNotifier.updateImageUrl(value ?? ''),
                  //   validator: validateImageUrl,
                  //   keyboardType: TextInputType.url,
                  //   textInputAction: TextInputAction.done,
                  //   decoration: InputDecoration(labelText: 'Image URL'),
                  // ),

                  // Image Upload Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Or Upload Image'),
                  ),

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: Icon(Icons.photo_library),
                        label: Text('Gallery'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _pickImageFromCamera,
                        icon: Icon(Icons.camera_alt),
                        label: Text('Camera'),
                      ),
                    ],
                  ),

                  // Display current image
                  if (formState.imageUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.network(
                        formState.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  // Loading indicator
                  // if (formState.isLoading)
                  //   Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: Center(child: CircularProgressIndicator()),
                  //   ),
                  //
                  // // Error message
                  // if (formState.error!.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: Text(
                  //       formState.error!,
                  //       style: TextStyle(color: Colors.red),
                  //     ),
                  //   ),

                  // Save Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: formState.isLoading ? null : _saveForm,
                      child:
                          formState.isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                widget.index != null
                                    ? 'Update Product'
                                    : 'Add Product',
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
