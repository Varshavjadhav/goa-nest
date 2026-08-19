import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

class RecentlyViewedStrip extends StatelessWidget {
  const RecentlyViewedStrip({super.key});

  static const _items = [
    (
      crop: Rect.fromLTWH(33, 313, 130, 112),
      title: 'Azure Bay Retreat',
      beds: '2 beds',
      rating: '4.9',
    ),
    (
      crop: Rect.fromLTWH(164, 340, 130, 112),
      title: 'Casa Verde Manor',
      beds: '4 beds',
      rating: '4.8',
    ),
    (
      crop: Rect.fromLTWH(33, 581, 130, 112),
      title: 'The Canopy Nest',
      beds: '1 bed',
      rating: '5.0',
    ),
    (
      crop: Rect.fromLTWH(164, 600, 130, 112),
      title: 'Palolem Hideaway',
      beds: '3 beds',
      rating: '4.7',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return SizedBox(
      height: 184.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _items.length,
        separatorBuilder: (_, _) => Gap(12.w),
        itemBuilder: (context, index) {
          final item = _items[index];
          return SizedBox(
            width: 150.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 134.h,
                  width: double.infinity,
                  child: ScreenshotCrop(crop: item.crop, borderRadius: 12.r),
                ),
                Gap(10.h),
                AppTextWidget(
                  text: item.title,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.homeTitleText,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Row(
                  children: [
                    AppTextWidget(
                      text: item.beds,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: theme.homeSubtitleText,
                    ),
                    Gap(6.w),
                    Icon(Icons.star_rounded, color: theme.homeIcon, size: 13.sp),
                    Gap(3.w),
                    AppTextWidget(
                      text: item.rating,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: theme.homeTitleText,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
