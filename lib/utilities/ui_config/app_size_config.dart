import '../../../core.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double? textMultiplier;
  static double? imageSizeMultiplier;
  static double? heightMultiplier;
  static double? widthMultiplier;
  static bool _isPortrait = true;
  static bool _isMobile = false;
  static bool _isTablet = false;
  static bool _isWeb = false;

  static void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      _isPortrait = true;
      if (screenWidth < 450) {
        //501
        //450
        _isMobile = true;
        _isTablet = false;
        _isWeb = false;
      } else if (screenWidth >= 450 && screenWidth < 768) {
        _isMobile = false;
        _isTablet = true;
        _isWeb = false;
      } else {
        _isMobile = false;
        _isTablet = false;
        _isWeb = true;
      }
    } else {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      _isPortrait = false;
      _isMobile = false;
      _isTablet = false;
      _isWeb = true;
    }
    _blockWidth = (screenWidth / 100);
    _blockHeight = (screenHeight / 100);

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
  }

  // Get the proportionate common padding as per the screen size
  static double getProportionatePadding(double inputPadding) {
    // Base design size (same as your vertical + horizontal bases)
    const double designHeight = 812.0;
    const double designWidth = 375.0;

    // Calculate scale for both dimensions
    final double heightScale = SizeConfig.screenHeight / designHeight;
    final double widthScale  = SizeConfig.screenWidth / designWidth;

    // Use average scale so padding feels balanced
    final double scale = (heightScale + widthScale) / 2;

    return inputPadding * scale;
  }

  // Get the proportionate height as per screen size
  static double getProportionateScreenHeight(double inputHeight) {
    double? screenHeight = SizeConfig.screenHeight;
    // 812 is the layout height that designer use
    return (inputHeight / 812.0) * screenHeight;
  }

  // Get the proportionate width as per screen size
  static double getProportionateScreenWidth(double inputWidth) {
    double? screenWidth = SizeConfig.screenWidth;
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }

  // Get the proportionate size for text based on screen height
  static double getProportionateTextSize(double inputSize) {
    double? textMultiplier = SizeConfig.textMultiplier;
    return (inputSize / 812.0) * textMultiplier! * 100;
  }

  // Get the proportionate size for image based on screen width
  static double getProportionateImageSize(double inputSize) {
    double? imageSizeMultiplier = SizeConfig.imageSizeMultiplier;
    return (inputSize / 375.0) * imageSizeMultiplier!;
  }

  // Get the proportionate height for a widget based on screen height
  static double getProportionateHeight(double inputHeight) {
    double? heightMultiplier = SizeConfig.heightMultiplier;
    return (inputHeight / 812.0) * heightMultiplier!;
  }

  // Get the proportionate width for a widget based on screen width
  static double getProportionateWidth(double inputWidth) {
    double? widthMultiplier = SizeConfig.widthMultiplier;
    return (inputWidth / 375.0) * widthMultiplier!;
  }

  // Get proportionate radius based on screen width
  static double getProportionateRadius(double inputRadius) {
    double screenWidth = SizeConfig.screenWidth;
    // 375 is the design width
    return (inputRadius / 375.0) * screenWidth;
  }

  bool get isMobile => SizeConfig._isMobile;

  bool get isTablet => SizeConfig._isTablet;

  bool get isWeb => SizeConfig._isWeb;
  bool get isPortrait => SizeConfig._isPortrait;
}
