import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  /* -------------------------------------------------------------------------- */
  /*                                Brand Colors                                */
  /* -------------------------------------------------------------------------- */

  static const Color primary = Color(0xFFF27C35);
  static const Color secondary = Color(0xFFF4A778);
  static const Color tertiary = Color(0xFFFFEDE2);

  static const Color primaryLight = Color(0xFFFFE1CF);
  static const Color primaryDark = Color(0xFFD9651F);
  static const Color primaryDisabled = Color(0xFFF8B68E);

  /* -------------------------------------------------------------------------- */
  /*                              Primary Swatch                                */
  /* -------------------------------------------------------------------------- */

  static const MaterialColor primarySwatch = MaterialColor(0xFFF27C35, <int, Color>{
    50: Color(0xFFFFF3EC),
    100: Color(0xFFFFE1CF),
    200: Color(0xFFFCC6A5),
    300: Color(0xFFF9AB7B),
    400: Color(0xFFF59255),
    500: Color(0xFFF27C35), // primary
    600: Color(0xFFE36F2F),
    700: Color(0xFFD9651F),
    800: Color(0xFFBF5718),
    900: Color(0xFF9E4511),
  });

  /* -------------------------------------------------------------------------- */
  /*                                Text Colors                                 */
  /* -------------------------------------------------------------------------- */

  static const Color textPrimary = Color(0xFF262626);
  static const Color textSecondary = Color(0xFF595959);
  static const Color textTertiary = Color(0xFF808D9E);
  static const Color textQuaternary = Color(0xFF8E8888);

  /* -------------------------------------------------------------------------- */
  /*                           Background / Containers                           */
  /* -------------------------------------------------------------------------- */

  static const Color scaffoldBackground = Color(0xFFFFF9F6);
  static const Color containerBackground = Color(0xFFFFEDE2);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE6E6E6);
  static const Color homeBackground = Color(0xFFF0F9FF);
  static const Color mainNavbar = Color(0xFF0A1227);
  static const Color textFieldBgColor = Color(0xFF3A424A);
  static const Color containerBgColor = Color(0xFF262626);
  static const Color profilesContainerBgColor = Color(0xFFE8ECF4);
  static const Color frameBottomBarBgColor = Color(0xFF262626);
  static const Color manualPaymentContainer = Color(0xFF262626);
  static const Color manualPaymentCopyContainer = Colors.black;
  static final Color payWithContainer = Color(0xFFE8ECF4).withValues(alpha: 0.2);
  static final Color promoContainerColor = Color(0xFFFDF8EF);

  /* -------------------------------------------------------------------------- */
  /*                                  Greys                                     */
  /* -------------------------------------------------------------------------- */

  static const Color greyLight = Color(0xFFF2F2F2);
  static const Color grey = Color(0xFFBDBDBD);
  static const Color greyDark = Color(0xFF6E6E6E);
  static const Color charcoal = Color(0xFF1E1E1E);
  static const Color planGrey = Color(0xFFF4F4F4);

  // Extra greys (Light → Dark)
  static const Color greyUltraLight = Color(0xFFFAFAFA);
  static const Color greyExtraLight = Color(0xFFF5F5F5);
  static const Color greySoft = Color(0xFFE5E7EB);
  static const Color greyMediumLight = Color(0xFFCCCCCC);
  static const Color greyMedium = Color(0xFF9E9E9E);
  static const Color greyMediumDark = Color(0xFF757575);
  static const Color greyStrong = Color(0xFF545860);
  static const Color greyExtraDark = Color(0xFF424242);
  static const Color greyUltraDark = Color(0xFF2C2C2C);

  // Utility greys
  static const Color dividerGrey = Color(0xFFDDDDDD);
  static const Color cardGrey = Color(0xFFF3F6F9);
  static const Color borderGrey = Color(0xFFE8ECF4);
  static const Color disabledGrey = Color(0xFFAAAAAA);
  static const Color hintGrey = Color(0xFF8A8A8A);

  /* -------------------------------------------------------------------------- */
  /*                               Status Colors                                 */
  /* -------------------------------------------------------------------------- */

  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF0288D1);
  static const Color completed = Color(0xFF59AB6C);
  static const Color inProgress = Color(0xFF245DD0);
  static const Color pending = Color(0xFFDF8728);

  // ---------- Primary Colors ----------
  static const Color red = Color(0xFFFF0000);
  static const Color blue = Color(0xFF0000FF);
  static const Color yellow = Color(0xFFFFFF00);

  // ---------- Secondary Colors ----------
  static const Color green = Color(0xFF00FF00);
  static const Color orange = Color(0xFFFFA500);
  static const Color purple = Color(0xFF800080);

  // ---------- Neutral Colors ----------
  static const Color gray = Color(0xFF808080);
  static const Color lightGray = Color(0xFFD3D3D3);
  static const Color darkGray = Color(0xFF404040);

  // ---------- Common UI Colors ----------
  static const Color pink = Color(0xFFFFC0CB);
  static const Color brown = Color(0xFF8B4513);
  static const Color cyan = Color(0xFF00FFFF);
  static const Color teal = Color(0xFF008080);
  static const Color lime = Color(0xFF32CD32);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color amber = Color(0xFFFFC107);
  static const Color navy = Color(0xFF000080);
  static const Color olive = Color(0xFF808000);

  // ---------- Background / Surface ----------
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFBDBDBD);

  /* -------------------------------------------------------------------------- */
  /*                                  Utility                                   */
  /* -------------------------------------------------------------------------- */
  static const Color goldPlan = Color(0xFFFFB800);
  static const Color silverPlan = Color(0xFF049203);
  static const Color platinumPlan = Color(0xFF0064AB);
  static const Color planYellow = Color(0xFFFEE824);
  static const Color planBorder = Color(0xFF00BA28);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0xFF2B2626);

  static const Color facebookBlue = Color(0xFF1877F2);
  static const LinearGradient instagramGradient = LinearGradient(
    colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF), Color(0xFF515BD4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color instagramPurple = Color(0xFFDD2A7B);

  static const Color forceTitleColor = Color(0xFF371B34);

  static const List<Color> referralHistoryColors = [
    Color(0xFFB9E5F5),
    Color(0xFFB9C1F5),
    Color(0xFFCEF5B9),
    Color(0xFFF5B9D3),
    Color(0xFFB9F5E2),
    Color(0xFFB9D8F5),
    Color(0xFFF5B9B9),
    Color(0xFFF5F0B9),
    Color(0xFFB9F5C9),
    Color(0xFFD4B9F5),
    Color(0xFFF5DEB9),
  ];
}
