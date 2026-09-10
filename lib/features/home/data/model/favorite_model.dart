class FavoriteModel {
  final String propertyId;
  final bool isLiked;

  const FavoriteModel({required this.propertyId, required this.isLiked});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
    propertyId: (json['propertyId'] ?? '').toString(),
    isLiked: json['isLiked'] == true,
  );
}
