import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/rating_pill_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

class ResultsGrid extends StatelessWidget {
  const ResultsGrid({super.key});

  static const _stays = [
    (
      crop: Rect.fromLTWH(33, 313, 249, 165),
      title: 'Azure Bay Retreat',
      location: 'Anjuna, North Goa',
      price: '₹18,500',
      rating: '4.9',
    ),
    (
      crop: Rect.fromLTWH(33, 581, 249, 148),
      title: 'Casa Verde Manor',
      location: 'Assagao, Goa',
      price: '₹12,200',
      rating: '4.8',
    ),
    (
      crop: Rect.fromLTWH(33, 847, 249, 166),
      title: 'The Canopy Nest',
      location: 'Agonda, South Goa',
      price: '₹9,800',
      rating: '5.0',
    ),
    (
      crop: Rect.fromLTWH(33, 1165, 249, 248),
      title: 'Coconut Grove',
      location: 'Morjim, Goa',
      price: '₹7,400',
      rating: '4.7',
    ),
    (
      crop: Rect.fromLTWH(33, 313, 120, 248),
      title: 'Palm Court',
      location: 'Calangute, Goa',
      price: '₹11,900',
      rating: '4.6',
    ),
    (
      crop: Rect.fromLTWH(164, 581, 120, 248),
      title: 'Hilltop Haven',
      location: 'Vagator, Goa',
      price: '₹16,300',
      rating: '4.9',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate((_stays.length / 2).ceil(), (rowIndex) {
        final first = _stays[rowIndex * 2];
        final second = (rowIndex * 2 + 1) < _stays.length
            ? _stays[rowIndex * 2 + 1]
            : null;

        return Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _SearchStayCard(stay: first)),
              if (second != null) ...[
                Gap(14.w),
                Expanded(child: _SearchStayCard(stay: second)),
              ] else ...[
                Gap(14.w),
                const Expanded(child: SizedBox()),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _SearchStayCard extends StatelessWidget {
  final ({
    Rect crop,
    String title,
    String location,
    String price,
    String rating,
  }) stay;

  const _SearchStayCard({required this.stay});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 128.h,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: ScreenshotCrop(crop: stay.crop, borderRadius: 8.r),
              ),
              Positioned(
                top: 8.p,
                right: 8.p,
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: AppColor.white.withValues(alpha: 0.94),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    color: const Color(0xFF4F5955),
                    size: 17.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextWidget(
                text: stay.title,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: theme.textPrimary,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            RatingPill(rating: stay.rating),
          ],
        ),
        Gap(4.h),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: theme.textTertiary,
              size: 11.sp,
            ),
            Gap(3.w),
            Expanded(
              child:               AppTextWidget(
                text: stay.location,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: theme.textSecondary,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Gap(8.h),
        RichText(
          text: TextSpan(
            text: stay.price,
            style: TextStyle(
              color: theme.brandPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
            children: [
              TextSpan(
                text: ' / night',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
