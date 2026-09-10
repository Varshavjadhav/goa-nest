import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

class CollectionsStrip extends StatelessWidget {
  const CollectionsStrip({super.key});

  static const _collections = [
    (
      crop: Rect.fromLTWH(33, 313, 150, 170),
      name: 'Dream Stays',
      subtitle: 'Coronet',
    ),
    (
      crop: Rect.fromLTWH(164, 313, 150, 170),
      name: 'South Goa Villas',
      subtitle: 'Goa Provinces',
    ),
    (
      crop: Rect.fromLTWH(33, 847, 150, 170),
      name: 'Beach Getaways',
      subtitle: 'South Coast',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _collections.length,
        separatorBuilder: (_, _) => Gap(11.w),
        itemBuilder: (context, index) {
          final c = _collections[index];
          return _CollectionCard(
            crop: c.crop,
            name: c.name,
            subtitle: c.subtitle,
          );
        },
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final Rect crop;
  final String name;
  final String subtitle;

  const _CollectionCard({
    required this.crop,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165.w,
      child: Stack(
        children: [
          Positioned.fill(
            child: ScreenshotCrop(crop: crop, borderRadius: 12.r),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColor.black.withValues(alpha: 0.05),
                    AppColor.black.withValues(alpha: 0.62),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12.p,
            right: 12.p,
            bottom: 12.p,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget(
                  text: name,
                  color: AppColor.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                Gap(2.h),
                AppTextWidget(
                  text: subtitle,
                  color: AppColor.white.withValues(alpha: 0.85),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
