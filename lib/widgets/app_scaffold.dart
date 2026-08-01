import '../core.dart';
import '../resources/constants/app_colors.dart';
import '../utilities/extensions/extensions.dart';
import '../utilities/extensions/provide_theme_extension.dart';
import '../utilities/ui_config/app_gradients.dart';
import 'app_image_widget.dart';
import 'app_loading_widget.dart';

class AppScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final Gradient? gradient;
  final bool useGradient;
  final String? backgroundImage;
  final bool resizeToAvoidBottomInset;
  final List<Widget>? persistentFooterButtons;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool primary;
  final bool isSafe;
  final bool isSafeTop;
  final bool isSafeBottom;
  final bool isMarginEnabled;
  final bool isOverlayLoader;
  final bool isShimmer;
  final bool transparentLoader;
  final Widget? shimmerBody;
  final String? loaderLottiePath;
  const AppScaffold({
    super.key,
    this.scaffoldKey,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.gradient,
    this.useGradient = false,
    this.backgroundImage,
    this.resizeToAvoidBottomInset = true,
    this.persistentFooterButtons,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.primary = true,
    this.isSafe = true,
    this.isSafeTop = false,
    this.isSafeBottom = true,
    this.isMarginEnabled = false,
    this.isOverlayLoader = false,
    this.transparentLoader = true,
    this.isShimmer = false,
    this.shimmerBody,
    this.loaderLottiePath,
  });
  @override
  Widget build(BuildContext context) {
    final Widget bodyWidget = buildBody(isMarginEnabled: isMarginEnabled) ?? const SizedBox.shrink();
    final Widget resolvedBody = Stack(
      children: [
        bodyWidget,
        if (shimmerBody != null && isShimmer)
          IgnorePointer(
            ignoring: !isShimmer,
            child: TickerMode(
              enabled: isShimmer,
              child: Opacity(opacity: isShimmer ? 1 : 0, child: shimmerBody!),
            ),
          ),
        if (isOverlayLoader && !isShimmer)
          AppLoadingWidget(
            isInitialApi: true,
            positionFilled: false,
            size: 80.sp,
            transparentLoader: transparentLoader,
            // lottiePath: loaderLottiePath,
          ),
      ],
    );
    final Widget safeBody;
    if (isSafe) {
      safeBody = SafeArea(child: resolvedBody);
    } else if (isSafeTop || isSafeBottom) {
      safeBody = SafeArea(top: isSafeTop, bottom: isSafeBottom, child: resolvedBody);
    } else {
      safeBody = resolvedBody;
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: context.themeExt.isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: context.themeExt.isDark ? Brightness.dark : Brightness.light,
      ),
      child: Stack(
        children: [
          //TODO: Adding this line
          if (useGradient) Container(decoration: BoxDecoration(gradient: gradient ?? AppGradient.scaffoldGradient)),

          if (backgroundImage != null && backgroundImage!.isNotEmpty) ...[
            Positioned.fill(child: Container(color: context.themeExt.surface)),

            Positioned.fill(
              child: AppImageWidget(imageUrl: backgroundImage!, fit: BoxFit.fill, alignment: Alignment.topCenter, borderRadius: 0),
            ),
          ],
          Scaffold(
            key: scaffoldKey,
            appBar: appBar,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            body: safeBody,
            floatingActionButton: (isOverlayLoader) ? null : floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            drawer: drawer,
            endDrawer: endDrawer,
            backgroundColor: (useGradient || (backgroundImage != null && backgroundImage!.isNotEmpty))
                ? AppColor.transparent
                : (backgroundColor ?? context.themeExt.surface),
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            persistentFooterButtons: persistentFooterButtons,
            bottomSheet: bottomSheet,
            extendBody: extendBody,
            primary: primary,
            bottomNavigationBar: bottomNavigationBar != null ? SafeArea(top: false, child: bottomNavigationBar!) : null,
          ),
        ],
      ),
    );
  }

  Widget? buildBody({bool isMarginEnabled = false}) {
    return Container(margin: EdgeInsets.all(isMarginEnabled ? 16.p : 0), child: body ?? SizedBox.shrink());
  }
}
