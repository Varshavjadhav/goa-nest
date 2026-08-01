import 'dart:io';

import 'package:flutter/foundation.dart';

class Constants {
  Constants._();

  static const enableSafeDeviceSecurityCheck = kReleaseMode;
  static const bool debugMode = true;
  static const String appName = 'GoaNest';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.goanest.app';
  static const String appStoreUrl = 'https://apps.apple.com/app/goanest';
  static const String websiteUrl = 'https://goanest.com';
  static const String dotEnv = '.env';
  static const baseHeader = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  static const String otp = "OTP";
  static const int customFrameTypeIndex = 3;
  static String get shareContent {
    final link = Platform.isIOS ? appStoreUrl : playStoreUrl;

    return "Explore premium coastal stays with GoaNest.\n\n"
        "Download here:\n$link\n";
  }

  static const List<String> stickerImageUrls = [
    'https://pngimg.com/uploads/star/star_PNG1597.png',
    'https://pngimg.com/uploads/fire/fire_PNG6021.png',
    'https://pngimg.com/uploads/moon/moon_PNG11.png',
    'https://pngimg.com/uploads/star/star_PNG1598.png',
    'https://pngimg.com/uploads/star/star_PNG1599.png',
    'https://pngimg.com/uploads/fire/fire_PNG6022.png',
  ];

  static final bool disableSubscriptionFlow = Platform.isIOS;

  static final int personalFrameCount = 20;
  static final int politicalFrameCount = 22;
  static final int businessFrameCount = 15;
  static final int customFrameCount = 2;
}
