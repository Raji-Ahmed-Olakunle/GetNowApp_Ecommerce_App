import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/viewmodels/auth_provider.dart';
import '../../data/repositories/reviews_repository_impl.dart';
import '../../domain/usecases/add_review.dart';
import '../../domain/usecases/get_reviews.dart';

final reviewsRepositoryProvider = Provider((ref) {
  final auth = ref.watch(authProvider);
  final token = auth.value?.token ?? '';
  final userId = auth.value?.id ?? '';
  return ReviewsRepositoryImpl(token: token, userId: userId);
});

final getReviewsUseCaseProvider = Provider(
  (ref) => GetReviews(ref.read(reviewsRepositoryProvider)),
);
final addReviewUseCaseProvider = Provider(
  (ref) => AddReview(ref.read(reviewsRepositoryProvider)),
);
