import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goanest/resources/constants/url_end_points.dart';

import '../core.dart';
import '../gen/assets/assets.gen.dart';
import '../resources/constants/app_colors.dart';
import '../utilities/enums/enums_types.dart';
import '../utilities/extensions/extensions.dart';
import '../utilities/global.dart';
import '../utilities/utils.dart';

class AppImageWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final String imageUrl;
  final BoxFit fit;
  final double borderRadius;
  final double margin;
  final Alignment alignment;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  final bool isCircular;
  final bool isProfile;
  final bool useBaseUrl;
  final String? imageDebugLabel;
  final bool flipHorizontal;
  final Widget? frameSliderWidget;
  final bool showWatermarkPreview;
  final String errorImage;
  final Color? imageColor;
  final AppImageSource? source;
  final GlobalKey? canvasKey;
  final Function(double width, double height)? onSizeCalculated;

  /// A reusable image widget used across the app to render different image sources
  /// such as network images, assets, SVGs, base64 images, and local file images.
  ///
  /// By default, the image source is **automatically detected** using
  /// `Utils.detectImageSource(imageUrl)` if the `source` parameter is not provided.
  ///
  /// The default detection rules are:
  ///
  /// • `assets/...` → Asset image
  /// • `.svg` → SVG image
  /// • `data:image/...` or long base64 string → Base64 image
  /// • `/storage`, `/data`, `file://` → Local file image
  /// • Any other path → Network image (default)
  ///
  /// For backend images, the API typically returns only the **relative endpoint**:
  ///
  /// ```
  /// festival/thumbnails/abc123.jpg
  /// moment/images/thumbnails/xyz456.jpg
  /// ```
  ///
  /// In such cases, the widget automatically constructs the full URL using:
  ///
  /// ```
  /// F.storageUrl + imageUrl
  /// ```
  ///
  /// unless `useBaseUrl` is set to `false`.
  ///
  /// ---
  ///
  /// ### Common Usage
  ///
  /// ```dart
  /// AppImageWidget(
  ///   imageUrl: "festival/thumbnails/sample.jpg",
  /// )
  /// ```
  ///
  /// ---
  ///
  /// ### Asset Image
  ///
  /// ```dart
  /// AppImageWidget(
  ///   imageUrl: Assets.images.logo.path,
  /// )
  /// ```
  ///
  /// ---
  ///
  /// ### SVG Image
  ///
  /// ```dart
  /// AppImageWidget(
  ///   imageUrl: Assets.icons.verifyOtp.path,
  ///   source: AppImageSource.svg,
  /// )
  /// ```
  ///
  /// ---
  ///
  /// ### File Image
  ///
  /// ```dart
  /// AppImageWidget(
  ///   imageUrl: file.path,
  ///   source: AppImageSource.file,
  /// )
  /// ```
  ///
  /// ---
  ///
  /// ### Base64 Image
  ///
  /// ```dart
  /// AppImageWidget(
  ///   imageUrl: base64String,
  ///   source: AppImageSource.base64,
  /// )
  /// ```
  ///
  /// ---
  ///
  /// Additional Features:
  ///
  /// • Supports circular images (`isCircular`)
  /// • Profile placeholder when image is empty (`isProfile`)
  /// • Optional horizontal flip (`flipHorizontal`)
  /// • Custom border radius per corner
  /// • Cached network loading with placeholder and error handling
  /// • Debug listener to inspect original image dimensions (`imageDebugLabel`)
  ///
  /// This widget centralizes image rendering logic to keep UI code clean
  /// and consistent across the application.
  const AppImageWidget({
    super.key,
    this.height = 120,
    this.width,
    this.flipHorizontal = false,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius = 10,
    this.margin = 0,
    this.alignment = Alignment.center,
    this.topLeftRadius,
    this.topRightRadius,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.isCircular = false,
    this.isProfile = false,
    this.useBaseUrl = true,
    this.frameSliderWidget,
    this.showWatermarkPreview = false,
    this.imageDebugLabel,
    this.source,
    this.errorImage = "",
    this.imageColor,
    this.canvasKey,
    this.onSizeCalculated,
  });

  @override
  State<AppImageWidget> createState() => _AppImageWidgetState();
}

class _AppImageWidgetState extends State<AppImageWidget> {
  ImageStream? _imageStream;
  ImageStreamListener? _imageListener;

  void _removeListener() {
    if (_imageStream != null && _imageListener != null) {
      _imageStream!.removeListener(_imageListener!);
    }
  }

