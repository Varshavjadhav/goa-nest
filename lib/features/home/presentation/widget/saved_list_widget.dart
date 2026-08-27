import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

class SavedList extends StatelessWidget {
  const SavedList({super.key});

  static const _stays = [
    (
      crop: Rect.fromLTWH(33, 313, 249, 165),
      title: 'The Azure Palm Villa',
      location: 'Assagao, North Goa',
      price: '₹24,500',
      rating: '4.92',
    ),
    (
      crop: Rect.fromLTWH(33, 581, 249, 148),
      title: 'Cliffside Serenity',
      location: 'Vagator, North Goa',
      price: '₹18,200',
      rating: '4.88',
    ),
    (
      crop: Rect.fromLTWH(33, 847, 249, 166),
      title: 'The Banyan Estate',
      location: 'Siolim, North Goa',
      price: '₹32,000',
      rating: '4.75',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_stays.isEmpty) {
      return const _EmptyWishlist();
    }

    return Column(
      children: List.generate(_stays.length, (index) {
        final last = index == _stays.length - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: last ? 0 : 26.h),
          child: _SavedStayCard(stay: _stays[index]),
        );
      }),
    );
  }
}

class _SavedStayCard extends StatelessWidget {
  final ({
    Rect crop,
    String title,
    String location,
    String price,
    String rating,
  }) stay;

  const _SavedStayCard({required this.stay});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 178.h,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: ScreenshotCrop(crop: stay.crop, borderRadius: 14.r),
              ),
              Positioned(
                top: 11.p,
                right: 11.p,
                child: Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: AppColor.white.withValues(alpha: 0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: theme.brandPrimary,
                    size: 17.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 7.p, vertical: 3.h),
          decoration: BoxDecoration(
            color: theme.brandPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: theme.brandPrimary, size: 13.sp),
              Gap(3.w),
              AppTextWidget(
                text: stay.rating,
                color: theme.brandPrimary,
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
        ),
        Gap(8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: AppTextWidget(
                text: stay.title,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: theme.textPrimary,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            Gap(10.w),
            RichText(
              text: TextSpan(
                text: stay.price,
                style: TextStyle(
                  color: theme.brandPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
                children: [
              TextSpan(
                text: ' / night',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
                ],
              ),
            ),
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
            AppTextWidget(
              text: stay.location,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: theme.textSecondary,
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 92.w,
            height: 92.w,
            decoration: BoxDecoration(
              color: theme.brandPrimary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              color: theme.brandPrimary,
              size: 42.sp,
            ),
          ),
          Gap(18.h),
          AppTextWidget(
            text: 'No saved stays yet',
            fontSize: 17.sp,
            fontWeight: FontWeight.w900,
            color: theme.textPrimary,
          ),
          Gap(6.h),
          AppTextWidget(
            text: 'Tap the heart on any stay to build your wishlist.',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: theme.textSecondary,
            textAlign: TextAlign.center,
          ),
          Gap(20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 26.p, vertical: 12.h),
            decoration: BoxDecoration(
              color: theme.brandPrimary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: AppTextWidget(
              text: 'Explore Stays',
              color: AppColor.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
