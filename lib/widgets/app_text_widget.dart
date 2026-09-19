import 'package:flutter/material.dart';

import '../utilities/extensions/provide_theme_extension.dart';

class AppTextWidget extends StatelessWidget {
  final String? text;

  /// Optional Flutter text style for migration of legacy `Text` call sites.
  /// Explicit AppTextWidget properties still take precedence when provided.
  final TextStyle? style;
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

  /// App-wide typeface. Keep all shared text on the same Inter family so
  /// weights remain consistent across headings, body copy, and controls.
  static const String defaultFontFamily = 'Inter';

  const AppTextWidget({
    super.key,
    this.text,
    this.style,
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

  /// Compatibility constructor for call sites that previously used
  /// `Text('...', style: ...)`.
  const AppTextWidget.legacy(
    String text, {
    super.key,
    this.style,
    this.textAlign,
    TextOverflow? overflow,
    this.maxLines,
    this.softWrap,
    this.onTap,
  }) : text = text,
       textOverflow = overflow,
       fontSize = null,
       color = null,
       fontWeight = null,
       letterSpacing = null,
       height = null,
       textDecoration = null,
       textDecorationColor = null,
       fontStyle = null,
       fontFamily = null;

  /// Hero / display large – 32sp w800
  const AppTextWidget.displayLarge({
    super.key,
    this.style,
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
  }) : fontSize = 32,
       fontWeight = FontWeight.w800;

  /// Display medium – 28sp w800
  const AppTextWidget.displayMedium({
    super.key,
    this.style,
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
  }) : fontSize = 28,
       fontWeight = FontWeight.w800;

  /// Display small – 24sp w700
  const AppTextWidget.displaySmall({
    super.key,
    this.style,
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
  }) : fontSize = 24,
       fontWeight = FontWeight.w700;

  /// Headline large – 22sp w700
  const AppTextWidget.headlineLarge({
    super.key,
    this.style,
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
  }) : fontSize = 22,
       fontWeight = FontWeight.w700;

  /// Headline medium – 20sp w700
  const AppTextWidget.headlineMedium({
    super.key,
    this.style,
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
  }) : fontSize = 20,
       fontWeight = FontWeight.w700;

  /// Headline small – 18sp w700
  const AppTextWidget.headlineSmall({
    super.key,
    this.style,
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
  }) : fontSize = 18,
       fontWeight = FontWeight.w700;

  /// Title large – 16sp w700
  const AppTextWidget.titleLarge({
    super.key,
    this.style,
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
  }) : fontSize = 16,
       fontWeight = FontWeight.w700;

  /// Title medium – 15sp w600
  const AppTextWidget.titleMedium({
    super.key,
    this.style,
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
  }) : fontSize = 15,
       fontWeight = FontWeight.w600;

  /// Title small – 14sp w600
  const AppTextWidget.titleSmall({
    super.key,
    this.style,
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
  }) : fontSize = 14,
       fontWeight = FontWeight.w600;

  /// Body large – 15sp w400
  const AppTextWidget.bodyLarge({
    super.key,
    this.style,
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
  }) : fontSize = 15,
       fontWeight = FontWeight.w400;

  /// Body medium – 14sp w400
  const AppTextWidget.bodyMedium({
    super.key,
    this.style,
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
  }) : fontSize = 14,
       fontWeight = FontWeight.w400;

  /// Body small – 13sp w400
  const AppTextWidget.bodySmall({
    super.key,
    this.style,
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
  }) : fontSize = 13,
       fontWeight = FontWeight.w400;

  /// Label large – 14sp w600
  const AppTextWidget.labelLarge({
    super.key,
    this.style,
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
  }) : fontSize = 14,
       fontWeight = FontWeight.w600;

  /// Label medium – 12sp w500
  const AppTextWidget.labelMedium({
    super.key,
    this.style,
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
  }) : fontSize = 12,
       fontWeight = FontWeight.w500;

  /// Label small – 11sp w500
  const AppTextWidget.labelSmall({
    super.key,
    this.style,
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
  }) : fontSize = 11,
       fontWeight = FontWeight.w500;

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(
      textAlign: textAlign,
      text ?? "",
      overflow: textOverflow,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      style: TextStyle(
        fontWeight: fontWeight ?? style?.fontWeight,
        fontStyle: fontStyle ?? style?.fontStyle,
        fontFamily: fontFamily ?? style?.fontFamily ?? defaultFontFamily,
        decoration: textDecoration ?? style?.decoration,
        decorationColor: textDecorationColor ?? style?.decorationColor,
        decorationThickness: style?.decorationThickness,
        fontSize: fontSize ?? style?.fontSize ?? 14,
        color: color ?? style?.color ?? context.themeExt.textPrimary,
        height: height ?? style?.height,
        letterSpacing: letterSpacing ?? style?.letterSpacing,
        wordSpacing: style?.wordSpacing,
        background: style?.background,
        foreground: style?.foreground,
        shadows: style?.shadows,
      ),
    );
    if (onTap != null) {
      textWidget = GestureDetector(onTap: onTap, child: textWidget);
    }
    return textWidget;
  }
}
