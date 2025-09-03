import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/review.dart';
import '../../domain/repositories/reviews_repository.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final String token;
  final String userId;

  ReviewsRepositoryImpl({required this.token, required this.userId});

  @override
  Future<List<Review>> getReviews(String productId) async {
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/products/$productId.json",
      {"auth": token},
    );
    final response = await http.get(uri);
    final data = json.decode(response.body);
    final reviewsData = data['reviews'] as List<dynamic>?;
    if (reviewsData == null) return [];
    return reviewsData
        .map(
          (item) => Review(
            item['userId'] ?? '',
            (item['Rating'] ?? 0).toDouble(),
            item['comment'] ?? '',
            item['date'] ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<void> addReview(String productId, Review review) async {
    // Fetch current reviews
    final currentReviews = await getReviews(productId);
    // Replace or add review for this user
    final updatedReviews = [
      ...currentReviews.where((r) => r.userId != userId),
      Review(userId, review.rating, review.comment, review.date),
    ];
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/products/$productId.json",
      {"auth": token},
    );
    await http.patch(
      uri,
      body: json.encode({
        'reviews':
            updatedReviews
                .map(
                  (r) => {
                    'userId': r.userId,
                    'Rating': r.rating,
                    'comment': r.comment,
                    'date': r.date,
                  },
                )
                .toList(),
      }),
    );
  }
}
