import 'package:flutter_svg/svg.dart';

import '../core.dart';
import '../resources/constants/app_colors.dart';
import '../utilities/enums/enums_types.dart';
import '../utilities/extensions/extensions.dart';
import '../utilities/extensions/provide_theme_extension.dart';
import '../utilities/global.dart';
import '../utilities/helper/app_helpers.dart';
import 'app_loading_widget.dart';

class AppButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final ButtonStyleType buttonStyleType;
  final double? height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final AlignmentGeometry? alignment;
  final double outlinedBorderWidth;
  final ExtendedButtonType extendedButtonType;
  final IconData? iconData;
  final String? svgAsset;
  final String? imageAsset;
  final double iconSize;
  final double iconTextSpacing;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool isIconPrefix;
  final bool isLoading;
  final Color? loaderColor;
  final bool isDisabled;
  final Widget? iconWidget;
  final bool isSwipeable;
  final String? swipeText;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.buttonStyleType = ButtonStyleType.elevated,
    this.height = 47,
    this.width = double.infinity,
    this.borderRadius = 6,
    this.padding,
    this.contentPadding,
    this.textStyle,
    this.alignment,
    this.outlinedBorderWidth = 1,
    this.extendedButtonType = ExtendedButtonType.iconWithText,
    this.iconData,
    this.svgAsset,
    this.imageAsset,
    this.iconSize = 50,
    this.iconTextSpacing = 8,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.isIconPrefix = true,
    this.isLoading = false,
    this.loaderColor,
    this.isDisabled = false,
    this.iconWidget,
    this.isSwipeable = false,
    this.swipeText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getBorderColor() {
      if (isDisabled) {
        return AppColor.greyDark;
      }
      return borderColor ?? context.themeExt.brandPrimary;
    }

    Color getIconColor() {
      if (isDisabled) {
        return AppColor.greyDark;
      }
      return iconColor ?? theme.primaryColor;
    }

    ButtonStyle getButtonStyle() {
      final defaultPadding = padding ?? EdgeInsets.symmetric(horizontal: 16.p, vertical: 4.p);
      final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius));
      final size = Size(width ?? 1.sp, height ?? 56.sp);

      switch (buttonStyleType) {
        case ButtonStyleType.elevated:
          return ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.disabled)) {
                return backgroundColor ?? Global.navigatorKey.currentContext!.themeExt.card;
              }
              return backgroundColor ?? context.themeExt.brandPrimary;
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColor.greyDark;
              }
              return theme.colorScheme.onPrimary;
            }),

            /// ✅ FIX: Border added here
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: BorderSide(color: getBorderColor(), width: outlinedBorderWidth),
              ),
            ),
            padding: WidgetStateProperty.all(defaultPadding),
            minimumSize: WidgetStateProperty.all(size),
            fixedSize: WidgetStateProperty.all(size),
            maximumSize: WidgetStateProperty.all(size),
            // shape: WidgetStateProperty.all(shape),
            elevation: WidgetStateProperty.all(0),
            textStyle: WidgetStateProperty.all(textStyle),
          );

        case ButtonStyleType.outlined:
          return OutlinedButton.styleFrom(
            backgroundColor: isDisabled ? backgroundColor ?? AppColor.greyLight : Colors.transparent,
            foregroundColor: isDisabled ? AppColor.greyDark : getBorderColor(),
            padding: defaultPadding,
            minimumSize: size,
            fixedSize: size,
            maximumSize: size,
            shape: shape,
            side: BorderSide(color: isDisabled ? AppColor.greyDark : getBorderColor(), width: outlinedBorderWidth),
          );

        case ButtonStyleType.text:
          return TextButton.styleFrom(
            backgroundColor: isDisabled ? backgroundColor ?? AppColor.grey : Colors.transparent,
            foregroundColor: isDisabled ? AppColor.greyDark : getBorderColor(),
            padding: defaultPadding,
            minimumSize: size,
            shape: shape,
          );
      }
    }

    Widget? buildIconWidget() {
      if (iconData != null) {
        return Icon(iconData, size: iconSize, color: getIconColor());
      } else if (svgAsset != null) {
        return SvgPicture.asset(
          svgAsset!,
          width: iconSize,
          // color: getIconColor(),
          // colorFilter: ColorFilter.mode(getIconColor(), BlendMode.srcIn),
        );
      } else if (imageAsset != null) {
        return Image.asset(imageAsset!, width: iconSize, color: getIconColor());
      } else if (this.iconWidget != null) {
        return this.iconWidget;
      }
      return null;
    }

    final style = getButtonStyle();
    final isOutlinedOrText = buttonStyleType == ButtonStyleType.outlined || buttonStyleType == ButtonStyleType.text;
    final textColor = isDisabled
        ? AppColor.greyDark
        : isOutlinedOrText
        ? (borderColor ?? context.themeExt.brandPrimary)
        : theme.colorScheme.onPrimary;
    final effectiveTextStyle =
        (textStyle ?? TextSizeHelper.size16().copyWith(color: textStyle?.color ?? textColor, fontWeight: FontWeight.w600));

    // final Color effectiveLoaderColor = loaderColor ?? (buttonStyleType == ButtonStyleType.elevated ? theme.colorScheme.onPrimary : (borderColor ?? theme.primaryColor));

    final iconWidget = buildIconWidget();
    Widget buttonChild;

    if (isLoading) {
      //before
      /* buttonChild = SizedBox(
        height: iconSize,
        width: iconSize,
        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(effectiveLoaderColor)),
      );*/
      //after
      buttonChild = SizedBox(
        // height: iconSize,
        // width: iconSize,
        height: 40,
        width: 35,
        child: AppLoadingWidget(
          isInitialApi: false,
          positionFilled: false,
          // size: iconSize,
          size: 20,
        ),
      );
    } else {
      switch (extendedButtonType) {
        case ExtendedButtonType.iconOnly:
          buttonChild = iconWidget ?? const SizedBox();
          break;
        case ExtendedButtonType.iconWithText:
          if (iconWidget != null) {
            buttonChild = Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: isIconPrefix
                  ? [iconWidget, SizedBox(width: iconTextSpacing), Text(title, style: effectiveTextStyle)]
                  : [Text(title, style: effectiveTextStyle), SizedBox(width: iconTextSpacing), iconWidget],
            );
          } else {
            buttonChild = Text(title, style: effectiveTextStyle);
          }
          break;
      }
    }

    if (isSwipeable) {
      return _SwipeButton(
        onComplete: (isDisabled || isLoading) ? null : onPressed,
        title: swipeText ?? title,
        height: height ?? 55,
        borderRadius: borderRadius,
        isDisabled: isDisabled,
      );
    }
    Widget button;
    switch (buttonStyleType) {
      case ButtonStyleType.elevated:
        button = ElevatedButton(onPressed: (isDisabled || isLoading) ? null : onPressed, style: style, child: buttonChild);
        break;
      case ButtonStyleType.outlined:
        button = OutlinedButton(onPressed: (isDisabled || isLoading) ? null : onPressed, style: style, child: buttonChild);
        break;
      case ButtonStyleType.text:
        button = TextButton(onPressed: (isDisabled || isLoading) ? null : onPressed, style: style, child: buttonChild);
        break;
    }

    return alignment != null ? Align(alignment: alignment!, child: button) : button;
  }
}

