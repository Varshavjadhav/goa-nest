import '../core.dart';
import '../utilities/extensions/extensions.dart';
import '../utilities/extensions/provide_theme_extension.dart';
import 'app_text_widget.dart';

class RatingPill extends StatelessWidget {
  final String rating;
  final double? fontSize;

  const RatingPill({super.key, required this.rating, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.p, vertical: 4.p),
      decoration: BoxDecoration(
        color: theme.divider,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: theme.brandPrimary, size: 12.sp),
          Gap(3.w),
          AppTextWidget(
            text: rating,
            color: theme.textPrimary,
            fontSize: fontSize ?? 10.sp,
            fontWeight: FontWeight.w900,
          ),
        ],
      ),
    );
  }
}
