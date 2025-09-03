import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/auth/presentation/viewmodels/auth_provider.dart';
import 'package:getnowshopapp/FeatureMigrated/reviews/domain/entities/review.dart';
import 'package:getnowshopapp/FeatureMigrated/reviews/presentation/viewmodels/reviews_usecase_providers.dart';

class Reviewbottomsheet extends ConsumerStatefulWidget {
  final String prodId;
  final bool hasRated;
  final double UserRating;

  Reviewbottomsheet({
    required this.prodId,
    required this.hasRated,
    required this.UserRating,
  });

  @override
  ConsumerState<Reviewbottomsheet> createState() => _ReviewbottomsheetState();
}

class _ReviewbottomsheetState extends ConsumerState<Reviewbottomsheet> {
  bool _isloading = false;
  late double value;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    setState(() {
      value = widget.UserRating;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getReviews = ref.read(getReviewsUseCaseProvider);
    final addReview = ref.read(addReviewUseCaseProvider);
    final auth = ref.read(authProvider);
    final userId = auth.value?.id ?? '';
    var productId = widget.prodId;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Give a Review",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          // Star rating input (simple version)
          RatingStars(
            value: value,
            onValueChanged: (val) {
              setState(() {
                value = val;
              });
            },
            starBuilder:
                (index, color) => Icon(Icons.star, color: color, size: 45),
            starCount: 5,
            starSize: 40,
            valueLabelColor: const Color(0xff9b9b9b),
            valueLabelTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 12.0,
            ),
            valueLabelRadius: 10,
            maxValue: 5,
            starSpacing: 5,
            maxValueVisibility: false,
            valueLabelVisibility: false,
            animationDuration: Duration(milliseconds: 1000),
            starOffColor: const Color(0xffe7e8ea),
            starColor: Colors.yellow,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Detail Review"),
                TextField(
                  maxLines: 4,
                  controller: commentController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isloading
              ? Center(child: CircularProgressIndicator())
              : FilledButton(
                onPressed: () async {
                  setState(() {
                    _isloading = true;
                  });
                  await addReview(
                    productId,
                    Review(
                      userId,
                      value ?? 0,
                      commentController.text,
                      DateTime.now().toIso8601String(),
                      // '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                    ),
                  );
                  setState(() {
                    _isloading = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Text("Send Review"),
              ),
        ],
      ),
    );
  }
}
