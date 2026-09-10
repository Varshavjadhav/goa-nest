import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class WeekendBanner extends StatelessWidget {
  const WeekendBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.p),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.homeDivider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget(
                  text: 'Available in Goa this weekend',
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.homeTitleText,
                ),
                Gap(3.h),
                AppTextWidget(
                  text: 'Stays opening up near you',
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.homeSubtitleText,
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: theme.homeIcon, size: 18.sp),
        ],
      ),
    );
  }
}
