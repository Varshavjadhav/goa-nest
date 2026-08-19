import '../../core.dart';
import '../../resources/constants/app_colors.dart';

extension ThemeContext on BuildContext {
  ProvideThemeExtension get themeExt => Theme.of(this).extension<ProvideThemeExtension>()!;
}

@immutable
class ProvideThemeExtension extends ThemeExtension<ProvideThemeExtension> {
  final Brightness brightness;
  /* -------------------------------------------------------------------------- */
  /*                               Brand / Accent                               */
  /* -------------------------------------------------------------------------- */

  final Color brandPrimary;
  final Color brandSecondary;

  /* -------------------------------------------------------------------------- */
  /*                                  Surfaces                                  */
  /* -------------------------------------------------------------------------- */

  final Color background;
  final Color surface;
  final Color card;
  final Color homeScaffold;
  final Color homeTextFieldBg;
  final Color containerBg;
  final Color containerBorder;
  final Color profilesContainerColor;
  final Color frameBottomBarColor;
  final Color manualPaymentContainerColor;
  final Color manualPaymentCopyContainerColor;
  final Color payWithContainerColor;
  final Color promoContainerColorDark;
  final Color walletContainerBgColor;

  /* -------------------------------------------------------------------------- */
  /*                                    Text                                    */
  /* -------------------------------------------------------------------------- */

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textQuaternary;
  final Color textFieldBackground;

  /* -------------------------------------------------------------------------- */
  /*                                   Inputs                                   */
  /* -------------------------------------------------------------------------- */

  final Color inputFill;
  final Color inputBorder;
  final Color divider;
  final Color mainNav;

  /* -------------------------------------------------------------------------- */
  /*                                   Status                                   */
  /* -------------------------------------------------------------------------- */

  final Color success;
  final Color warning;
  final Color info;
  final Color disabled;

  /* -------------------------------------------------------------------------- */
  /*                                   Shimmer                                   */
  /* -------------------------------------------------------------------------- */

  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color shimmerBlock;

  /* -------------------------------------------------------------------------- */
  /*                             Home Screen Palette                             */
  /* -------------------------------------------------------------------------- */

  final Color homeBackground;
  final Color homeTitleText;
  final Color homeSubtitleText;
  final Color homeIcon;
  final Color homeDivider;

  final Color searchFieldBorder;
  final Color searchFieldHint;
  final Color searchFieldIcon;

  final Color tabSelectedBackground;
  final Color tabSelectedForeground;
  final Color tabBackground;
  final Color tabBorder;
  final Color tabForeground;

  final Color guestFavBadgeBackground;
  final Color guestFavBadgeText;

  const ProvideThemeExtension({
    required this.brightness,
    required this.brandPrimary,
    required this.brandSecondary,
    required this.background,
    required this.homeScaffold,
    required this.homeTextFieldBg,
    required this.mainNav,
    required this.containerBg,
    required this.containerBorder,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textQuaternary,
    required this.textFieldBackground,
    required this.inputFill,
    required this.inputBorder,
    required this.divider,
    required this.success,
    required this.warning,
    required this.info,
    required this.disabled,
    required this.profilesContainerColor,
    required this.frameBottomBarColor,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.shimmerBlock,
    required this.homeBackground,
    required this.homeTitleText,
    required this.homeSubtitleText,
    required this.homeIcon,
    required this.homeDivider,
    required this.searchFieldBorder,
    required this.searchFieldHint,
    required this.searchFieldIcon,
    required this.tabSelectedBackground,
    required this.tabSelectedForeground,
    required this.tabBackground,
    required this.tabBorder,
    required this.tabForeground,
    required this.guestFavBadgeBackground,
    required this.guestFavBadgeText,
    required this.manualPaymentContainerColor,
    required this.manualPaymentCopyContainerColor,
    required this.payWithContainerColor,
    required this.promoContainerColorDark,
    required this.walletContainerBgColor,
  });

