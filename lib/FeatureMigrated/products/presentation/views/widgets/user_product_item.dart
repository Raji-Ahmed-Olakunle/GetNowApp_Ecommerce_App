import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/views/widgets/product_input.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../orders/presentation/viewmodels/orders_provider.dart';
import '../../../../reviews/presentation/viewmodels/reviews_provider.dart';
import '../../../domain/entities/product.dart';
import '../../viewmodels/products_provider.dart';
import 'graph_detail.dart';

class UserProductItem extends ConsumerStatefulWidget {
  final List<Product> allProduct;
  final int index;

  UserProductItem(Key key, this.index, this.allProduct) : super(key: key);

  @override
  ConsumerState<UserProductItem> createState() => _UserProductItemState();
}

class _UserProductItemState extends ConsumerState<UserProductItem> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersProvider(true));
    final ReviewsProvider = ref.read(
      reviewsProvider(widget.allProduct[widget.index].id),
    );
    final productsNotifier = ref.read(productsProvider(true).notifier);
    final product = widget.allProduct[widget.index];

    // Calculate sales info from orders
    Map<String, double> salesInfo = {};
    ordersAsync.whenData((orders) {
      for (var order in orders) {
        print('${product.id} is the product id');
        for (var p in order.orderProducts) {
          if (p.id == product.id) {
            final dateKey =
                DateFormat('E, dd/MM/yy').format(order.dateTime) ??
                DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());
            final price = (p.price ?? 0.0) * (p.quantity ?? 1.0);
            salesInfo[dateKey] = (salesInfo[dateKey] ?? 0) + price;
          }
        }
      }
    });

    // Calculate star info from reviews
    return ReviewsProvider.when(
      data: (review) {
        // final reviews = snapshot.data ?? [];
        double star1 = 0, star2 = 0, star3 = 0, star4 = 0, star5 = 0;
        for (var rev in review) {
          if (rev.rating == 1)
            star1++;
          else if (rev.rating == 2)
            star2++;
          else if (rev.rating == 3)
            star3++;
          else if (rev.rating == 4)
            star4++;
          else if (rev.rating == 5)
            star5++;
        }
        double sum = star1 + star2 + star3 + star4 + star5;
        Map<String, double> starInfo = {
          'star1': star1,
          'star2': star2,
          'star3': star3,
          'star4': star4,
          'star5': star5,
          'sum': sum,
        };
        Map<String, double> sortedSalesInfo = Map.fromEntries(
          salesInfo.entries.toList()..sort((a, b) {
            // Parse date keys if possible
            try {
              final dateA = DateTime.parse(a.key);
              final dateB = DateTime.parse(b.key);
              return dateA.compareTo(dateB);
            } catch (_) {
              return a.key.compareTo(b.key);
            }
          }),
        );
        print(salesInfo);
        print(starInfo);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "${widget.index + 1}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(product.imageUrl),
                    ),
                  ],
                ),
                title: Text(product.title),
                trailing: Container(
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                            builder:
                                (context) =>
                                    ProductInputForm(index: widget.index),
                          );
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.lightBlueAccent,
                      ),
                      _isloading
                          ? CircularProgressIndicator()
                          : IconButton(
                            onPressed: () async {
                              setState(() {
                                _isloading = true;
                              });
                              await productsNotifier.removeProduct(product.id);
                              await productsNotifier.loadProducts();
                              setState(() {
                                _isloading = false;
                              });
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                    ],
                  ),
                ),
              ),

              if (starInfo['sum']! > 0 || salesInfo.isNotEmpty)
                GraphicalDetail(
                  salesDetail: sortedSalesInfo,
                  starDetail: starInfo,
                ),
            ],
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        print(error);
        return Text(error.toString());
      },
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
