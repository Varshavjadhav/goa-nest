import 'home_model.dart';

class PropertyDetailModel {
  final PropertyModel property;
  final String houseRules;
  final String checkInTime;
  final String checkOutTime;
  final int minimumNights;
  final int maximumNights;

  const PropertyDetailModel({
    required this.property,
    this.houseRules = '',
    this.checkInTime = '',
    this.checkOutTime = '',
    this.minimumNights = 1,
    this.maximumNights = 365,
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
    );
  }
}