  @override
  ProvideThemeExtension copyWith({
    Brightness? brightness,
    Color? brandPrimary,
    Color? brandSecondary,
    Color? background,
    Color? homeScaffold,
    Color? homeTextFieldBg,
    Color? mainNav,
    Color? containerBg,
    Color? containerBorder,
    Color? surface,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textQuaternary,
    Color? textFieldBackground,
    Color? inputFill,
    Color? inputBorder,
    Color? divider,
    Color? success,
    Color? warning,
    Color? info,
    Color? disabled,
    Color? profilesContainerColor,
    Color? frameBottomBarColor,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? shimmerBlock,
    Color? homeBackground,
    Color? homeTitleText,
    Color? homeSubtitleText,
    Color? homeIcon,
    Color? homeDivider,
    Color? searchFieldBorder,
    Color? searchFieldHint,
    Color? searchFieldIcon,
    Color? tabSelectedBackground,
    Color? tabSelectedForeground,
    Color? tabBackground,
    Color? tabBorder,
    Color? tabForeground,
    Color? guestFavBadgeBackground,
    Color? guestFavBadgeText,
    Color? manualPaymentContainerColor,
    Color? manualPaymentCopyContainerColor,
    Color? payWithContainerColor,
    Color? promoContainerColorDark,
    Color? walletContainerBgColor,
  }) {
    return ProvideThemeExtension(
      brightness: brightness ?? this.brightness,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      background: background ?? this.background,
      mainNav: mainNav ?? this.mainNav,
      homeScaffold: homeScaffold ?? this.homeScaffold,
      homeTextFieldBg: homeTextFieldBg ?? this.homeTextFieldBg,
      containerBg: containerBg ?? this.containerBg,
      containerBorder: containerBorder ?? this.containerBorder,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textQuaternary: textQuaternary ?? this.textQuaternary,
      textFieldBackground: textFieldBackground ?? this.textFieldBackground,
      inputFill: inputFill ?? this.inputFill,
      inputBorder: inputBorder ?? this.inputBorder,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      disabled: disabled ?? this.disabled,
      profilesContainerColor: profilesContainerColor ?? this.profilesContainerColor,
      frameBottomBarColor: frameBottomBarColor ?? this.frameBottomBarColor,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      shimmerBlock: shimmerBlock ?? this.shimmerBlock,
      homeBackground: homeBackground ?? this.homeBackground,
      homeTitleText: homeTitleText ?? this.homeTitleText,
      homeSubtitleText: homeSubtitleText ?? this.homeSubtitleText,
      homeIcon: homeIcon ?? this.homeIcon,
      homeDivider: homeDivider ?? this.homeDivider,
      searchFieldBorder: searchFieldBorder ?? this.searchFieldBorder,
      searchFieldHint: searchFieldHint ?? this.searchFieldHint,
      searchFieldIcon: searchFieldIcon ?? this.searchFieldIcon,
      tabSelectedBackground: tabSelectedBackground ?? this.tabSelectedBackground,
      tabSelectedForeground: tabSelectedForeground ?? this.tabSelectedForeground,
      tabBackground: tabBackground ?? this.tabBackground,
      tabBorder: tabBorder ?? this.tabBorder,
      tabForeground: tabForeground ?? this.tabForeground,
      guestFavBadgeBackground: guestFavBadgeBackground ?? this.guestFavBadgeBackground,
      guestFavBadgeText: guestFavBadgeText ?? this.guestFavBadgeText,
      manualPaymentContainerColor: manualPaymentContainerColor ?? this.manualPaymentContainerColor,
      manualPaymentCopyContainerColor: manualPaymentCopyContainerColor ?? this.manualPaymentCopyContainerColor,
      payWithContainerColor: payWithContainerColor ?? this.payWithContainerColor,
      promoContainerColorDark: promoContainerColorDark ?? this.promoContainerColorDark,
      walletContainerBgColor: walletContainerBgColor ?? this.walletContainerBgColor,
    );
  }

