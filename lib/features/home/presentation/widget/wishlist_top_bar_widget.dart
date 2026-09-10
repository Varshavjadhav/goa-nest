import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class WishlistTopBar extends StatelessWidget {
  const WishlistTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    Widget icon(IconData data) => SizedBox(
      width: 34.w,
      height: 34.w,
      child: Icon(data, color: theme.textPrimary, size: 20.sp),
    );

    return Row(
      children: [
        icon(Icons.menu_rounded),
        const Spacer(),
        AppTextWidget(
          text: 'Wishlists',
          fontSize: 21.sp,
          fontWeight: FontWeight.w800,
          color: theme.textPrimary,
        ),
        const Spacer(),
        icon(Icons.notifications_none_rounded),
      ],
    );
  }
}
