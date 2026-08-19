import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';

const _recentSearches = [
  'Beachfront villas',
  'North Goa',
  'Honeymoon resorts',
  'Panaji',
];

class RecentSearchList extends StatelessWidget {
  const RecentSearchList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: theme.divider),
      ),
      child: Column(
        children: List.generate(_recentSearches.length, (index) {
          return Column(
            children: [
              if (index > 0)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 46.p,
                  color: theme.divider,
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.p, vertical: 13.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      color: theme.brandPrimary,
                      size: 19.sp,
                    ),
                    Gap(11.w),
                    Expanded(
                      child: AppTextWidget(
                        text: _recentSearches[index],
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.textPrimary,
                      ),
                    ),
                    Icon(
                      Icons.north_west_rounded,
                      color: theme.textTertiary,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
