class ExploreModel {
  final ExploreSearch search;
  final List<ExploreTab> tabs;
  final ExploreContinueSearching continueSearching;
  final ExplorePropertySection recentlyViewed;
  final ExplorePropertySection recommendedForYou;
  final ExplorePropertySection popularDestinationStays;
  final ExplorePropertySection guestFavourites;
  final List<TripInspiration> tripInspiration;
  final ExploreCategorySection exploreMore;
  final ExploreExperiences experiences;

  const ExploreModel({
    this.search = const ExploreSearch(),
    this.tabs = const [],
    this.continueSearching = const ExploreContinueSearching(),
    this.recentlyViewed = const ExplorePropertySection(),
    this.recommendedForYou = const ExplorePropertySection(),
    this.popularDestinationStays = const ExplorePropertySection(),
    this.guestFavourites = const ExplorePropertySection(),
    this.tripInspiration = const [],
    this.exploreMore = const ExploreCategorySection(),
    this.experiences = const ExploreExperiences(),
  });

  factory ExploreModel.fromJson(Map<String, dynamic> json) => ExploreModel(
    search: ExploreSearch.fromJson(json['search']),
    tabs: _list(json['tabs'], ExploreTab.fromJson),
    continueSearching: ExploreContinueSearching.fromJson(
      json['continueSearching'],
    ),
    recentlyViewed: ExplorePropertySection.fromJson(json['recentlyViewed']),
    recommendedForYou: ExplorePropertySection.fromJson(
      json['recommendedForYou'],
    ),
    popularDestinationStays: ExplorePropertySection.fromJson(
      json['popularDestinationStays'],
    ),
    guestFavourites: ExplorePropertySection.fromJson(json['guestFavourites']),
    tripInspiration: _list(json['tripInspiration'], TripInspiration.fromJson),
    exploreMore: ExploreCategorySection.fromJson(json['exploreMore']),
    experiences: ExploreExperiences.fromJson(json['experiences']),
  );
}

class ExploreSearch {
  final String placeholder;
  final bool filtersAvailable;
  final String queryEndpoint;

  const ExploreSearch({
    this.placeholder = 'Start your search',
    this.filtersAvailable = true,
    this.queryEndpoint = '',
  });

  factory ExploreSearch.fromJson(dynamic value) {
    final json = _map(value);
    return ExploreSearch(
      placeholder: _string(json['placeholder'], fallback: 'Start your search'),
      filtersAvailable: json['filtersAvailable'] != false,
      queryEndpoint: _string(json['queryEndpoint']),
    );
  }
}

class ExploreTab {
  final String key;
  final String label;
  final String icon;
  final bool active;

  const ExploreTab({
    this.key = '',
    this.label = '',
    this.icon = '',
    this.active = false,
  });

  factory ExploreTab.fromJson(Map<String, dynamic> json) => ExploreTab(
    key: _string(json['key']),
    label: _string(json['label']),
    icon: _string(json['icon']),
    active: json['active'] == true,
  );
}

class ExploreContinueSearching {
  final bool visible;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String propertyId;

  const ExploreContinueSearching({
    this.visible = false,
    this.title = '',
    this.subtitle = '',
    this.imageUrl = '',
    this.propertyId = '',
  });

  factory ExploreContinueSearching.fromJson(dynamic value) {
    final json = _map(value);
    return ExploreContinueSearching(
      visible: json['visible'] == true,
      title: _string(json['title']),
      subtitle: _string(json['subtitle']),
      imageUrl: _string(json['imageUrl']),
      propertyId: _string(json['propertyId']),
    );
  }
}

class ExplorePropertySection {
  final String title;
  final List<ExploreProperty> items;
  final int total;
  final int limit;
  final ExploreSeeAll seeAll;

  const ExplorePropertySection({
    this.title = '',
    this.items = const [],
    this.total = 0,
    this.limit = 0,
    this.seeAll = const ExploreSeeAll(),
  });

  factory ExplorePropertySection.fromJson(dynamic value) {
    final json = _map(value);
    return ExplorePropertySection(
      title: _string(json['title']),
      items: _list(json['items'], ExploreProperty.fromJson),
      total: _int(json['total']),
      limit: _int(json['limit']),
      seeAll: ExploreSeeAll.fromJson(json['seeAll']),
    );
  }
}

class ExploreSeeAll {
  final bool enabled;
  final String endpoint;
  const ExploreSeeAll({this.enabled = false, this.endpoint = ''});

