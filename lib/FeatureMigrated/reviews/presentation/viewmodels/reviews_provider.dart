import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/review.dart';
import '../../domain/usecases/add_review.dart';
import '../../domain/usecases/get_reviews.dart';
import 'reviews_usecase_providers.dart';

final reviewsProvider = StateNotifierProvider.family<
  ReviewsNotifier,
  AsyncValue<List<Review>>,
  String
>(
  (ref, productId) => ReviewsNotifier(
    productId,
    ref.read(getReviewsUseCaseProvider),
    ref.read(addReviewUseCaseProvider),
  ),
);

class ReviewsNotifier extends StateNotifier<AsyncValue<List<Review>>> {
  final String productId;
  final GetReviews getReviewsUseCase;
  final AddReview addReviewUseCase;

  ReviewsNotifier(this.productId, this.getReviewsUseCase, this.addReviewUseCase)
    : super(const AsyncValue.loading()) {
    loadReviews();
  }

  Future<void> loadReviews() async {
    state = const AsyncValue.loading();
    try {
      final reviews = await getReviewsUseCase(productId);
      state = AsyncValue.data(reviews);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Future<void> getReview() {
  //   state = const AsyncValue.loading();
  //   try {
  //     final reviews = await getSingleReviewsUseCase(productId);
  //     state = AsyncValue.data(reviews);
  //   } catch (e, st) {
  //     state = AsyncValue.error(e, st);
  //   }
  // }

  Future<void> addReview(Review review) async {
    await addReviewUseCase(productId, review);
    await loadReviews();
  }
}
