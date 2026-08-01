import '../../core.dart';
import '../../resources/constants/app_colors.dart';

class AppGradient {
  static RadialGradient scaffoldGradient = RadialGradient(
    center: Alignment.topLeft,
    radius: 1.5,
    colors: [AppColor.scaffoldBackground, AppColor.white],
    stops: [0.0, 0.7],
  );

  static RadialGradient onboardingBg = RadialGradient(
    colors: [Color(0xFFFFF8E6), Color(0xFFFCBF22)],
    center: Alignment.bottomLeft,
    radius: 2.9,
    stops: [0.5, 1.0],
    tileMode: TileMode.decal,
  );

  static LinearGradient loginBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColor.warning, AppColor.success],
  );

  static LinearGradient profileBg = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.1, 1],
    tileMode: TileMode.mirror,
    colors: [Color(0xFFF62E8E), Color(0xFFAC1AF0)],
  );

  static const LinearGradient containerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF), // White
      Color(0xFFC0E5E5), // Light teal
    ],
  );

  static const LinearGradient creditScoreAppBar = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFC7E9E9), Color(0xFF079FA0)],
  );
}
