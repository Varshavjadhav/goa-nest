import '../core.dart';
import '../resources/constants/app_colors.dart';
import '../utilities/extensions/extensions.dart';
import '../utilities/extensions/provide_theme_extension.dart';

class FavouriteButton extends StatelessWidget {
  final double? size;
  final bool isSelected;
  final VoidCallback? onTap;

  const FavouriteButton({
    super.key,
    this.size,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size ?? 35.w,
        height: size ?? 35.w,
        decoration: BoxDecoration(
          color: AppColor.white.withValues(alpha: 0.94),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          isSelected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isSelected ? AppColor.primary : context.themeExt.textSecondary,
          size: 20.sp,
        ),
      ),
    );
  }
}