class _SwipeButton extends StatefulWidget {
  final VoidCallback? onComplete;
  final String title;
  final double height;
  final double borderRadius;
  final bool isDisabled;

  const _SwipeButton({
    required this.onComplete,
    required this.title,
    required this.height,
    required this.borderRadius,
    required this.isDisabled,
  });

  @override
  State<_SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<_SwipeButton> {
  double _drag = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final knobSize = widget.height;
        final maxDrag = maxWidth - knobSize;

        final progress = (_drag / maxDrag).clamp(0.0, 1.0);

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: context.themeExt.brandPrimary.withValues(alpha: 0.6),
          ),
          child: Stack(
            children: [
              /// 🔥 FILL ANIMATION (Blinkit style)
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: _drag + knobSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  gradient: LinearGradient(colors: [context.themeExt.brandPrimary, context.themeExt.brandPrimary.withValues(alpha: 0.8)]),
                ),
              ),

              /// 📝 TEXT (fades while swiping)
              Center(
                child: Opacity(
                  opacity: 1 - progress,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColor.white,
                      // color: Color.lerp(
                      //   Colors.white,
                      //   Colors.black,
                      //   progress,
                      // ),
                    ),
                  ),
                ),
              ),

              /// 👉 DRAGGABLE KNOB
              Positioned(
                left: _drag,
                child: GestureDetector(
                  onHorizontalDragUpdate: widget.isDisabled
                      ? null
                      : (details) {
                          setState(() {
                            _drag += details.delta.dx;
                            _drag = _drag.clamp(0, maxDrag);
                          });
                        },
                  onHorizontalDragEnd: (_) {
                    if (_drag > maxDrag * 0.85) {
                      HapticFeedback.mediumImpact();
                      widget.onComplete?.call();
                    }

                    /// 🔁 Smooth reset (important UX)
                    setState(() => _drag = 0);
                  },
                  child: Container(
                    height: knobSize,
                    width: knobSize,
                    decoration: BoxDecoration(
                      color: widget.isDisabled ? Colors.grey : context.themeExt.brandPrimary,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6)],
                    ),
                    child: const Icon(Icons.double_arrow_rounded, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
