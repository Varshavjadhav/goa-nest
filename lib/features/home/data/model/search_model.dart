import 'explore_model.dart';

class SearchQuery {
  final String query;
  final String city;
  final String country;
  final String propertyType;
  final String category;
  final String tab;
  final String minPrice;
  final String maxPrice;
  final int? maxGuests;
  final int infants;
  final int pets;
  final String bedrooms;
  final String amenities;
  final String minRating;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String flexibleDuration;
  final String flexibleMonth;
  final int flexibilityDays;
  final String sortBy;
  final int page;
  final int limit;

  const SearchQuery({
    this.query = '',
    this.city = '',
    this.country = '',
    this.propertyType = '',
    this.category = '',
    this.tab = 'all',
    this.minPrice = '',
    this.maxPrice = '',
    this.maxGuests,
    this.infants = 0,
    this.pets = 0,
    this.bedrooms = '',
    this.amenities = '',
    this.minRating = '',
    this.checkIn,
    this.checkOut,
    this.flexibleDuration = '',
    this.flexibleMonth = '',
    this.flexibilityDays = 0,
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
    'tab': tab,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'maxGuests': maxGuests?.toString() ?? '',
    'infants': infants,
    'pets': pets,
    'bedrooms': bedrooms,
    'amenities': amenities,
    'minRating': minRating,
    'checkIn': _date(checkIn),
    'checkOut': _date(checkOut),
    'flexible': flexibleMonth.isNotEmpty,
    'flexibleDuration': flexibleDuration,
    'flexibleMonth': flexibleMonth,
    'flexibilityDays': flexibilityDays,
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
    String? tab,
    String? minPrice,
    String? maxPrice,
    int? maxGuests,
    int? infants,
    int? pets,
    String? bedrooms,
    String? amenities,
    String? minRating,
    DateTime? checkIn,
    DateTime? checkOut,
    String? flexibleDuration,
    String? flexibleMonth,
    int? flexibilityDays,
    bool clearCheckIn = false,
    bool clearCheckOut = false,
    String? sortBy,
    int? page,
    int? limit,
  }) => SearchQuery(
    query: query ?? this.query,
    city: city ?? this.city,
    country: country ?? this.country,
    propertyType: propertyType ?? this.propertyType,
    category: category ?? this.category,
    tab: tab ?? this.tab,
    minPrice: minPrice ?? this.minPrice,
    maxPrice: maxPrice ?? this.maxPrice,
    maxGuests: maxGuests ?? this.maxGuests,
    infants: infants ?? this.infants,
    pets: pets ?? this.pets,
    bedrooms: bedrooms ?? this.bedrooms,
    amenities: amenities ?? this.amenities,
    minRating: minRating ?? this.minRating,
    checkIn: clearCheckIn ? null : checkIn ?? this.checkIn,
    checkOut: clearCheckOut ? null : checkOut ?? this.checkOut,
    flexibleDuration: flexibleDuration ?? this.flexibleDuration,
    flexibleMonth: flexibleMonth ?? this.flexibleMonth,
    flexibilityDays: flexibilityDays ?? this.flexibilityDays,
    sortBy: sortBy ?? this.sortBy,
    page: page ?? this.page,
    limit: limit ?? this.limit,
  );

  static String _date(DateTime? value) => value == null
      ? ''
      : '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

class SearchFilters {
  final String minPrice;
  final String maxPrice;
  final String propertyType;
  final String bedrooms;
  final String amenities;
  final String minRating;

  const SearchFilters({
    this.minPrice = '',
    this.maxPrice = '',
    this.propertyType = '',
    this.bedrooms = '',
    this.amenities = '',
    this.minRating = '',
  });
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
