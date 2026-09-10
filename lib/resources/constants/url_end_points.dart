String get storageUrl => "https://com.app/storage/app/public/";

class ApiUrl {
  static const String version = "v1";

  static String get baseUrl => "http://192.168.0.51:5000/api/$version/";

  static const String register = 'auth/register';
  static const String login = 'auth/login';

  static const String appVersion = 'app-version';
  static const String home = 'home';
  static const String properties = 'properties';
  static const String propertyDetails = 'properties/{id}';
  static const String favorites = 'favorites/{id}';
  static const String recentlyViewed = 'recently-viewed';
  static const String recentlyViewedProperty = 'recently-viewed/{id}';
  static const String wishlists = 'wishlists';
  static const String wishlist = 'wishlists/{id}';
  static const String wishlistProperty =
      'wishlists/{id}/properties/{propertyId}';
}
