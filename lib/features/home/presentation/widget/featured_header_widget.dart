import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class FeaturedHeader extends StatelessWidget {
  const FeaturedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget(
                text: 'Featured Escapes',
                fontSize: 19.sp,
                fontWeight: FontWeight.w900,
                color: theme.textPrimary,
              ),
              Gap(2.h),
              AppTextWidget(
                text: 'Curated collection for your next stay',
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
                color: theme.textSecondary,
              ),
            ],
          ),
        ),
        AppTextWidget(
          text: 'View All',
          fontSize: 12.sp,
          fontWeight: FontWeight.w800,
          color: theme.brandPrimary,
        ),
      ],
    );
  }
}
