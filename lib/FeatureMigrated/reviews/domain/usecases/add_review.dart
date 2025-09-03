import '../entities/review.dart';
import '../repositories/reviews_repository.dart';

class AddReview {
  final ReviewsRepository repository;
  AddReview(this.repository);

  Future<void> call(String productId, Review review) => repository.addReview(productId, review);
} 