  @override
  ProvideThemeExtension lerp(ThemeExtension<ProvideThemeExtension>? other, double t) {
    if (other is! ProvideThemeExtension) return this;

    return ProvideThemeExtension(
      brightness: brightness,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      homeScaffold: Color.lerp(homeScaffold, other.homeScaffold, t)!,
      mainNav: Color.lerp(mainNav, other.mainNav, t)!,
      homeTextFieldBg: Color.lerp(homeTextFieldBg, other.homeTextFieldBg, t)!,
      containerBg: Color.lerp(containerBg, other.containerBg, t)!,
      containerBorder: Color.lerp(containerBorder, other.containerBorder, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textQuaternary: Color.lerp(textQuaternary, other.textQuaternary, t)!,
      textFieldBackground: Color.lerp(textFieldBackground, other.textFieldBackground, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      profilesContainerColor: Color.lerp(profilesContainerColor, other.profilesContainerColor, t)!,
      frameBottomBarColor: Color.lerp(frameBottomBarColor, other.frameBottomBarColor, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      shimmerBlock: Color.lerp(shimmerBlock, other.shimmerBlock, t)!,
      homeBackground: Color.lerp(homeBackground, other.homeBackground, t)!,
      homeTitleText: Color.lerp(homeTitleText, other.homeTitleText, t)!,
      homeSubtitleText: Color.lerp(homeSubtitleText, other.homeSubtitleText, t)!,
      homeIcon: Color.lerp(homeIcon, other.homeIcon, t)!,
      homeDivider: Color.lerp(homeDivider, other.homeDivider, t)!,
      searchFieldBorder: Color.lerp(searchFieldBorder, other.searchFieldBorder, t)!,
      searchFieldHint: Color.lerp(searchFieldHint, other.searchFieldHint, t)!,
      searchFieldIcon: Color.lerp(searchFieldIcon, other.searchFieldIcon, t)!,
      tabSelectedBackground: Color.lerp(tabSelectedBackground, other.tabSelectedBackground, t)!,
      tabSelectedForeground: Color.lerp(tabSelectedForeground, other.tabSelectedForeground, t)!,
      tabBackground: Color.lerp(tabBackground, other.tabBackground, t)!,
      tabBorder: Color.lerp(tabBorder, other.tabBorder, t)!,
      tabForeground: Color.lerp(tabForeground, other.tabForeground, t)!,
      guestFavBadgeBackground: Color.lerp(guestFavBadgeBackground, other.guestFavBadgeBackground, t)!,
      guestFavBadgeText: Color.lerp(guestFavBadgeText, other.guestFavBadgeText, t)!,
      manualPaymentContainerColor: Color.lerp(manualPaymentContainerColor, other.manualPaymentContainerColor, t)!,
      manualPaymentCopyContainerColor: Color.lerp(manualPaymentCopyContainerColor, other.manualPaymentCopyContainerColor, t)!,
      payWithContainerColor: Color.lerp(payWithContainerColor, other.payWithContainerColor, t)!,
      promoContainerColorDark: Color.lerp(promoContainerColorDark, other.promoContainerColorDark, t)!,
      walletContainerBgColor: Color.lerp(walletContainerBgColor, other.walletContainerBgColor, t)!,
    );
  }

  bool get isDark => brightness == Brightness.dark;

  /* -------------------------------------------------------------------------- */
  /*                                   Presets                                  */
  /* -------------------------------------------------------------------------- */

  static final light = ProvideThemeExtension(
    brightness: Brightness.light,
    brandPrimary: AppColor.primary,
    brandSecondary: AppColor.secondary,
    mainNav: AppColor.cardGrey,
    // background: AppColor.greyExtraLight,
    background: AppColor.white,
    homeScaffold: AppColor.homeBackground,
    containerBg: AppColor.cardGrey,
    containerBorder: AppColor.borderGrey,
    homeTextFieldBg: AppColor.white,
    surface: AppColor.white,
    card: AppColor.greySoft,

    textPrimary: AppColor.textPrimary,
    textSecondary: AppColor.textSecondary,
    textTertiary: AppColor.textTertiary,
    textQuaternary: AppColor.textQuaternary,
    textFieldBackground: AppColor.white,

    inputFill: AppColor.white,
    inputBorder: AppColor.primaryLight,
    divider: AppColor.greyLight,

    success: AppColor.success,
    warning: AppColor.warning,
    info: AppColor.info,
    disabled: AppColor.grey,
    profilesContainerColor: AppColor.profilesContainerBgColor,
    frameBottomBarColor: AppColor.white,

    shimmerBase: AppColor.greySoft,
    shimmerHighlight: AppColor.white,
    shimmerBlock: AppColor.white,
    homeBackground: AppColor.homeScreenBackground,
    homeTitleText: AppColor.homeTitleText,
    homeSubtitleText: AppColor.homeSubtitleText,
    homeIcon: AppColor.homeIcon,
    homeDivider: AppColor.homeDivider,
    searchFieldBorder: AppColor.searchFieldBorder,
    searchFieldHint: AppColor.searchFieldHint,
    searchFieldIcon: AppColor.searchFieldIcon,
    tabSelectedBackground: AppColor.tabSelectedBackground,
    tabSelectedForeground: AppColor.tabSelectedForeground,
    tabBackground: AppColor.tabBackground,
    tabBorder: AppColor.tabBorder,
    tabForeground: AppColor.tabForeground,
    guestFavBadgeBackground: AppColor.guestFavBadgeBackground,
    guestFavBadgeText: AppColor.guestFavBadgeText,
    manualPaymentContainerColor: AppColor.white,
    manualPaymentCopyContainerColor: AppColor.white,
    payWithContainerColor: const Color(0xFFFDF9F6),
    promoContainerColorDark: AppColor.promoContainerColor,
    walletContainerBgColor: AppColor.cardBackground,
  );

  static final dark = ProvideThemeExtension(
    brightness: Brightness.dark,
    brandPrimary: AppColor.primary,
    brandSecondary: AppColor.secondary,
    mainNav: AppColor.mainNavbar,

    background: AppColor.charcoal,
    homeScaffold: AppColor.black,
    homeTextFieldBg: AppColor.textFieldBgColor,
    containerBg: AppColor.containerBgColor,
    containerBorder: AppColor.transparent,
    surface: AppColor.black,
    card: AppColor.greyDark,

    textPrimary: AppColor.white,
    textSecondary: AppColor.textQuaternary,
    textTertiary: AppColor.grey,
    textQuaternary: AppColor.greyDark,
    textFieldBackground: AppColor.textFieldBgColor,

    inputFill: AppColor.greyDark,
    inputBorder: AppColor.primaryDark,
    divider: AppColor.greyDark,

    success: AppColor.success,
    warning: AppColor.warning,
    info: AppColor.info,
    disabled: AppColor.greyDark,
    profilesContainerColor: AppColor.textPrimary,
    frameBottomBarColor: AppColor.frameBottomBarBgColor,

    shimmerBase: AppColor.greyDark,
    shimmerHighlight: AppColor.black,
    shimmerBlock: AppColor.black,
    homeBackground: AppColor.black,
    homeTitleText: AppColor.white,
    homeSubtitleText: AppColor.grey,
    homeIcon: AppColor.white,
    homeDivider: AppColor.greyExtraDark,
    searchFieldBorder: AppColor.greyExtraDark,
    searchFieldHint: AppColor.grey,
    searchFieldIcon: AppColor.white,
    tabSelectedBackground: AppColor.greyExtraDark,
    tabSelectedForeground: AppColor.white,
    tabBackground: AppColor.textFieldBgColor,
    tabBorder: AppColor.greyExtraDark,
    tabForeground: AppColor.white,
    guestFavBadgeBackground: AppColor.greyExtraDark,
    guestFavBadgeText: AppColor.white,
    manualPaymentContainerColor: AppColor.manualPaymentContainer,
    manualPaymentCopyContainerColor: AppColor.manualPaymentCopyContainer,
    payWithContainerColor: AppColor.payWithContainer,
    promoContainerColorDark: AppColor.transparent,
    walletContainerBgColor: AppColor.containerBgColor,
  );
}
