import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';

class WishlistFab extends StatelessWidget {
  const WishlistFab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        color: theme.brandPrimary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.playlist_add_rounded,
        color: AppColor.white,
        size: 24.sp,
      ),
    );
  }
}
