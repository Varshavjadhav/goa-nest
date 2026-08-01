// ignore_for_file: constant_identifier_names

enum DesignMediaType { image, video }

enum DesignSourceType { canvas, url }

enum AllBannerFlowType { outerlink, event, payment_url }

enum Status { initial, loading, error, completed }

enum Language { english, marathi, hindi }

enum EventType { political, greetings, business }

enum ButtonStyleType { elevated, outlined, text }

enum SplashStatus { initial, loading, ready, forceUpdate, error }

enum ExtendedButtonType { iconOnly, iconWithText }

enum AppDialogType { info, alert, confirmation, success, error }

enum ErrorActionType { retry, logout, none }

enum SocialPlatform { facebook, instagram, youtube, twitter }

enum DesignTab { image, video }

enum UrlType { app, web, tel, email, whatsapp }

enum AppThemeMode { system, light, dark }

enum SubscriptionStatus { plans, pending, processing, success, failed, active }

enum AppEnv { development, production }

enum SplashRoute { none, login, home }

enum RequestStatus { pending, inProgress, completed, rejected }

enum WalletAmountType { referralReward, withdraw, redeem, dailyAppOpenReward, designPurchase, walletRecharge, manualCredit }

enum GatewayType { phonepe }

enum AppErrorCategory { network, auth, validation, server, unknown, firebaseTokenError }

enum ProfileType { personal, political, business }

enum ToolType { image, name, designation, tagLine, whatsApp, email, leaderImages, partyName, partyLogo, phone, address, watermark, social }

enum AppImageSource { network, asset, file, base64, svg }

enum FrameType { personal, political, business, custom }

enum SubscriptionScreenType { political, business, upgrade }

enum PhonePeSubscriptionState {
  activationInProgress,
  active,
  expired,
  cancelInProgress,
  cancelled,
  revokeInProgress,
  revoked,
  pauseInProgress,
  paused,
  unpauseInProgress,
  pending,
  failed,
  completed,
  unknown,
}

PhonePeSubscriptionState parseSubscriptionState(String? state) {
  switch (state) {
    case 'ACTIVATION_IN_PROGRESS':
      return PhonePeSubscriptionState.activationInProgress;
    case 'ACTIVE':
      return PhonePeSubscriptionState.active;
    case 'EXPIRED':
      return PhonePeSubscriptionState.expired;
    case 'CANCEL_IN_PROGRESS':
      return PhonePeSubscriptionState.cancelInProgress;
    case 'CANCELLED':
      return PhonePeSubscriptionState.cancelled;
    case 'REVOKE_IN_PROGRESS':
      return PhonePeSubscriptionState.revokeInProgress;
    case 'REVOKED':
      return PhonePeSubscriptionState.revoked;
    case 'PAUSE_IN_PROGRESS':
      return PhonePeSubscriptionState.pauseInProgress;
    case 'PAUSED':
      return PhonePeSubscriptionState.paused;
    case 'UNPAUSE_IN_PROGRESS':
      return PhonePeSubscriptionState.unpauseInProgress;
    case 'PENDING':
      return PhonePeSubscriptionState.pending;
    case 'FAILED':
      return PhonePeSubscriptionState.failed;
    case 'COMPLETED':
      return PhonePeSubscriptionState.completed;
    default:
      return PhonePeSubscriptionState.unknown;
  }
}
