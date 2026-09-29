import 'package:flutter/foundation.dart';

String get storageUrl => "https://com.app/storage/app/public/";

class ApiUrl {
  static const String version = "v1";

  // Debug builds use ADB reverse forwarding (adb reverse tcp:5001 tcp:5001),
  // which routes device localhost to the development server on the computer.
  static const String developmentBaseUrl = 'http://127.0.0.1:5001/api/v1/';
  static const String productionBaseUrl = 'https://goa-nest.vercel.app/api/v1/';

  // API_BASE_URL can override either default, for example with --dart-define.
  static const String configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
  static String get baseUrl => configuredBaseUrl.isNotEmpty
      ? configuredBaseUrl
      : (kDebugMode ? developmentBaseUrl : productionBaseUrl);

  static const String register = 'auth/register';
  static const String login = 'auth/login';
  static const String refreshToken = 'auth/refresh-token';
  static const String logout = 'auth/logout';
  static const String helpFaqs = 'help/faqs';
  static const String helpContact = 'help/contact';

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
  static const String propertyReviews = 'reviews/{propertyId}';
}
