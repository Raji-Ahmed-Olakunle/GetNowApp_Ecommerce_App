import '../entities/review.dart';

abstract class ReviewsRepository {
  Future<List<Review>> getReviews(String productId);

  Future<void> addReview(String productId, Review review);
}
