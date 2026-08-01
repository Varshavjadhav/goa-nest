import '../../../app/router/route_name.dart';
import '../../../core.dart';
import '../../../gen/assets/assets.gen.dart';
import '../../../resources/constants/flags.dart';
import '../../../utilities/enums/enums_types.dart';
import '../../../utilities/extensions/extensions.dart';
import '../../../utilities/extensions/language_extensions.dart';
import '../../../utilities/global.dart';
import '../../../utilities/ui_config/app_size_config.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/app_button_widget.dart';
import '../../../widgets/app_image_widget.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/app_text_widget.dart';
import '../../di/injector.dart';
import '../../services/local_secure_storage/secure_storage_service.dart';
import 'app_exception.dart';

class AppErrorWidget extends StatefulWidget {
  final AppException exception;
  final SecureStorageService secureStorageService;

  AppErrorWidget({super.key, required this.exception, SecureStorageService? secureStorageService})
    : secureStorageService = secureStorageService ?? sl<SecureStorageService>();

  @override
  State<AppErrorWidget> createState() => _AppErrorWidgetState();
}

class _AppErrorWidgetState extends State<AppErrorWidget> {
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    if (widget.exception.code == 401) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleUnauthorized();
      });
    }
  }

  Future<void> _handleUnauthorized() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    final isEncryptionEnabled = await widget.secureStorageService.read<bool>(Flags.encryptionEnabled);
    await widget.secureStorageService.deleteAll();
    await widget.secureStorageService.write(Flags.encryptionEnabled, isEncryptionEnabled ?? false);

    final context = Global.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      context.go(RouteName.loginView);
    }
  }

  Future<void> _handleRedirect({required String url}) async {
    await Utils.openNumpad(url);
  }

  @override
  Widget build(BuildContext context) {
    final config = getErrorConfig(context, widget.exception);
    if (widget.exception.code == 499) {
      return _encryptionErrorBody(context, config);
    } else {
      return _basicErrorBody(context, config);
    }
  }

  Widget _encryptionErrorBody(BuildContext context, AppErrorConfig config) {
    return AppScaffold(
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          mainAxisSize: .max,
          children: [
            (widget.exception.error?.image != null && widget.exception.error!.image!.isNotEmpty)
                ? AppImageWidget(imageUrl: widget.exception.error!.image!, height: 190, fit: BoxFit.cover)
                : Image.asset(config.imageAsset, height: 150.h, fit: BoxFit.cover),
            Gap(16.h),
            AppTextWidget(
              text: widget.exception.error?.title ?? config.title,
              fontWeight: FontWeight.w700,
              fontSize: 22,
              textAlign: TextAlign.center,
            ),
            Gap(18.h),
            AppTextWidget(
              text: widget.exception.error?.subTitle ?? config.description,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),

            /*  Gap(18.h),
            GestureDetector(
              onTap: () => context.go(RouteName.splashView),
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: context.themeExt.brandPrimary),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.refresh),
              ),
            ),*/
          ],
        ),
      ),
      bottomNavigationBar: (widget.exception.error?.urlLabel != null || widget.exception.error?.isButtonEnable == true)
          ? Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: .min,
                children: [
                  if (widget.exception.error?.urlLabel != null && widget.exception.error?.isButtonEnable == true)
                    AppButton(
                      title: widget.exception.error!.urlLabel!,
                      onPressed: () async => _handleRedirect(url: widget.exception.error!.redirectionUrl!),
                      buttonStyleType: ButtonStyleType.outlined,
                    ),
                  if (widget.exception.error?.isRestartRequired == true) ...[
                    const Gap(10),
                    AppButton(title: "Go to Home", onPressed: () => context.go(RouteName.splashView)),
                  ],
                ],
              ),
            )
          : null,
    );
  }

  Widget _basicErrorBody(BuildContext context, AppErrorConfig config) {
    return AppScaffold(
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        padding: EdgeInsets.all(20.p),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Image.asset(config.imageAsset, height: 150.h, fit: BoxFit.cover),
            Gap(14.h),
            AppTextWidget(text: config.title, fontWeight: FontWeight.w700, fontSize: 20.sp, textAlign: TextAlign.center),
            Gap(8.h),
            AppTextWidget(text: config.description, fontWeight: FontWeight.w500, fontSize: 15.sp, textAlign: TextAlign.center),
          ],
        ),
      ),
      bottomNavigationBar:
          (widget.exception.error?.urlLabel != null ||
              config.buttonText != null ||
              widget.exception.code == 500 ||
              widget.exception.code == 422)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                title: widget.exception.error?.urlLabel ?? config.buttonText ?? "Try Again",
                onPressed: () => context.go(RouteName.splashView),
              ),
            )
          : null,
    );
  }
}

AppErrorConfig getErrorConfig(BuildContext context, AppException exception) {
  final defaultImage = Assets.images.noInternet.path;

  return AppErrorConfig(
    imageAsset: defaultImage,
    title: _resolveTitle(context, exception),
    description: exception.message,
    action: exception.errorActionType,
    buttonText: exception.buttonText,
  );
}

String _resolveTitle(BuildContext context, AppException exception) {
  if (exception is NoInternetError) {
    return context.loc.noInternet;
  }
  if (exception is TimeoutError || exception is GatewayTimeoutError) {
    return context.loc.requestTimedOut;
  }
  if (exception is SessionExpiry) {
    return context.loc.sessionExpired;
  }
  if (exception is ForbiddenError) {
    return context.loc.accessDenied;
  }
  if (exception is UnauthorizedError) {
    return context.loc.unauthorized;
  }
  if (exception is NotFoundError) {
    return context.loc.notFoundError;
  }
  if (exception is ServerError) {
    return context.loc.serverError;
  }
  if (exception is BadRequestError) {
    return context.loc.badRequestError;
  }
  if (exception is ServiceUnavailableError) {
    return context.loc.serviceUnavailableError;
  }
  if (exception is MethodNotAllowedError) {
    return context.loc.methodNotAllowedError;
  }
  if (exception is TooManyRequestsError) {
    return context.loc.tooManyRequestsError;
  }
  if (exception is BadGatewayError) {
    return context.loc.badGatewayError;
  }
  if (exception is HTTPVersionNotSupportedError) {
    return context.loc.httpVersionNotSupportedError;
  }

  return context.loc.unknownError;
}

class AppErrorConfig {
  final String imageAsset;
  final String title;
  final String description;
  final ErrorActionType action;
  final String? buttonText;

  AppErrorConfig({required this.imageAsset, required this.title, required this.description, required this.action, this.buttonText});
}
