import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

class PopularHomeCard extends StatelessWidget {
  final Rect crop;
  final String title;
  final String price;
  final String rating;
  final String? badge;

  const PopularHomeCard({
    super.key,
    required this.crop,
    required this.title,
    required this.price,
    required this.rating,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 168.h,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: ScreenshotCrop(crop: crop, borderRadius: 12.r),
              ),
              if (badge != null)
                Positioned(
                  left: 10.p,
                  top: 10.p,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.p, vertical: 5.p),
                    decoration: BoxDecoration(
                      color: theme.guestFavBadgeBackground,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: theme.guestFavBadgeText,
                          size: 11.sp,
                        ),
                        Gap(3.w),
                        AppTextWidget(
                          text: badge!,
                          color: theme.guestFavBadgeText,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Gap(10.h),
        AppTextWidget(
          text: title,
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w700,
          color: theme.homeTitleText,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
        Gap(4.h),
        Row(
          children: [
            Flexible(
              child: AppTextWidget(
                text: price,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: theme.homeTitleText,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            Gap(4.w),
            Icon(Icons.star_rounded, color: theme.homeIcon, size: 13.sp),
            Gap(2.w),
            AppTextWidget(
              text: rating,
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: theme.homeTitleText,
            ),
          ],
        ),
      ],
    );
  }
}
