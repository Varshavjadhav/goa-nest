import '../core.dart';
import '../resources/constants/app_colors.dart';
import '../widgets/app_text_widget.dart';
import 'enums/enums_types.dart';
import 'extensions/extensions.dart';
import 'extensions/provide_theme_extension.dart';
import 'global.dart';
import 'package:url_launcher/url_launcher.dart';

enum Result { success, general, error }

class Utils {
  static void showSnackBar(
    String message, {
    String? titleText,
    Result result = Result.general,
    int duration = 1,
    VoidCallback? onTap,
  }) {
    final messenger = Global.scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();

    Color backgroundColor = getColor(result);
    Color textColor = (result == Result.general || result == Result.success)
        ? AppColor.white
        : Global.navigatorKey.currentContext!.themeExt.background;

    IconData icon;
    switch (result) {
      case Result.error:
        icon = Icons.error;
        break;
      case Result.success:
        icon = Icons.check_circle;
        break;
      case Result.general:
        icon = Icons.info;
        break;
    }

    messenger.showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.sp),
        ),
        content: InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 22.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (titleText != null && titleText.isNotEmpty)
                      AppTextWidget(
                        text: titleText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    AppTextWidget(
                      text: message,
                      fontSize: 12.sp,
                      color: textColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color getColor(Result result) {
    switch (result) {
      case Result.error:
        return AppColor.error;
      case Result.success:
        return AppColor.success;
      case Result.general:
        return AppColor.warning;
    }
  }

  static Future<void> openNumpad(String rawValue) async {
    try {
      if (rawValue.trim().isEmpty) {
        Utils.showSnackBar("Invalid phone number", result: Result.error);
        return;
      }

      String cleaned = rawValue.trim();

      if (cleaned.startsWith('tel::')) {
        cleaned = cleaned.replaceFirst('tel::', 'tel:');
      }

      Uri uri;

      if (cleaned.startsWith('tel:')) {
        uri = Uri.parse(cleaned);
      } else {
        final phone = cleaned.replaceAll(RegExp(r'[^0-9+]'), '');
        uri = Uri(scheme: 'tel', path: phone);
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        Utils.showSnackBar("Could not open dialer", result: Result.error);
      }
    } catch (e) {
      debugPrint("Dialer error: $e");
      Utils.showSnackBar("Invalid phone number", result: Result.error);
    }
  }

  static AppImageSource detectImageSource(String url) {
    if (url.isEmpty) {
      return AppImageSource.network;
    }

    final lowerUrl = url.toLowerCase().trim();

    if (lowerUrl.startsWith('data:image')) {
      return AppImageSource.base64;
    }

    if (!lowerUrl.contains('/') &&
        !lowerUrl.contains('.') &&
        lowerUrl.length > 100) {
      return AppImageSource.base64;
    }

    if (lowerUrl.startsWith('file://') ||
        lowerUrl.startsWith('/storage/') ||
        lowerUrl.startsWith('/data/') ||
        lowerUrl.startsWith('/var/') ||
        lowerUrl.startsWith('/private/')) {
      return AppImageSource.file;
    }

    if (lowerUrl.startsWith('assets/')) {
      return AppImageSource.asset;
    }

    if (lowerUrl.endsWith('.svg') || lowerUrl.contains('.svg?')) {
      return AppImageSource.svg;
    }

    return AppImageSource.network;
  }
}
