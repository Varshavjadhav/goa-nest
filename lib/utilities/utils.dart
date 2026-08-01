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
  // static Future<void> redirectToPlayStore() async {
  //   const playStoreAppUrl = 'market://details?id=com.bpointer.hindavigraphics';
  //   const playStoreWebUrl = 'https://play.google.com/store/apps/details?id=com.bpointer.hindavigraphics';
  //
  //   try {
  //     final appUri = Uri.parse(playStoreAppUrl);
  //
  //     if (await canLaunchUrl(appUri)) {
  //       await launchUrl(appUri, mode: LaunchMode.platformDefault);
  //     } else {
  //       await launchUrl(Uri.parse(playStoreWebUrl), mode: LaunchMode.platformDefault);
  //     }
  //   } catch (_) {
  //     await launchUrl(Uri.parse(playStoreWebUrl), mode: LaunchMode.platformDefault);
  //   }
  // }

  // static Future<void> openWhatsApp({
  //   required BuildContext context,
  //   required String whatsAppNumber, // without country code
  // }) async {
  //   try {
  //     final text = Uri.encodeComponent("Hello"); // your message
  //     final toNumber = "91$whatsAppNumber"; // country code + number
  //
  //     final uri = Uri.parse("https://api.whatsapp.com/send?phone=$toNumber&text=$text");
  //
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri, mode: LaunchMode.platformDefault);
  //     } else {
  //       Utils.showSnackBar("WhatsApp is not installed", result: Result.error);
  //     }
  //   } catch (e) {
  //     Utils.showSnackBar("WhatsApp is not installed", result: Result.error);
  //     debugPrint("WhatsApp launch error: $e");
  //   }
  // }

  //   static Future<void> shareApp({required String? referralCode}) async {
  //     try {
  //       final packageInfo = await PackageInfo.fromPlatform();
  //       final appId = packageInfo.packageName;
  //
  //       final shareMessage =
  //           '''
  // Let me recommend you this application.
  //
  // Use my referral code to register: ${referralCode ?? ""}
  //
  // Link: https://play.google.com/store/apps/details?id=$appId
  // ''';
  //
  //       await SharePlus.instance.share(ShareParams(subject: packageInfo.appName, text: shareMessage.trim()));
  //     } catch (e) {
  //       debugPrint("Share failed: $e");
  //     }
  //   }

  // static double averageRating(List<int> rating) {
  //   var avgRating = 0;
  //   for (int i = 0; i < rating.length; i++) {
  //     avgRating = avgRating + rating[i];
  //   }
  //   return double.parse((avgRating / rating.length).toStringAsFixed(1));
  // }
  //
  // static void fieldFocusChange(FocusNode current, FocusNode nextFocus) {
  //   current.unfocus();
  //   FocusScope.of(Global.navigatorKey.currentContext!).requestFocus(nextFocus);
  // }
  //
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
  //
  // static String formatCurrency(num amount, {String locale = 'en_IN', String symbol = "₹ "}) {
  //   final format = NumberFormat.currency(locale: locale, symbol: symbol);
  //   return format.format(amount);
  // }
  //
  // static double getValueBasedOnIndex(int index, int listLength, {double padding = 8.0}) {
  //   if (listLength == 2 && index == 1) {
  //     return padding.h;
  //   }
  //   if (index == listLength - 1) {
  //     return 0.0;
  //   } else {
  //     return padding.h;
  //   }
  // }

  static Future<String?> convertBase64Image(
    String? path, {
    bool fromAssets = true,
  }) async {
    if (path == null) return null;
    if (fromAssets) {
      // Load the image as ByteData from assets
      ByteData imageBytes = await rootBundle.load(path);
      // Convert ByteData to Uint8List
      Uint8List bytes = imageBytes.buffer.asUint8List();
      // Convert bytes to Base64 string
      String base64Image0 = base64Encode(bytes);
      return base64Image0;
    } else {
      File image = File(path);
      var imageBytes0 = await image.readAsBytes();
      var base64Image = base64Encode(imageBytes0);
      return base64Image;
    }
  }

  // static Future<void> openEmail(String email) async {
  //   try {
  //     if (email.trim().isEmpty) {
  //       Utils.showSnackBar("Invalid email address", result: Result.error);
  //       return;
  //     }
  //
  //     final cleanedEmail = email.trim();
  //
  //     // Basic email validation
  //     final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  //     if (!emailRegex.hasMatch(cleanedEmail)) {
  //       Utils.showSnackBar("Invalid email address", result: Result.error);
  //       return;
  //     }
  //
  //     final uri = Uri(scheme: 'mailto', path: cleanedEmail);
  //
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri, mode: LaunchMode.platformDefault);
  //     } else {
  //       Utils.showSnackBar("No email app found", result: Result.error);
  //     }
  //   } catch (e) {
  //     debugPrint("Email launch error: $e");
  //     Utils.showSnackBar("Could not open email app", result: Result.error);
  //   }
  // }

  static Future<void> openNumpad(String rawValue) async {
    try {
      if (rawValue.trim().isEmpty) {
        Utils.showSnackBar("Invalid phone number", result: Result.error);
        return;
      }

      String cleaned = rawValue.trim();

      // Fix common backend mistake: tel::
      if (cleaned.startsWith('tel::')) {
        cleaned = cleaned.replaceFirst('tel::', 'tel:');
      }

      Uri uri;

      if (cleaned.startsWith('tel:')) {
        uri = Uri.parse(cleaned);
      } else {
        // Extract only digits and +
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

  static Map<String, Object> convertMapValuesToString(
    Map<String, dynamic> input,
  ) {
    final Map<String, String> result = {};

    input.forEach((key, value) {
      if (value == null) {
        // skip null values
        return;
      } else if (value is bool) {
        result[key] = value ? "true" : "false"; // ✅ bool -> string
      } else if (value is String || value is num) {
        result[key] = value.toString();
      } else {
        // skip unsupported types like List/Map
        debugPrint("Skipped $key: unsupported type (${value.runtimeType})");
      }
    });

    return result;
  }

  static int Function(int max) getRandomInt = (max) => Random().nextInt(max);

  // static Future<void> openSocialLink({required SocialPlatform platform, required String? value}) async {
  //   if (value == null || value.trim().isEmpty) {
  //     Utils.showSnackBar("Link not available", result: Result.general);
  //     return;
  //   }
  //
  //   try {
  //     final cleaned = value.trim();
  //     Uri? appUri;
  //     Uri? webUri;
  //
  //     switch (platform) {
  //       case SocialPlatform.instagram:
  //         final username = _extractUsername(cleaned);
  //         appUri = Uri.parse('instagram://user?username=$username');
  //         webUri = Uri.parse('https://instagram.com/$username');
  //         break;
  //
  //       case SocialPlatform.facebook:
  //         if (cleaned.startsWith('http')) {
  //           webUri = Uri.parse(cleaned);
  //           appUri = Uri.parse('fb://facewebmodal/f?href=$cleaned');
  //         } else {
  //           appUri = Uri.parse('fb://profile/$cleaned');
  //           webUri = Uri.parse('https://facebook.com/$cleaned');
  //         }
  //         break;
  //
  //       case SocialPlatform.youtube:
  //         if (cleaned.startsWith('http')) {
  //           appUri = Uri.parse(cleaned);
  //           webUri = Uri.parse(cleaned);
  //         } else {
  //           appUri = Uri.parse('https://www.youtube.com/$cleaned');
  //           webUri = Uri.parse('https://www.youtube.com/$cleaned');
  //         }
  //         break;
  //
  //       case SocialPlatform.twitter:
  //         final username = _extractUsername(cleaned);
  //         appUri = Uri.parse('twitter://user?screen_name=$username');
  //         webUri = Uri.parse('https://twitter.com/$username');
  //         break;
  //     }
  //
  //     // Open app first
  //     if (await canLaunchUrl(appUri)) {
  //       await launchUrl(appUri, mode: LaunchMode.platformDefault);
  //       return;
  //     }
  //
  //     // Fallback to web
  //     if (await canLaunchUrl(webUri)) {
  //       await launchUrl(webUri, mode: LaunchMode.platformDefault);
  //       return;
  //     }
  //
  //     Utils.showSnackBar("Could not open link", result: Result.error);
  //   } catch (e) {
  //     debugPrint("Social link error: $e");
  //     Utils.showSnackBar("Invalid social link", result: Result.error);
  //   }
  // }
  //
  // static Future<void> openUrl(String? url) async {
  //   try {
  //     if (url == null || url.trim().isEmpty) {
  //       Utils.showSnackBar("Invalid link", result: Result.error);
  //       return;
  //     }
  //
  //     final uri = Uri.parse(url.trim());
  //
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri, mode: LaunchMode.platformDefault);
  //     } else {
  //       Utils.showSnackBar("Could not open link", result: Result.error);
  //     }
  //   } catch (e) {
  //     debugPrint("URL launch error: $e");
  //     Utils.showSnackBar("Invalid link", result: Result.error);
  //   }
  // }

  static String _extractUsername(String input) {
    String value = input.trim();

    // If full URL → parse using Uri
    if (value.startsWith('http')) {
      final uri = Uri.tryParse(value);
      if (uri != null) {
        // Example pathSegments: ["graphicshindavi", ""]
        final segments = uri.pathSegments.where((e) => e.isNotEmpty).toList();
        if (segments.isNotEmpty) {
          return segments.first; // username always first segment
        }
      }
    }

    // Remove query params manually if still present
    if (value.contains('?')) {
      value = value.split('?').first;
    }

    // Remove trailing slash
    if (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }

    // Remove @ if user entered @username
    if (value.startsWith('@')) {
      value = value.substring(1);
    }

    return value;
  }

  static String formatAddress(List<String?> parts) {
    return parts
        .where((e) => e != null && e.trim().isNotEmpty)
        .map((e) => e!.trim())
        .join(', ');
  }

  static Map<String, dynamic>? safeJsonDecode(String? raw) {
    if (raw == null || raw.isEmpty || raw == 'null') return null;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return null;
  }

  static int compareVersions(String current, String server) {
    final currentParts = current.split('.').map(int.parse).toList();
    final serverParts = server.split('.').map(int.parse).toList();

    for (int i = 0; i < serverParts.length; i++) {
      final c = i < currentParts.length ? currentParts[i] : 0;
      final s = serverParts[i];

      if (c < s) return -1;
      if (c > s) return 1;
    }
    return 0;
  }

  // static Future<void> retrieveProfileData() async {
  //   final secureStorageService = sl<SecureStorageService>();
  //
  //   if (Global.personalProfileDetails == null) {
  //     String userProfileRaw = await secureStorageService.read(Flags.personalProfile) ?? "";
  //     if (userProfileRaw.isNotEmpty) {
  //       Global.personalProfileDetails = UserDetail.fromJson(
  //         jsonDecode(await secureStorageService.read<String>(Flags.personalProfile) ?? ""),
  //       );
  //     }
  //   }
  //
  //   if (Global.politicalProfileDetails == null) {
  //     String userPoliticalProfileRaw = await secureStorageService.read(Flags.politicalProfile) ?? "";
  //     if (userPoliticalProfileRaw.isNotEmpty) {
  //       Global.politicalProfileDetails = UserPoliticalProfile.fromJson(
  //         jsonDecode(await secureStorageService.read<String>(Flags.politicalProfile) ?? ""),
  //       );
  //     }
  //   }
  //
  //   if (Global.businessProfileDetails == null) {
  //     String userBusinessProfileRaw = await secureStorageService.read(Flags.businessProfile) ?? "";
  //
  //     if (userBusinessProfileRaw.isNotEmpty) {
  //       Global.businessProfileDetails = UserBusinessProfile.fromJson(
  //         jsonDecode(await secureStorageService.read<String>(Flags.businessProfile) ?? ""),
  //       );
  //     }
  //   }
  // }
  //
  // static Future<bool> openExternalUrl(String url) async {
  //   try {
  //     final uri = Uri.parse(url.trim());
  //
  //     if (await canLaunchUrl(uri)) {
  //       return await launchUrl(uri, mode: LaunchMode.externalApplication);
  //     }
  //     return false;
  //   } catch (e) {
  //     debugPrint("External URL launch error: $e");
  //     return false;
  //   }
  // }
  //
  // static bool _isLoaderShowing = false;
  //
  // static void showLoader() {
  //   if (_isLoaderShowing) return;
  //
  //   final context = Global.navigatorKey.currentContext;
  //   if (context == null) return;
  //
  //   _isLoaderShowing = true;
  //
  //   showDialog(context: context, barrierDismissible: false, barrierColor: Colors.black26, builder: (_) => const AppLoadingWidget());
  // }
  //
  // static void hideLoader() {
  //   if (!_isLoaderShowing) return;
  //
  //   final context = Global.navigatorKey.currentContext;
  //   if (context == null) return;
  //
  //   Navigator.of(context, rootNavigator: true).pop();
  //   _isLoaderShowing = false;
  // }
  //
  // static String checkIfNullOrEmpty({required String? originalString, required String defaultValue}) {
  //   if (originalString == null || originalString.isEmpty) {
  //     return defaultValue;
  //   } else {
  //     return originalString;
  //   }
  // }

  static AppImageSource detectImageSource(String url) {
    if (url.isEmpty) {
      return AppImageSource.network;
    }

    final lowerUrl = url.toLowerCase().trim();

    /// ---------------- BASE64 ----------------
    if (lowerUrl.startsWith('data:image')) {
      return AppImageSource.base64;
    }

    /// raw base64 without prefix
    if (!lowerUrl.contains('/') &&
        !lowerUrl.contains('.') &&
        lowerUrl.length > 100) {
      return AppImageSource.base64;
    }

    /// ---------------- FILE ----------------
    if (lowerUrl.startsWith('file://') ||
        lowerUrl.startsWith('/storage/') ||
        lowerUrl.startsWith('/data/') ||
        lowerUrl.startsWith('/var/') ||
        lowerUrl.startsWith('/private/')) {
      return AppImageSource.file;
    }

    /// ---------------- ASSET ----------------
    if (lowerUrl.startsWith('assets/')) {
      return AppImageSource.asset;
    }

    /// ---------------- SVG ----------------
    if (lowerUrl.endsWith('.svg') || lowerUrl.contains('.svg?')) {
      return AppImageSource.svg;
    }

    /// ---------------- NETWORK (DEFAULT) ----------------
    return AppImageSource.network;
  }

  static bool isGif(String? url) {
    if (url == null) return false;
    return url.toLowerCase().endsWith('.gif');
  }
}