  factory ExploreSeeAll.fromJson(dynamic value) {
    final json = _map(value);
    return ExploreSeeAll(
      enabled: json['enabled'] == true,
      endpoint: _string(json['endpoint']),
    );
  }
}

class ExploreProperty {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> images;
  final String propertyType;
  final String location;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final String currency;
  final bool isLiked;

  const ExploreProperty({
    this.id = '',
    this.title = '',
    this.imageUrl = '',
    this.images = const [],
    this.propertyType = '',
    this.location = '',
    this.rating = 0,
    this.reviewCount = 0,
    this.pricePerNight = 0,
    this.currency = 'INR',
    this.isLiked = false,
  });

  factory ExploreProperty.fromJson(Map<String, dynamic> json) {
    final location = _map(json['location']);
    final images = json['images'] is List
        ? (json['images'] as List)
              .map((item) => item is Map ? _string(item['url']) : _string(item))
              .where((item) => item.isNotEmpty)
              .toList()
        : <String>[];
    return ExploreProperty(
      id: _string(json['id'] ?? json['_id']),
      title: _string(json['title']),
      imageUrl: _string(json['imageUrl']).isNotEmpty
          ? _string(json['imageUrl'])
          : (images.isEmpty ? '' : images.first),
      images: images,
      propertyType: _string(json['propertyType']),
      location: _string(location['label']).isNotEmpty
          ? _string(location['label'])
          : '${_string(location['city'])}, ${_string(location['country'])}',
      rating: _double(json['rating']),
      reviewCount: _int(json['reviewCount']),
      pricePerNight: _double(json['pricePerNight']),
      currency: _string(json['currency'], fallback: 'INR'),
      isLiked: json['isLiked'] == true,
    );
  }
}

class TripInspiration {
  final String imageUrl;
  final int propertyCount;
  final String city;
  final String country;
  final String title;
  final String subtitle;

  const TripInspiration({
    this.imageUrl = '',
    this.propertyCount = 0,
    this.city = '',
    this.country = '',
    this.title = '',
    this.subtitle = '',
  });

  factory TripInspiration.fromJson(Map<String, dynamic> json) =>
      TripInspiration(
        imageUrl: _string(json['imageUrl']),
        propertyCount: _int(json['propertyCount']),
        city: _string(json['city']),
        country: _string(json['country']),
        title: _string(json['title']),
        subtitle: _string(json['subtitle']),
      );
}

class ExploreCategorySection {
  final List<ExploreCategory> items;
  final int total;
  const ExploreCategorySection({this.items = const [], this.total = 0});

  factory ExploreCategorySection.fromJson(dynamic value) {
    final json = _map(value);
    return ExploreCategorySection(
      items: _list(json['items'], ExploreCategory.fromJson),
      total: _int(json['total']),
    );
  }
}

class ExploreCategory {
  final String id;
  final String name;
  final String slug;
  final String icon;
  final String description;
  const ExploreCategory({
    this.id = '',
    this.name = '',
    this.slug = '',
    this.icon = '',
    this.description = '',
  });

  factory ExploreCategory.fromJson(Map<String, dynamic> json) =>
      ExploreCategory(
        id: _string(json['id'] ?? json['_id']),
        name: _string(json['name']),
        slug: _string(json['slug']),
        icon: _string(json['icon']),
        description: _string(json['description']),
      );
}

class ExploreExperiences {
  final String title;
  final String subtitle;
  final String ctaLabel;
  final bool enabled;
  final String message;
  const ExploreExperiences({
    this.title = '',
    this.subtitle = '',
    this.ctaLabel = '',
    this.enabled = false,
    this.message = '',
  });

  factory ExploreExperiences.fromJson(dynamic value) {
    final json = _map(value);
    return ExploreExperiences(
      title: _string(json['title']),
      subtitle: _string(json['subtitle']),
      ctaLabel: _string(json['ctaLabel']),
      enabled: json['enabled'] == true,
      message: _string(json['message']),
    );
  }
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
String _string(dynamic value, {String fallback = ''}) =>
    value == null ? fallback : value.toString();
int _int(dynamic value) =>
    value is num ? value.toInt() : int.tryParse(_string(value)) ?? 0;
double _double(dynamic value) =>
    value is num ? value.toDouble() : double.tryParse(_string(value)) ?? 0;
List<T> _list<T>(dynamic value, T Function(Map<String, dynamic>) mapper) =>
    value is List
    ? value
          .whereType<Map>()
          .map((item) => mapper(Map<String, dynamic>.from(item)))
          .toList()
    : <T>[];
