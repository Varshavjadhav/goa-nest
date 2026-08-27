import '../core.dart';

class Global {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static double frameImageHeight = 360;
  static double? imageParamWidth;
}
