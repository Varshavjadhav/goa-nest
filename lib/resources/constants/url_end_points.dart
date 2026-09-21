String get storageUrl => "https://com.app/storage/app/public/";

class ApiUrl {
  static const String version = "v1";

  static const String configuredBaseUrl = String.fromEnvironment(
    'http://192.168.31.172:5000/api/v1/',
    defaultValue: 'http://192.168.31.172:5000/api/v1/',
  );
  static String get baseUrl => configuredBaseUrl;

  static const String register = 'auth/register';
  static const String login = 'auth/login';

  static const String home = 'home';
  static const String explore = 'explore';
  static const String propertyDetail = 'properties/{propertyId}';
  static const String favorite = 'favorites/{propertyId}';
  static const String recentlyViewed = 'recently-viewed';
  static const String recentlyViewedProperty = 'recently-viewed/{id}';
  static const String wishlists = 'wishlists';
  static const String wishlistProperties = 'wishlists/{wishlistId}/properties/{propertyId}';
  static const String search = 'search';
  static const String searchSuggestions = 'search/suggestions';
  static const String availabilityCheck = 'availability/check';
  static const String bookings = 'bookings';
  static const String bookingDetail = 'bookings/{bookingId}';
  static const String cancelBooking = 'bookings/{bookingId}/cancel';
  static const String userProfile = 'user/profile';
}
