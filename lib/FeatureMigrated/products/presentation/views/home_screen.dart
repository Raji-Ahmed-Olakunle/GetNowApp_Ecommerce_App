import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/views/widgets/HomeShimmer.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/views/widgets/category_item.dart';
import 'package:go_router/go_router.dart';

import '../../../../FeatureMigrated/categories/presentation/viewmodels/categories_provider.dart';
// import '../../../../Widgets/CategoryItem.dart';

import '../../../../core/utils/ModeProvider.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/bottombar_widget.dart';
import '../../../cart/presentation/viewmodels/cart_provider.dart';
import '../../data/models/product_model.dart';
import '../viewmodels/products_provider.dart';
import 'widgets/product_card.dart';
// import '../../data/models/product_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider(false));
    final productsNotifier = ref.read(productsProvider(false).notifier);
    final categoriesAsync = ref.watch(categoriesProvider);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (ref.watch(ModeProvider).value!) {
                ref.read(ModeProvider.notifier).setMode(false);
              } else {
                ref.read(ModeProvider.notifier).setMode(true);
              }
            },
            icon:
                ref.watch(ModeProvider).value!
                    ? Icon(Icons.light_mode)
                    : Icon(Icons.dark_mode),
          ),
        ],
        title: Text(
          'Shop App',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            padding: EdgeInsets.symmetric(vertical: 20),
            width: MediaQuery.of(context).size.width * 0.9,
            child: SizedBox(
              height: 35,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          ),
        ),
      ),
      body: productsAsync.when(
        error: (e, st) {
          if (e is HandshakeException) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/image/no-wifi_1686559 (1).png'),
                  Text(
                    'No Internet Connection',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(productsProvider(false).notifier).loadProducts();
                    },
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          }
          if (e is ScaffoldMessenger) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/image/no-wifi_1686559 (1).png'),
                  Text(
                    'No Internet Connection',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(productsProvider(false).notifier).loadProducts();
                    },
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          }
          print(e);
          print(st);
          return Center(child: Text('Error: ${e}'));
        },
        loading: () => Homeshimmer(),
        data:
            (data) => SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Category",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            child: Text(
                              "See more",
                              // style: Theme.of(context).textTheme.labelLarge,
                            ),
                            onPressed: () {
                              // Implement see more for categories
                              context.pushNamed(
                                'ShowMoreScreen',
                                pathParameters: {
                                  'ForType': "All Category",
                                  'Title': "Category",
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Container(
                        height: 150,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: categoriesAsync.when(
                            data: (data) => data.length,
                            loading: () => 0,
                            error: (e, st) => 0,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemBuilder:
                              (ctx, index) => CategoryItem(index: index),
                        ),
                      ),
                      FlutterCarousel(
                        options: FlutterCarouselOptions(
                          viewportFraction: 1,
                          disableCenter: false,
                          clipBehavior: Clip.hardEdge,
                          height: 150.0,
                          showIndicator: true,
                          slideIndicator: CircularSlideIndicator(),
                        ),
                        items:
                            data.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 10,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        i.imageUrl,
                                        width: 300,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Latest",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            child: Text(
                              "See more",
                              // style: Theme.of(context).textTheme.labelLarge,
                            ),
                            onPressed: () {
                              // Implement see more for latest products
                              context.pushNamed(
                                'ShowMoreScreen',
                                pathParameters: {
                                  'ForType': "Latest Product",
                                  'Title': "Latest",
                                },
                                // Optionally pass products as query parameter if needed
                                // queryParameters: {
                                //   'data': json.encode(data.map((p) => p.toJson()).toList()),
                                // },
                              );
                            },
                          ),
                        ],
                      ),
                      Container(
                        height: 220,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (ctx, index) {
                            final product = data[index];
                            return Container(
                              width: 300,
                              height: 100,
                              child: ProductCard(
                                product: ProductModel.fromProduct(product),
                                isFavorite: product.isFavourite,
                                onFavoriteToggle: () async {
                                  await productsNotifier.toggleFavoriteStatus(
                                    product.id,
                                    product.isFavourite,
                                  );
                                },
                                onAddToCart: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addCartProduct(
                                        productId: product.id,
                                        title: product.title,
                                        price: product.price,
                                        imageUrl: product.imageUrl,
                                      );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${product.title} added to cart',
                                      ),
                                    ),
                                  );
                                },
                                index: index,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
      bottomNavigationBar: BottomBar(0, context),
    );
  }
}
