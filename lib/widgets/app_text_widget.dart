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

  static const String defaultFontFamily = 'NotoSans';

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
