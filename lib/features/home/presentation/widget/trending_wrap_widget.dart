import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';

const _trendingSearches = [
  'Beachfront',
  'Pool Villas',
  'Backwaters',
  'Nightlife',
  'Cashew Fest',
  'Yacht Party',
];

class TrendingWrap extends StatelessWidget {
  const TrendingWrap({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: List.generate(_trendingSearches.length, (index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.p, vertical: 9.h),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: theme.divider),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color: theme.brandPrimary,
                size: 14.sp,
              ),
              Gap(6.w),
              AppTextWidget(
                text: _trendingSearches[index],
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
              ),
            ],
          ),
        );
      }),
    );
  }
}
