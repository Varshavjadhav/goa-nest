String get storageUrl => "https://com.app/storage/app/public/";

class ApiUrl {
  static const String version = "v1";

  static String get baseUrl => "http://192.168.0.74:5000/api/$version/";

  static const String register = 'auth/register';
  static const String login = 'auth/login';

  static const String appVersion = 'app-version';
}
