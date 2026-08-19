import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class SearchTopBar extends StatelessWidget {
  const SearchTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Row(
      children: [
        AppTextWidget(
          text: 'Search',
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: theme.textPrimary,
        ),
        const Spacer(),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(18.r),
          child: SizedBox(
            width: 28.w,
            height: 28.w,
            child: Icon(
              Icons.notifications_none_rounded,
              color: theme.textSecondary,
              size: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
}
