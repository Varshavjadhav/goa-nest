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

class PropertyModel {
  final String id;
  final String title;
  final String description;
  final String propertyType;
  final String pricePerNight;
  final String location;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final double latitude;
  final double longitude;
  final String hostName;
  final String hostAvatar;
  final String hostBio;
  final String categoryName;
  final String categoryIcon;
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
    this.state = '',
    this.country = '',
    this.zipCode = '',
    this.latitude = 0,
    this.longitude = 0,
    this.hostName = '',
    this.hostAvatar = '',
    this.hostBio = '',
    this.categoryName = '',
    this.categoryIcon = '',
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
      state: _string(locationJson['state']),
      country: _string(locationJson['country']),
      zipCode: _string(locationJson['zipCode']),
      latitude: _double(locationJson['lat']),
      longitude: _double(locationJson['lng']),
      hostName: _string(host['name']),
      hostAvatar: _string(host['avatar']),
      hostBio: _string(host['bio']),
      categoryName: _string(
        json['category'] is Map
            ? (json['category'] as Map)['name']
            : json['category'],
      ),
      categoryIcon: _string(
        json['category'] is Map ? (json['category'] as Map)['icon'] : null,
      ),
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
