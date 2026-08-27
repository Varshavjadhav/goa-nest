import 'package:flutter/material.dart';

import '../utilities/extensions/provide_theme_extension.dart';

class AppTextWidget extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? height;
  final TextOverflow? textOverflow;
  final TextDecoration? textDecoration;
  final Color? textDecorationColor;
  final int? maxLines;
  final bool? softWrap;
  final FontStyle? fontStyle;
  final VoidCallback? onTap;
  final String? fontFamily;

  static const String defaultFontFamily = 'Montserrat';

  const AppTextWidget({
    super.key,
    this.text,
    this.fontSize,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.letterSpacing,
    this.height,
    this.textOverflow,
    this.textDecoration,
    this.textDecorationColor,
    this.maxLines,
    this.softWrap,
    this.fontStyle,
    this.onTap,
    this.fontFamily,
  });

  /// Hero / display large – 32sp w800
  const AppTextWidget.displayLarge({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 32,
        fontWeight = FontWeight.w800;

  /// Display medium – 28sp w800
  const AppTextWidget.displayMedium({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 28,
        fontWeight = FontWeight.w800;

  /// Display small – 24sp w700
  const AppTextWidget.displaySmall({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 24,
        fontWeight = FontWeight.w700;

  /// Headline large – 22sp w700
  const AppTextWidget.headlineLarge({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 22,
        fontWeight = FontWeight.w700;

  /// Headline medium – 20sp w700
  const AppTextWidget.headlineMedium({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 20,
        fontWeight = FontWeight.w700;

  /// Headline small – 18sp w700
  const AppTextWidget.headlineSmall({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 18,
        fontWeight = FontWeight.w700;

  /// Title large – 16sp w700
  const AppTextWidget.titleLarge({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 16,
        fontWeight = FontWeight.w700;

  /// Title medium – 15sp w600
  const AppTextWidget.titleMedium({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 15,
        fontWeight = FontWeight.w600;

  /// Title small – 14sp w600
  const AppTextWidget.titleSmall({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 14,
        fontWeight = FontWeight.w600;

  /// Body large – 15sp w400
  const AppTextWidget.bodyLarge({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 15,
        fontWeight = FontWeight.w400;

  /// Body medium – 13sp w400
  const AppTextWidget.bodyMedium({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 13,
        fontWeight = FontWeight.w400;

  /// Body small – 12sp w400
  const AppTextWidget.bodySmall({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 12,
        fontWeight = FontWeight.w400;

  /// Label large – 13sp w700
  const AppTextWidget.labelLarge({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 13,
        fontWeight = FontWeight.w700;

  /// Label medium – 11sp w600
  const AppTextWidget.labelMedium({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 11,
        fontWeight = FontWeight.w600;

  /// Label small – 10sp w600
  const AppTextWidget.labelSmall({
    super.key,
    required String this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.onTap,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.textDecorationColor,
    this.textOverflow,
    this.softWrap,
    this.fontStyle,
    this.fontFamily,
  })  : fontSize = 10,
        fontWeight = FontWeight.w600;

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(
      textAlign: textAlign,
      text ?? "",
      overflow: textOverflow,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      style: TextStyle(
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontFamily: fontFamily ?? defaultFontFamily,
        decoration: textDecoration,
        decorationColor: textDecorationColor,
        fontSize: fontSize ?? 12,
        color: color ?? context.themeExt.textPrimary,
        height: height,
        letterSpacing: letterSpacing,
      ),
    );
    if (onTap != null) {
      textWidget = GestureDetector(onTap: onTap, child: textWidget);
    }
    return textWidget;
  }
}
