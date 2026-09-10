class HomeModel {
  final List<CategoryModel> categories;
  final PropertyCollection popularStays;
  final PropertyCollection recommendedForYou;
  final PropertyCollection recentlyViewed;
  final List<DestinationModel> topDestinations;

  const HomeModel({
    this.categories = const [],
    this.popularStays = const PropertyCollection(),
    this.recommendedForYou = const PropertyCollection(),
    this.recentlyViewed = const PropertyCollection(),
    this.topDestinations = const [],
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    categories: _list(json['categories'], CategoryModel.fromJson),
    popularStays: PropertyCollection.fromJson(json['popularStays']),
    recommendedForYou: PropertyCollection.fromJson(json['recommendedForYou']),
    recentlyViewed: PropertyCollection.fromJson(json['recentlyViewed']),
    topDestinations: _list(json['topDestinations'], DestinationModel.fromJson),
  );
}

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String icon;
  final String description;

  const CategoryModel({
    this.id = '',
    this.name = '',
    this.slug = '',
    this.icon = '',
    this.description = '',
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: _string(json['_id'] ?? json['id']),
    name: _string(json['name']),
    slug: _string(json['slug']),
    icon: _string(json['icon']),
    description: _string(json['description']),
  );
}

class PropertyCollection {
  final List<PropertyModel> properties;
  final int total;
  final int page;
  final int limit;
  final int pages;

  const PropertyCollection({
    this.properties = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.pages = 0,
  });

  factory PropertyCollection.fromJson(dynamic value) {
    final json = value is Map
        ? Map<String, dynamic>.from(value)
        : <String, dynamic>{};
    return PropertyCollection(
      properties: _list(json['properties'], PropertyModel.fromJson),
      total: _int(json['total']),
      page: _int(json['page'], fallback: 1),
      limit: _int(json['limit'], fallback: 20),
      pages: _int(json['pages']),
    );
  }
}

class DestinationModel {
  final String city;
  final String country;
  final String image;
  final int propertyCount;

  const DestinationModel({
    this.city = '',
    this.country = '',
    this.image = '',
    this.propertyCount = 0,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) =>
      DestinationModel(
        city: _string(json['city']),
        country: _string(json['country']),
        image: _string(json['image']),
        propertyCount: _int(json['propertyCount']),
      );
}

class PropertyModel {
  final String id;
  final String title;
  final String description;
  final String propertyType;
  final String pricePerNight;
  final String location;
  final String city;
  final String country;
  final String hostName;
  final String hostAvatar;
  final List<String> images;
  final List<String> amenities;
  final int maxGuests;
  final int bedrooms;
  final int beds;
  final int bathrooms;
  final double rating;
  final int totalReviews;
  final bool isLiked;
  final DateTime? viewedAt;

  const PropertyModel({
    this.id = '',
    this.title = '',
    this.description = '',
    this.propertyType = '',
    this.pricePerNight = '',
    this.location = '',
    this.city = '',
    this.country = '',
    this.hostName = '',
    this.hostAvatar = '',
    this.images = const [],
    this.amenities = const [],
    this.maxGuests = 0,
    this.bedrooms = 0,
    this.beds = 0,
    this.bathrooms = 0,
    this.rating = 0,
    this.totalReviews = 0,
    this.isLiked = false,
    this.viewedAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    final locationJson = json['location'] is Map
        ? Map<String, dynamic>.from(json['location'])
        : <String, dynamic>{};
    final host = json['host'] is Map
        ? Map<String, dynamic>.from(json['host'])
        : <String, dynamic>{};
    return PropertyModel(
      id: _string(json['_id'] ?? json['id']),
      title: _string(json['title']),
      description: _string(json['description']),
      propertyType: _string(json['propertyType']),
      pricePerNight: _numberString(json['pricePerNight']),
      location: _string(locationJson['address']).isNotEmpty
          ? _string(locationJson['address'])
          : '${_string(locationJson['city'])}, ${_string(locationJson['country'])}',
      city: _string(locationJson['city']),
      country: _string(locationJson['country']),
      hostName: _string(host['name']),
      hostAvatar: _string(host['avatar']),
      images: _images(json['images']),
      amenities: _strings(json['amenities']),
      maxGuests: _int(json['maxGuests']),
      bedrooms: _int(json['bedrooms']),
      beds: _int(json['beds']),
      bathrooms: _int(json['bathrooms']),
      rating: _double(json['averageRating']),
      totalReviews: _int(json['totalReviews']),
      isLiked: json['isLiked'] == true,
      viewedAt: DateTime.tryParse(_string(json['viewedAt'])),
    );
  }

  static String _imageValue(dynamic value) {
    if (value is Map) return _string(value['url']);
    return _string(value);
  }
}

String _string(dynamic value) => value?.toString() ?? '';
String _numberString(dynamic value) =>
    value is num ? value.toStringAsFixed(0) : _string(value);
int _int(dynamic value, {int fallback = 0}) =>
    value is num ? value.toInt() : int.tryParse(_string(value)) ?? fallback;
double _double(dynamic value) =>
    value is num ? value.toDouble() : double.tryParse(_string(value)) ?? 0;
List<String> _strings(dynamic value) => value is List
    ? value.map(_string).where((e) => e.isNotEmpty).toList()
    : const [];
List<String> _images(dynamic value) => value is List
    ? value.map(PropertyModel._imageValue).where((e) => e.isNotEmpty).toList()
    : const [];
List<T> _list<T>(dynamic value, T Function(Map<String, dynamic>) mapper) =>
    value is List
    ? value
          .whereType<Map>()
          .map((item) => mapper(Map<String, dynamic>.from(item)))
          .toList()
    : <T>[];
