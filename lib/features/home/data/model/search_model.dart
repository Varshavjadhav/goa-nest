import 'explore_model.dart';

class SearchQuery {
  final String query;
  final String city;
  final String country;
  final String propertyType;
  final String category;
  final String minPrice;
  final String maxPrice;
  final int? maxGuests;
  final String bedrooms;
  final String amenities;
  final String minRating;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String sortBy;
  final int page;
  final int limit;

  const SearchQuery({
    this.query = '',
    this.city = '',
    this.country = '',
    this.propertyType = '',
    this.category = '',
    this.minPrice = '',
    this.maxPrice = '',
    this.maxGuests,
    this.bedrooms = '',
    this.amenities = '',
    this.minRating = '',
    this.checkIn,
    this.checkOut,
    this.sortBy = '',
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toQueryParams() => {
    'query': query,
    'city': city,
    'country': country,
    'propertyType': propertyType,
    'category': category,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'maxGuests': maxGuests?.toString() ?? '',
    'bedrooms': bedrooms,
    'amenities': amenities,
    'minRating': minRating,
    'checkIn': _date(checkIn),
    'checkOut': _date(checkOut),
    'sortBy': sortBy,
    'page': page,
    'limit': limit,
  };

  SearchQuery copyWith({
    String? query,
    String? city,
    String? country,
    String? propertyType,
    String? category,
    String? minPrice,
    String? maxPrice,
    int? maxGuests,
    String? bedrooms,
    String? amenities,
    String? minRating,
    DateTime? checkIn,
    DateTime? checkOut,
    String? sortBy,
    int? page,
    int? limit,
  }) => SearchQuery(
    query: query ?? this.query,
    city: city ?? this.city,
    country: country ?? this.country,
    propertyType: propertyType ?? this.propertyType,
    category: category ?? this.category,
    minPrice: minPrice ?? this.minPrice,
    maxPrice: maxPrice ?? this.maxPrice,
    maxGuests: maxGuests ?? this.maxGuests,
    bedrooms: bedrooms ?? this.bedrooms,
    amenities: amenities ?? this.amenities,
    minRating: minRating ?? this.minRating,
    checkIn: checkIn ?? this.checkIn,
    checkOut: checkOut ?? this.checkOut,
    sortBy: sortBy ?? this.sortBy,
    page: page ?? this.page,
    limit: limit ?? this.limit,
  );

  static String _date(DateTime? value) => value == null
      ? ''
      : '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

class SearchResultsModel {
  final List<ExploreProperty> items;
  final int total;
  final int page;
  final int limit;
  final int pages;

  const SearchResultsModel({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.pages = 0,
  });

  factory SearchResultsModel.fromJson(Map<String, dynamic> json) {
    final items = json['items'] is List
        ? _properties(json['items'])
        : _properties(json['properties']);
    final pagination = json['pagination'] is Map
        ? Map<String, dynamic>.from(json['pagination'])
        : <String, dynamic>{};
    return SearchResultsModel(
      items: items,
      total: _int(json['total'] ?? pagination['total']),
      page: _int(json['page'] ?? pagination['page'], fallback: 1),
      limit: _int(json['limit'] ?? pagination['limit'], fallback: 20),
      pages: _int(json['pages'] ?? pagination['pages']),
    );
  }

  static List<ExploreProperty> _properties(dynamic value) => value is List
      ? value
            .whereType<Map>()
            .map(
              (item) =>
                  ExploreProperty.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList()
      : const [];

  static int _int(dynamic value, {int fallback = 0}) => value is num
      ? value.toInt()
      : int.tryParse(value?.toString() ?? '') ?? fallback;
}

class SearchSuggestionModel {
  final String city;
  final String country;
  final int propertyCount;

  const SearchSuggestionModel({
    this.city = '',
    this.country = '',
    this.propertyCount = 0,
  });

  String get label =>
      [city, country].where((item) => item.isNotEmpty).join(', ');

  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) =>
      SearchSuggestionModel(
        city: (json['city'] ?? '').toString(),
        country: (json['country'] ?? '').toString(),
        propertyCount: json['propertyCount'] is num
            ? (json['propertyCount'] as num).toInt()
            : int.tryParse((json['propertyCount'] ?? '').toString()) ?? 0,
      );
}
