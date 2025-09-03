import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/views/widgets/product_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../FeatureMigrated/categories/presentation/viewmodels/categories_provider.dart';
import '../../../categories/presentation/view/CategoryItem.dart';
import '../../data/models/product_model.dart';

class Showmorescreen extends ConsumerStatefulWidget {
  const Showmorescreen();

  @override
  ConsumerState<Showmorescreen> createState() => _ShowmorescreenState();
}

class _ShowmorescreenState extends ConsumerState<Showmorescreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? ForType = GoRouterState.of(context).pathParameters['ForType'];
    String? Title = GoRouterState.of(context).pathParameters['Title'];
    print(ForType);
    final List productsJsonString =
        ForType != 'All Category'
            ? json.decode(
              GoRouterState.of(context).uri.queryParameters['data']!,
            )
            : [];
    final List<ProductModel> Result =
        productsJsonString.map((item) => ProductModel.fromJson(item)).toList();

    return Scaffold(
      appBar: AppBar(title: Text('${Title}')),
      body: GridView.builder(
        itemCount:
            ForType!.contains("Category")
                ? ref
                    .read(categoriesProvider)
                    .maybeWhen(data: (cat) => cat.length, orElse: () => 0)
                : Result.length,
        padding:
            ForType.contains("Category")
                ? EdgeInsets.all(10)
                : EdgeInsets.all(5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ForType.contains("Category") ? 3 : 2,
          childAspectRatio: ForType.contains("Category") ? 2 / 2 : 2 / 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10,
        ),
        itemBuilder:
            (ctx, index) =>
                ForType.contains('Category')
                    ? CategoryWidget(index: index)
                    : ProductCard(
                      index: index,
                      product: Result[index],
                      isFavorite: Result[index].isFavourite,
                      onFavoriteToggle: () {},
                      onAddToCart: () {},
                    ),
      ),
    );
  }
}
