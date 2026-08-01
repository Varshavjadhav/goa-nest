import 'package:flutter/material.dart';

import '../core.dart';
import '../resources/constants/app_colors.dart';
import '../utilities/extensions/extensions.dart';
import '../utilities/extensions/provide_theme_extension.dart';
import 'app_scaffold.dart';

class AppLoadingWidget extends StatelessWidget {
  final bool isInitialApi;
  final bool positionFilled;
  final bool transparentLoader;
  final double size;
  // final String? lottiePath;

  const AppLoadingWidget({
    super.key,
    this.isInitialApi = true,
    this.positionFilled = true,
    this.transparentLoader = true,
    this.size = 64,
    // this.lottiePath,
  });

  // Widget centerWidget() {
  //   if (lottiePath != null && lottiePath!.isNotEmpty) {
  //     return TickerMode(
  //       enabled: true,
  //       child: Lottie.asset(lottiePath!, height: size, width: size, repeat: true),
  //     );
  //   } else {
  //     return CircularProgressIndicator(color: AppColor.primary);
  //   }
  // }
  Widget centerWidget() {
    return const CircularProgressIndicator(color: AppColor.primary);
  }

  @override
  Widget build(BuildContext context) {
    return isInitialApi
        ? AppScaffold(
            backgroundColor: transparentLoader ? context.themeExt.background.withValues(alpha: 0.9) : context.themeExt.background,
            body: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 3.p),
                child: centerWidget(),
              ),
            ),
          )
        : positionFilled
        ? Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                color: transparentLoader ? context.themeExt.background.withValues(alpha: 0.9) : context.themeExt.background,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.p),
                    child: centerWidget(),
                  ),
                ),
              ),
            ),
          )
        : Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.p),
              child: centerWidget(),
            ),
          );
  }
}
