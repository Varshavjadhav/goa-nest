import '../core.dart';

const _screenAsset = 'assets/images/home_figma_reference.png';
const _screenWidth = 320.0;
const _screenHeight = 1670.0;

class ScreenshotCrop extends StatelessWidget {
  final Rect crop;
  final double borderRadius;

  const ScreenshotCrop({super.key, required this.crop, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / crop.width;
          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: -crop.left * scale,
                top: -crop.top * scale,
                width: _screenWidth * scale,
                height: _screenHeight * scale,
                child: Image.asset(_screenAsset, fit: BoxFit.fill),
              ),
            ],
          );
        },
      ),
    );
  }
}
