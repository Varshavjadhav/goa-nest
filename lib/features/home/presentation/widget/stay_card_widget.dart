import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/rating_pill_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

class StayCard extends StatelessWidget {
  final Rect crop;
  final String title;
  final String location;
  final String price;
  final String rating;
  final String? badge;
  final double imageHeight;

  const StayCard({
    super.key,
    required this.crop,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.imageHeight,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: imageHeight.h,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: ScreenshotCrop(crop: crop, borderRadius: 8.r),
              ),
              Positioned(top: 12.p, right: 12.p, child: const _HeartButton()),
              if (badge != null)
                Positioned(
                  left: 16.p,
                  bottom: 12.p,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.p,
                      vertical: 4.p,
                    ),
                    decoration: BoxDecoration(
                      color: theme.brandPrimary,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: AppTextWidget(
                      text: badge!,
                      color: AppColor.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Gap(15.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextWidget(
                text: title,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: theme.textPrimary,
              ),
            ),
            RatingPill(rating: rating),
          ],
        ),
        Gap(5.h),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: theme.textTertiary,
              size: 13.sp,
            ),
            Gap(4.w),
            Expanded(
              child: AppTextWidget(
                text: location,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: theme.textTertiary,
              ),
            ),
          ],
        ),
        Gap(11.h),
        RichText(
          text: TextSpan(
            text: price,
            style: TextStyle(
              color: theme.brandPrimary,
              fontSize: 19.sp,
              fontWeight: FontWeight.w900,
            ),
            children: [
              TextSpan(
                text: ' / night',
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeartButton extends StatelessWidget {
  const _HeartButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        color: AppColor.white.withValues(alpha: 0.94),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        Icons.favorite_border_rounded,
        color: context.themeExt.textSecondary,
        size: 23.sp,
      ),
    );
  }
}
