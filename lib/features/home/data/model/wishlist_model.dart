import 'home_model.dart';

class WishlistModel {
  final String id;
  final String name;
  final List<WishlistPropertyModel> properties;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WishlistModel({
    this.id = '',
    this.name = '',
    this.properties = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
    id: (json['_id'] ?? json['id'] ?? '').toString(),
    name: (json['name'] ?? '').toString(),
    properties: json['properties'] is List
        ? (json['properties'] as List)
              .whereType<Map>()
              .map(
                (item) => WishlistPropertyModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
        : const [],
    createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()),
    updatedAt: DateTime.tryParse((json['updatedAt'] ?? '').toString()),
  );

  static WishlistModel fromResponseJson(Map<String, dynamic> json) {
    final value = json['wishlist'];
    return WishlistModel.fromJson(
      value is Map ? Map<String, dynamic>.from(value) : json,
    );
  }
}

class WishlistPropertyModel {
  final String id;
  final PropertyModel? property;
  final DateTime? addedAt;

  const WishlistPropertyModel({this.id = '', this.property, this.addedAt});

  factory WishlistPropertyModel.fromJson(Map<String, dynamic> json) =>
      WishlistPropertyModel(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        property: json['property'] is Map
            ? PropertyModel.fromJson(
                Map<String, dynamic>.from(json['property']),
              )
            : null,
        addedAt: DateTime.tryParse((json['addedAt'] ?? '').toString()),
      );
}
