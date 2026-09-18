String get storageUrl => "https://com.app/storage/app/public/";

class ApiUrl {
  static const String version = "v1";

  // static String get baseUrl => "http://192.168.0.51:5000/api/$version/";
  // static String get baseUrl => "http://10.25.168.108:5000/api/$version/";
  static String get baseUrl => "http://192.168.31.172:5000/api/$version/";

  static const String register = 'auth/register';
  static const String login = 'auth/login';

  static const String home = 'explore';
  static const String propertyDetail = 'properties/{propertyId}';
  static const String favorite = 'favorites/{propertyId}';
  static const String recentlyViewed = 'recently-viewed';
  static const String recentlyViewedProperty = 'recently-viewed/{id}';
  static const String wishlists = 'wishlists';
  static const String wishlistProperties =
      'wishlists/{wishlistId}/properties/{propertyId}';
  static const String search = 'search';
  static const String searchSuggestions = 'search/suggestions';
  static const String userProfile = 'user/profile';
}
