import 'home_model.dart';

class PropertyDetailModel {
  final PropertyModel property;
  final String houseRules;
  final String checkInTime;
  final String checkOutTime;
  final int minimumNights;
  final int maximumNights;
  final bool isAvailable;
  final List<GuestReviewModel> reviews;

  const PropertyDetailModel({
    required this.property,
    this.houseRules = '',
    this.checkInTime = '',
    this.checkOutTime = '',
    this.minimumNights = 1,
    this.maximumNights = 365,
    this.isAvailable = true,
    this.reviews = const [],
  });

  factory PropertyDetailModel.fromJson(Map<String, dynamic> json) {
    final raw = json['property'] is Map
        ? Map<String, dynamic>.from(json['property'])
        : json;
    return PropertyDetailModel(
      property: PropertyModel.fromJson(raw),
      houseRules: raw['houseRules']?.toString() ?? '',
      checkInTime: raw['checkInTime']?.toString() ?? '',
      checkOutTime: raw['checkOutTime']?.toString() ?? '',
      minimumNights: raw['minimumNights'] is num
          ? raw['minimumNights'].toInt()
          : 1,
      maximumNights: raw['maximumNights'] is num
          ? raw['maximumNights'].toInt()
          : 365,
      isAvailable: raw['isAvailable'] == false || raw['available'] == false
          ? false
          : true,
      reviews:
          json['reviews'] is Map && (json['reviews'] as Map)['reviews'] is List
          ? ((json['reviews'] as Map)['reviews'] as List)
                .whereType<Map>()
                .map(
                  (review) => GuestReviewModel.fromJson(
                    Map<String, dynamic>.from(review),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class GuestReviewModel {
  final String guestName;
  final String comment;
  final double rating;
  final DateTime? createdAt;
  const GuestReviewModel({
    required this.guestName,
    required this.comment,
    required this.rating,
    this.createdAt,
  });
  factory GuestReviewModel.fromJson(Map<String, dynamic> json) {
    final guest = json['guest'] is Map
        ? Map<String, dynamic>.from(json['guest'])
        : const <String, dynamic>{};
    final value = json['rating'];
    return GuestReviewModel(
      guestName: guest['name']?.toString() ?? 'Guest',
      comment: json['comment']?.toString() ?? '',
      rating: value is num
          ? value.toDouble()
          : double.tryParse(value?.toString() ?? '') ?? 0,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
