import '../core.dart';

class Global {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static String? fcmToken;
  static String? whatsappNumber;
  static double? imageParamHeight;
  static double? imageParamWidth;
  static double frameImageHeight = 360;
  static double? videoParamWidth;
  static double? videoParamHeight;
  static String? popupImage;
  static bool? showPlanScreen;
  static bool? showPlanScreenAfterRegistration;

  /// 🔥 ADD THIS
  static void resetEditor() {
    imageParamHeight = null;
    imageParamWidth = null;

    videoParamWidth = null;
    videoParamHeight = null;

    popupImage = null;
  }
}
