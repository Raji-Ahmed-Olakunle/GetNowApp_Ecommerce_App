class Review {
  final String? userId;
  final double? rating;
  final String? comment;
  final String? date;

  Review([
    this.userId,
    this.rating,
    this.comment,
    this.date,
  ]);

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        json['userId'] as String?,
        (json['rating'] as num?)?.toDouble(),
        json['comment'] as String?,
        json['date'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'rating': rating,
        'comment': comment,
        'date': date,
      };
}
