import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/reviews/domain/entities/review.dart';
import 'package:intl/intl.dart';

import '../../../../profile/domain/entities/profile.dart';
import '../../../../profile/presentation/viewmodels/profile_provider.dart';
import '../../viewmodels/reviews_usecase_providers.dart';

class MoreReview extends ConsumerStatefulWidget {
  final int index;
  final Review review;

  MoreReview(this.index, this.review);

  @override
  ConsumerState<MoreReview> createState() => _MoreReviewState();
}

class _MoreReviewState extends ConsumerState<MoreReview> {
  @override
  Widget build(BuildContext context) {
    final getReviews = ref.read(getReviewsUseCaseProvider);
    // final auth = ref.read(authProvider);
    final userId = ref
        .watch(profileProvider.notifier)
        .getProfile(widget.review.userId!);

    return FutureBuilder<Profile?>(
      future: userId,
      builder: (context, snapshot) {
        final Profile profi =
            (snapshot.data) ??
            Profile(id: '', name: '', imageUrl: '') as Profile;
        print(profi.name);
        // For demo, just show the first review not by the current user
        // final review = reviews.firstWhere(
        //   (r) => r.userId != userId,
        //   orElse: () => Review(),
        // );
        // if (review == null) {
        //   return SizedBox.shrink();
        // }
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              minTileHeight: 5,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child:
                    profi.imageUrl == ''
                        ? Icon(Icons.person, size: 25)
                        : Image.network(
                          profi.imageUrl!,
                          height: 40,
                        ), // Placeholder for user image
              ),
              title: Text(
                profi.name!,
                // Placeholder for display name
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RatingStars(
                    value: widget.review.rating!,
                    starBuilder:
                        (index, color) =>
                            Icon(Icons.star, color: color, size: 20),
                    starCount: 5,
                    starSize: 20,
                    valueLabelColor: const Color(0xff9b9b9b),
                    valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0,
                    ),
                    valueLabelRadius: 10,
                    maxValue: 5,
                    starSpacing: 0,
                    maxValueVisibility: false,
                    valueLabelVisibility: false,
                    animationDuration: Duration(milliseconds: 1000),
                    starOffColor: const Color(0xffe7e8ea),
                    starColor: Colors.yellow,
                  ),
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 5,
                    child: Text(
                      DateFormat(
                        'E, dd/MM/yyyy',
                      ).format(DateTime.parse(widget.review.date!)),

                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.review.comment!.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Text(
                    //   "Comment:",
                    //   style: Theme.of(context).textTheme.labelMedium,
                    // ),
                    Text(
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                      widget.review.comment!,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
