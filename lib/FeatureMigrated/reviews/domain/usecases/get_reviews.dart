import '../entities/review.dart';
import '../repositories/reviews_repository.dart';

class GetReviews {
  final ReviewsRepository repository;
  GetReviews(this.repository);

  Future<List<Review>> call(String productId) => repository.getReviews(productId);
} 