  @override
  void dispose() {
    /// ✅ ONLY dispose if debug was used
    if (widget.imageDebugLabel != null) {
      _removeListener();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppImageSource resolvedSource = widget.source ?? Utils.detectImageSource(widget.imageUrl);

    final customRadius = BorderRadius.only(
      topLeft: Radius.circular(widget.topLeftRadius ?? widget.borderRadius),
      topRight: Radius.circular(widget.topRightRadius ?? widget.borderRadius),
      bottomLeft: Radius.circular(widget.bottomLeftRadius ?? widget.borderRadius),
      bottomRight: Radius.circular(widget.bottomRightRadius ?? widget.borderRadius),
    );

    Widget imageWidget;

    /// PROFILE PLACEHOLDER
    if (widget.isProfile && widget.imageUrl.isEmpty) {
      imageWidget = Container(
        height: widget.height?.h,
        width: widget.width?.w,
        padding: EdgeInsets.all(4.p),
        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColor.grey),
        child: Center(
          child: Icon(Icons.person, size: (widget.height ?? 1) * 0.8, color: AppColor.black),
        ),
      );
    } else {
      switch (resolvedSource) {
        case AppImageSource.svg:
          imageWidget = SvgPicture.asset(
            widget.imageUrl,
            height: widget.height?.h,
            width: widget.width?.w,
            fit: widget.fit,
            colorFilter: widget.imageColor != null ? ColorFilter.mode(widget.imageColor!, BlendMode.srcIn) : null,
          );
          break;

        case AppImageSource.asset:
          imageWidget = Image.asset(
            widget.imageUrl,
            height: widget.height?.h,
            width: widget.width?.w,
            fit: widget.fit,
            color: widget.imageColor,
            colorBlendMode: widget.imageColor != null ? BlendMode.srcIn : null,
          );
          break;

        case AppImageSource.file:
          imageWidget = Image.file(
            File(widget.imageUrl),
            height: widget.height?.h,
            width: widget.width?.w,
            fit: widget.fit,
            alignment: widget.alignment,
            color: widget.imageColor,
            colorBlendMode: widget.imageColor != null ? BlendMode.srcIn : null,
            errorBuilder: (_, _, _) => _buildErrorImage(),
          );
          break;

        case AppImageSource.base64:
          String cleanedBase64 = widget.imageUrl;

          if (cleanedBase64.contains(",")) {
            cleanedBase64 = cleanedBase64.split(",").last;
          }

          final decodedBytes = base64Decode(cleanedBase64);

          imageWidget = Image.memory(
            decodedBytes,
            height: widget.height?.h,
            width: widget.width?.w,
            fit: widget.fit,
            alignment: widget.alignment,
            color: widget.imageColor,
            colorBlendMode: widget.imageColor != null ? BlendMode.srcIn : null,
          );
          break;

        case AppImageSource.network:
          try {
            final imageUrlFinal = widget.useBaseUrl ? storageUrl + widget.imageUrl : widget.imageUrl;

            final imageProvider = CachedNetworkImageProvider(imageUrlFinal);

            /// ORIGINAL SIZE LISTENER
            if (widget.imageDebugLabel != null) {
              /// ✅ remove old before adding new (important for rebuilds)
              _removeListener();

              final stream = imageProvider.resolve(const ImageConfiguration());

              _imageListener = ImageStreamListener((ImageInfo info, bool _) {
                final originalWidth = info.image.width.toDouble();
                final originalHeight = info.image.height.toDouble();

                final imageWidth = Global.frameImageHeight * originalWidth / originalHeight;

                /// update global
                Global.imageParamWidth = imageWidth;

                /// notify parent (optional)
                widget.onSizeCalculated?.call(imageWidth, Global.frameImageHeight);

                /// 🔥 THIS IS THE MISSING PIECE
                if (mounted) setState(() {});
              });

              _imageStream = stream;
              stream.addListener(_imageListener!);
            }

            if (widget.frameSliderWidget != null && widget.canvasKey != null) {
              imageWidget = Container(
                padding: EdgeInsets.all(widget.margin),
                child: ClipRRect(
                  borderRadius: customRadius,
                  child: FittedBox(
                    fit: widget.fit,
                    child: SizedBox(
                      width: Global.imageParamWidth,
                      height: Global.frameImageHeight,
                      child: Stack(
                        children: [
                          RepaintBoundary(
                            key: widget.canvasKey,
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: imageUrlFinal,
                                  fit: BoxFit.fill,
                                  httpHeaders: const {"Accept": "image/webp,image/*,*/*"},
                                  fadeInDuration: Duration.zero,
                                  fadeOutDuration: Duration.zero,
                                  placeholderFadeInDuration: Duration.zero,
                                  alignment: widget.alignment,
                                  placeholder: imagePlaceholderWidget,
                                  errorWidget: (_, _, _) => _buildErrorImage(),
                                ),

                                // if (widget.frameSliderWidget != null) Positioned.fill(child: widget.frameSliderWidget!),
                              ],
                            ),
                          ),
                          // if (widget.showWatermarkPreview) _previewWatermark(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              imageWidget = CachedNetworkImage(
                imageUrl: imageUrlFinal,
                httpHeaders: const {"Accept": "image/webp,image/*,*/*"},
                height: widget.height?.h,
                width: widget.width?.w,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                fit: widget.fit,
                alignment: widget.alignment,
                placeholder: imagePlaceholderWidget,
                errorWidget: (_, _, _) => _buildErrorImage(),
              );
            }
          } catch (e) {
            debugPrint(e.toString());
            imageWidget = _buildErrorImage();
          }
          break;
      }
    }

    Widget finalImage = widget.isCircular ? ClipOval(child: imageWidget) : ClipRRect(borderRadius: customRadius, child: imageWidget);

    /// Apply horizontal flip
    if (widget.flipHorizontal) {
      finalImage = Transform(alignment: Alignment.center, transform: Matrix4.rotationY(pi), child: finalImage);
    }

    return Container(padding: EdgeInsets.all(widget.margin), child: finalImage);
  }

  /// ✅ Centralized Error Image Logic
  Widget _buildErrorImage() {
    final fallbackImage = (widget.errorImage.isNotEmpty) ? widget.errorImage : Assets.images.defaultImage.path;

    /// If it looks like network url → load network
    if (fallbackImage.startsWith('http')) {
      return Image.network(
        fallbackImage,
        fit: BoxFit.cover,
        height: widget.height?.h,
        width: widget.width?.w,
        errorBuilder: (_, _, _) => Image.asset(fallbackImage, fit: BoxFit.cover),
      );
    }

    return Image.asset(fallbackImage, fit: BoxFit.cover, width: widget.width?.w);
  }

  Widget imagePlaceholderWidget(BuildContext context, url) => Container(color: AppColor.transparent);
}
