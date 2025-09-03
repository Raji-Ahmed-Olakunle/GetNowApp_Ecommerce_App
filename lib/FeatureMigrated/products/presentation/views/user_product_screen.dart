import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/views/widgets/product_input.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/views/widgets/user_product_item.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/bottombar_widget.dart' show BottomBar;
import '../viewmodels/products_provider.dart';

class Userproductscreen extends ConsumerStatefulWidget {
  const Userproductscreen({super.key});

  @override
  ConsumerState<Userproductscreen> createState() => _UserproductscreenState();
}

class _UserproductscreenState extends ConsumerState<Userproductscreen> {
  @override
  Widget build(BuildContext context) {
    final allProduct = ref.watch(productsProvider(true));

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                context: context,
                builder: (context) => ProductInputForm(index: null),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
        title: Text("Your Products"),
      ),
      body: RefreshIndicator(
        onRefresh:
            () async =>
                ref.read(productsProvider(true).notifier).loadProducts(),
        child: allProduct.when(
          data: (prod) {
            if (prod.length == 0)
              return Center(
                child: Text(
                  "No Personal product Manage Yet",
                  style: TextStyle(fontSize: 20),
                ),
              );
            return ListView.builder(
              itemCount: prod!.length,
              itemBuilder:
                  (context, index) =>
                      UserProductItem(ValueKey(prod[index].id), index, prod),
            );
          },
          error: (e, stack) {
            if (e.toString().contains("No internet connectivity")) {
              return Center(
                child: Column(
                  children: [
                    Text(
                      "No internet connectivity,check your internet and try again",
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        ref
                            .read(productsProvider(true).notifier)
                            .loadProducts();
                      },
                    ),
                  ],
                ),
              );
            }
            return Text('Error: $e');
          },
          loading: () => CircularProgressIndicator(),
        ),
      ),

      bottomNavigationBar: BottomBar(3, context),
    );
  }
}
