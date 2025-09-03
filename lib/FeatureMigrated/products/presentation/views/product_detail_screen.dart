import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/viewmodels/products_provider.dart';
import 'package:getnowshopapp/FeatureMigrated/products/presentation/views/widgets/heart.dart';
import 'package:getnowshopapp/FeatureMigrated/reviews/presentation/views/widgets/more_review.dart';
import 'package:getnowshopapp/FeatureMigrated/reviews/presentation/views/widgets/review_bottomsheet.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../core/widgets/app_drawer.dart';
import '../../../auth/presentation/viewmodels/auth_provider.dart';
import '../../../orders/presentation/viewmodels/orders_usecase_providers.dart';
import '../../../reviews/domain/entities/review.dart';
import '../../../reviews/presentation/viewmodels/reviews_usecase_providers.dart';
import '../../domain/entities/product.dart';

class ProductsDetailScreen extends ConsumerStatefulWidget {
  const ProductsDetailScreen({super.key});

  @override
  ConsumerState<ProductsDetailScreen> createState() =>
      _ProductsDetailScreenState();
}

class _ProductsDetailScreenState extends ConsumerState<ProductsDetailScreen> {
  double value = 0;

  // bool? HasOrder;
  // bool? HasRated;

  @override
  Widget build(BuildContext context) {
    bool frontBtn = true;
    bool backBtn = false;
    bool rearBtn = false;
    final productId = GoRouterState.of(context).pathParameters['prodId']!;
    final DeviceSize = MediaQuery.sizeOf(context);
    print("product id is ${productId}");
    WidgetStatesController btn1 = WidgetStatesController();

    // final findProductById = ref.read(findProductByIdUseCaseProvider);
    final getReviews = ref.watch(getReviewsUseCaseProvider);
    final addReview = ref.read(addReviewUseCaseProvider);
    final hasOrder = ref.watch(hasOrderUseCaseProvider);
    final hasUserrated = ref
        .watch(productsProvider(false).notifier)
        .HasRated(productId);
    final auth = ref.read(authProvider);
    final userId = auth.value?.id ?? '';
    final product = ref
        .read(productsProvider(false).notifier)
        .findById(productId);

    // Fetch reviews and hasOrder asynchronously
    return FutureBuilder<List<Review>>(
      future: getReviews(productId),
      builder: (context, snapshot) {
        final reviews = snapshot.data ?? [];
        return FutureBuilder<bool>(
          future: hasOrder((product as Product)!.title),
          builder: (context, orderSnapshot) {
            final hasOrdered = orderSnapshot.data ?? false;
            print(hasOrdered);

            double userRating = 0.0;
            String userComment = '';
            String userDate = '';
            for (var review in reviews) {
              if (review.userId == userId) {
                userRating = review.rating!;
                userComment = review.comment!;
                userDate = review.date!;
                break;
              }
            }

            return FutureBuilder<bool>(
              future: hasUserrated,
              builder: (context, snapshot) {
                final bool hasUserRated = snapshot.data ?? false;
                print(
                  "${hasUserRated} for product ${productId} and the product is ${product}",
                );
                return Scaffold(
                  drawer: const AppDrawer(),
                  appBar: AppBar(
                    title: Text("Product Detail Screen"),
                    centerTitle: true,
                  ),
                  body: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),

                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Hero(
                                tag: productId,
                                child: Image.network(
                                  (product as Product).imageUrl,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: DeviceSize.height * 0.25,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: Heart(index: 0),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (product as Product).title,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.headlineMedium,
                                      ),
                                      Text(
                                        '\$${(product as Product).price.toString()}',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.headlineMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  product.category.join(', '),
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: DeviceSize.height * 0.01,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Description",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                      ),
                                      Text(
                                        product.description,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: DeviceSize.height * 0.01,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "View",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FilledButton.tonal(
                                            statesController: btn1,
                                            onPressed: () {
                                              setState(() {
                                                backBtn = true;
                                                frontBtn = false;
                                                rearBtn = false;
                                              });
                                            },
                                            child: Text('Front'),
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  frontBtn
                                                      ? Colors.black38
                                                      : Colors.grey[200],
                                              foregroundColor:
                                                  frontBtn
                                                      ? Colors.white
                                                      : Colors.black,
                                              shape: OvalBorder(),
                                            ),
                                          ),
                                          FilledButton.tonal(
                                            onPressed: () {
                                              setState(() {
                                                backBtn = false;
                                                frontBtn = true;
                                                rearBtn = false;
                                              });
                                            },
                                            child: Text('Back'),
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  backBtn
                                                      ? Colors.black38
                                                      : Colors.grey[200],
                                              foregroundColor:
                                                  backBtn
                                                      ? Colors.white
                                                      : Colors.black,
                                              shape: OvalBorder(),
                                            ),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              setState(() {
                                                backBtn = false;
                                                frontBtn = false;
                                                rearBtn = true;
                                              });
                                            },
                                            child: Text('Rear'),
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  rearBtn
                                                      ? Colors.black38
                                                      : Colors.grey[200],
                                              foregroundColor:
                                                  rearBtn
                                                      ? Colors.white
                                                      : Colors.black,
                                              shape: OvalBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(
                                    top: DeviceSize.height * 0.01,
                                  ),
                                  child: Column(
                                    children: [
                                      if (hasOrdered && !hasUserRated)
                                        Container(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.9,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.15,

                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Rate this Product",
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.titleLarge,
                                              ),
                                              // StarRating(productId: productId,onclick: setOrder,value:0),
                                              RatingStars(
                                                value: value,
                                                onValueChanged: (v) async {
                                                  setState(() {
                                                    value = v;
                                                  });
                                                  // Use addReviewUseCaseProvider to add review
                                                  final addReview = ref.read(
                                                    addReviewUseCaseProvider,
                                                  );
                                                  await addReview(
                                                    productId,
                                                    Review(
                                                      userId,
                                                      value,
                                                      '',
                                                      DateTime.now()
                                                          .toIso8601String(),
                                                      // '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                                    ),
                                                  );
                                                },
                                                starBuilder:
                                                    (index, color) => Icon(
                                                      Icons.star,
                                                      color: color,
                                                      size: 30,
                                                    ),
                                                starCount: 5,
                                                starSize: 20,
                                                valueLabelColor: const Color(
                                                  0xff9b9b9b,
                                                ),
                                                valueLabelTextStyle:
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 12.0,
                                                    ),
                                                valueLabelRadius: 10,
                                                maxValue: 5,
                                                starSpacing: 10,
                                                maxValueVisibility: false,
                                                valueLabelVisibility: true,
                                                animationDuration: Duration(
                                                  milliseconds: 1000,
                                                ),
                                                valueLabelPadding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 1,
                                                      horizontal: 8,
                                                    ),
                                                valueLabelMargin:
                                                    const EdgeInsets.only(
                                                      right: 8,
                                                      top: 20,
                                                    ),
                                                starOffColor: const Color(
                                                  0xffe7e8ea,
                                                ),
                                                starColor: Colors.yellow,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  showMaterialModalBottomSheet(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  35,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  35,
                                                                ),
                                                          ),
                                                    ),
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            Reviewbottomsheet(
                                                              prodId: productId,
                                                              hasRated:
                                                                  hasUserRated,
                                                              UserRating:
                                                                  userRating,
                                                            ),
                                                  );
                                                },
                                                child: Text("Write a review"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (hasOrdered && hasUserRated)
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: DeviceSize.height * 0.01,
                                          ),
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.9,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.13,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Your Rating",
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.titleLarge,
                                              ),
                                              RatingStars(
                                                value: userRating,
                                                onValueChanged: (v) async {},
                                                starBuilder:
                                                    (index, color) => Icon(
                                                      Icons.star,
                                                      color: color,
                                                      size: 25,
                                                    ),
                                                starCount: 5,
                                                starSize: 20,
                                                valueLabelColor: const Color(
                                                  0xff9b9b9b,
                                                ),
                                                valueLabelTextStyle:
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 12.0,
                                                    ),
                                                valueLabelRadius: 10,
                                                maxValue: 5,
                                                starSpacing: 10,
                                                maxValueVisibility: false,
                                                valueLabelVisibility: true,
                                                animationDuration: Duration(
                                                  milliseconds: 1000,
                                                ),
                                                valueLabelPadding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 1,
                                                      horizontal: 8,
                                                    ),
                                                valueLabelMargin:
                                                    const EdgeInsets.only(
                                                      right: 8,
                                                      top: 20,
                                                    ),
                                                starOffColor: const Color(
                                                  0xffe7e8ea,
                                                ),
                                                starColor: Colors.yellow,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  showMaterialModalBottomSheet(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  35,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  35,
                                                                ),
                                                          ),
                                                    ),
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            Reviewbottomsheet(
                                                              prodId: productId,
                                                              hasRated:
                                                                  hasUserRated,
                                                              UserRating:
                                                                  userRating,
                                                            ),
                                                  );
                                                },
                                                child: Text(
                                                  "Write a review",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.copyWith(
                                                        color:
                                                            Theme.of(
                                                              context,
                                                            ).primaryColor,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (reviews.length > 0)
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: DeviceSize.height * 0.01,
                                          ),
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.9,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Other Ratings",
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.titleLarge,
                                              ),
                                              Container(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.9,
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.3,
                                                child: ListView.builder(
                                                  itemCount: reviews.length,
                                                  itemBuilder:
                                                      (ctx, index) =>
                                                          MoreReview(
                                                            index,
                                                            reviews[index],
                                                          ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: DeviceSize.width * 0.05,
                        ),
                        height: DeviceSize.height * 0.1,

                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: OutlinedButton(
                                onPressed: () {},
                                child: Text('Add to Cart'),
                              ),
                            ),
                            Spacer(flex: 1),
                            Expanded(
                              flex: 2,
                              child: FilledButton(
                                onPressed: () {},
                                child: Text(
                                  'Buy Now',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: FilledButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
