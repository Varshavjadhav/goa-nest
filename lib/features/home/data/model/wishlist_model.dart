import 'home_model.dart';

class WishlistModel {
  final String id;
  final String name;
  final List<WishlistPropertyModel> properties;

  const WishlistModel({
    this.id = '',
    this.name = '',
    this.properties = const [],
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
  );
}

class WishlistPropertyModel {
  final PropertyModel? property;
  final DateTime? addedAt;

  const WishlistPropertyModel({this.property, this.addedAt});

  factory WishlistPropertyModel.fromJson(Map<String, dynamic> json) =>
      WishlistPropertyModel(
        property: json['property'] is Map
            ? PropertyModel.fromJson(
                Map<String, dynamic>.from(json['property']),
              )
            : null,
        addedAt: DateTime.tryParse((json['addedAt'] ?? '').toString()),
      );
}
