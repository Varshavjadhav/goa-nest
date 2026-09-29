class ReviewModel {
  final String id;
  final double rating;
  final String comment;
  final String message;

  const ReviewModel({
    this.id = '',
    this.rating = 0,
    this.comment = '',
    this.message = '',
  });

  ReviewModel copyWith({String? message}) => ReviewModel(
    id: id,
    rating: rating,
    comment: comment,
    message: message ?? this.message,
  );

  factory ReviewModel.fromResponseJson(Map<String, dynamic> json) {
    final review = json['review'] is Map
        ? Map<String, dynamic>.from(json['review'])
        : json;
    final value = review['rating'];
    return ReviewModel(
      id: (review['_id'] ?? review['id'] ?? '').toString(),
      rating: value is num
          ? value.toDouble()
          : double.tryParse(value?.toString() ?? '') ?? 0,
      comment: review['comment']?.toString() ?? '',
    );
  }
}
