String get storageUrl => "https://com.app/storage/app/public/";

class ApiUrl {
  // static const String version = "v2";
  static const String version = "v3";

  static String get baseUrl => "https://com.app/api/$version/";

  //Authentication
  static const String appVersion = 'app-version';
  static const String appSettings = 'app-settings';
  static const String login = 'auth/login';
  static const String resendOtp = 'auth/resend-otp';
  static const String validatePincode = 'profile/validate-pincode';
  static const String savePersonalDetails = 'profile/save-personal-details';
  static const String logout = 'auth/logout';
  static const String homeScreen = 'home-screen';
  static const String greetings = 'get-all-greeting';
  static const String politicalHome = 'political-home';
  static const String businessHome = 'business-home';
  static const String profile = 'profile';
  static const String profileUpdate = 'profile/update';
  static const String personalProfileUpdate = 'profile/update-personal-profile';
  static const String businessProfileUpdate = 'profile/update-business-profile';
  static const String politicalProfileUpdate = 'profile/update-political-profile';
  static const String addFestivalRequest = 'add-festival-request';
  static const String autopayPackages = 'autopay/packages';
  static const String getManualPaymentDetail = 'autopay/get-manual-payment-detail';
  static const String autopaySetupSubscription = 'autopay/setup-subscription';
  static const String autopaySetPaymentUrl = 'autopay/set-payment-url';
  static const String autopaySubscriptionStatus = 'autopay/subscription/status';
  static const String autopaySubscriptionCancel = 'autopay/subscription/cancel';
  static const String autopaySubscriptionRetry = 'autopay/redeem';
  static const String autopayTransactionHistory = 'autopay/transaction/history';
  static const String autopayOrderStatus = 'autopay/order/status';
  static const String getAllParties = 'get-all-parties';
  static const String getAllBusiness = 'get-all-business';
  static const String getAllUsersBusiness = 'get-all-users-business';
  static const String getAllUserPolitical = 'get-all-users-political';
  static const String getAllFestivalCategory = 'get-all-festival-category';
  static const String addPromoteRequirement = 'add-promote-requirment';
  static const String getAllFestivalRequest = 'get-all-festival-request';
  static const String getAllPromoteRequirement = 'get-all-promote-requriment';
  static const String deleteAccount = 'profile/delete';
  static const String designDetails = "design-detail";
  static const String designReport = 'design-report';
  static const String getReportReason = 'get-report-reason';
  static const String designDownload = 'design-download';
  static const String getReferralHistory = 'get-referral-history';
  static const String getReferredHistory = 'get-referred-history';
  static const String getWalletHistory = 'get-wallet-history';
  static const String getCustomFrame = 'get-custom-frames';
  static const String updateLanguage = 'profile/update-language';
  static const String searchDesign = 'search-design';
  static const String getAllStickerCategory = 'get-all-sticker-category';
  static const String applyPromoCode = 'autopay/apply-promo-code';
  static const String walletOffers = 'payment/wallet-offers';
  static const String initiateWalletRecharge = 'payment/initiate';
  static const String verifyWalletRecharge = 'payment/verify';
  static const String addonInfoApi = 'payment/get-addon-info';
  static const String getBusinessPoliticalCategories = 'get-categories';
  static const String updateFcmToken = 'update-fcm-token';
  static const String tokenRefresh = 'auth/refresh-token';
}
