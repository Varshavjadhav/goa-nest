import '../core.dart';
import '../utilities/extensions/extensions.dart';
import '../utilities/extensions/provide_theme_extension.dart';
import 'app_text_widget.dart';

class GoaLogo extends StatelessWidget {
  final double? opacity;

  const GoaLogo({super.key, this.opacity});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return SizedBox(
      width: 45.w,
      height: 23.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 2.w,
            child: AppTextWidget(
              text: 'Go',
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: theme.brandPrimary.withValues(alpha: opacity ?? 1),
            ),
          ),
          Positioned(
            right: 2.w,
            child: AppTextWidget(
              text: 'A',
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFB48B3D),
            ),
          ),
          Positioned(
            top: 2.h,
            child: Icon(
              Icons.landscape_rounded,
              color: theme.brandPrimary,
              size: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
