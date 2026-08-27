import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  /* -------------------------------------------------------------------------- */
  /*                           Primary (Airbnb exact)                            */
  /* -------------------------------------------------------------------------- */

  static const Color primary = Color(0xFFFF385C);
  static const Color secondary = Color(0xFFE9788E);
  static const Color tertiary = Color(0xFFFFECEF);

  static const Color primaryLight = Color(0xFFFFCCD5);
  static const Color primaryDark = Color(0xFFB51F3B);

/* -------------------------------------------------------------------------- */
/*                              Primary Swatch                                */
/* -------------------------------------------------------------------------- */

  static const MaterialColor primarySwatch =
  MaterialColor(0xFFFF385C, <int, Color>{
    50: Color(0xFFFFF0F2),
    100: Color(0xFFFFD9DF),
    200: Color(0xFFFFB8C3),
    300: Color(0xFFF58A9D),
    400: Color(0xFFE95B74),
    500: Color(0xFFFF385C), // primary
    600: Color(0xFFCC2947),
    700: Color(0xFFB51F3B),
    800: Color(0xFF96182F),
    900: Color(0xFF741020),
  });

  /* -------------------------------------------------------------------------- */
  /*                                Text Colors (Airbnb exact)                   */
  /* -------------------------------------------------------------------------- */

  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF717171);
  static const Color textTertiary = Color(0xFF808D9E);
  static const Color textQuaternary = Color(0xFF8E8888);

  /* -------------------------------------------------------------------------- */
  /*                           Background / Containers                           */
  /* -------------------------------------------------------------------------- */

  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardGrey = Color(0xFFF7F7F7);
  static const Color divider = Color(0xFFDDDDDD);
  static const Color homeBackground = Color(0xFFFFFFFF);
  static const Color mainNavbar = Color(0xFF222222);
  static const Color textFieldBgColor = Color(0xFF3A424A);
  static const Color containerBgColor = Color(0xFF222222);
  static const Color profilesContainerBgColor = Color(0xFFEBEBEB);
  static const Color frameBottomBarBgColor = Color(0xFF222222);
  static const Color manualPaymentContainer = Color(0xFF222222);
  static const Color manualPaymentCopyContainer = Colors.black;
  static final Color payWithContainer = Color(0xFFEBEBEB).withValues(alpha: 0.2);
  static final Color promoContainerColor = Color(0xFFFDF8EF);

  /* -------------------------------------------------------------------------- */
  /*                                  Greys (Airbnb exact)                       */
  /* -------------------------------------------------------------------------- */

  static const Color greyLight = Color(0xFFF7F7F7);
  static const Color grey = Color(0xFFB0B0B0);
  static const Color greyDark = Color(0xFF717171);
  static const Color charcoal = Color(0xFF222222);

  // Extra greys (Light → Dark)
  static const Color greyExtraLight = Color(0xFFF7F7F7);
  static const Color greySoft = Color(0xFFEBEBEB);
  static const Color greyMedium = Color(0xFFB0B0B0);
  static const Color greyExtraDark = Color(0xFF484848);
  static const Color greyUltraDark = Color(0xFF222222);

  // Utility greys
  static const Color borderGrey = Color(0xFFDDDDDD);
  static const Color hintGrey = Color(0xFFB0B0B0);

  /* -------------------------------------------------------------------------- */
  /*                               Status Colors                                 */
  /* -------------------------------------------------------------------------- */

  static const Color success = Color(0xFF008A05);
  static const Color error = Color(0xFFC13515);
  static const Color warning = Color(0xFFFFB800);
  static const Color info = Color(0xFF0288D1);

  /* -------------------------------------------------------------------------- */
  /*                                  Utility                                   */
  /* -------------------------------------------------------------------------- */
  static const Color goldPlan = Color(0xFFFFB800);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color surface = Color(0xFFFFFFFF);

  static const Color shadow = Color(0x1A000000);

  /* -------------------------------------------------------------------------- */
  /*                     Home Screen (Airbnb exact palette)                      */
  /* -------------------------------------------------------------------------- */

  static const Color homeScreenBackground = Color(0xFFFFFFFF);
  static const Color homeTitleText = Color(0xFF222222);
  static const Color homeSubtitleText = Color(0xFF717171);
  static const Color homeIcon = Color(0xFF222222);
  static const Color homeDivider = Color(0xFFDDDDDD);

  static const Color searchFieldBorder = Color(0xFFDDDDDD);
  static const Color searchFieldHint = Color(0xFF717171);
  static const Color searchFieldIcon = Color(0xFF222222);

  static const Color tabSelectedBackground = Color(0xFF222222);
  static const Color tabSelectedForeground = Color(0xFFFFFFFF);
  static const Color tabBackground = Color(0xFFFFFFFF);
  static const Color tabBorder = Color(0xFFDDDDDD);
  static const Color tabForeground = Color(0xFF222222);

  static const Color guestFavBadgeBackground = Color(0xFFFFFFFF);
  static const Color guestFavBadgeText = Color(0xFF222222);

  static const Color airbnbPink = Color(0xFFFF385C);
}
