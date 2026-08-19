import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

const _destinationCrops = [
  Rect.fromLTWH(33, 313, 130, 112),
  Rect.fromLTWH(164, 340, 130, 112),
  Rect.fromLTWH(33, 581, 130, 112),
  Rect.fromLTWH(164, 600, 130, 112),
];

class DestinationStrip extends StatelessWidget {
  const DestinationStrip({super.key});

  @override
  Widget build(BuildContext context) {
    const names = ['Palolem', 'Vagator', 'Assagao', 'Divar Island'];
    const regions = ['South Goa', 'North Goa', 'North Goa', 'Islands'];

    return SizedBox(
      height: 166.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _destinationCrops.length,
        separatorBuilder: (_, _) => Gap(12.w),
        itemBuilder: (context, index) {
          return _DestinationTile(
            crop: _destinationCrops[index],
            name: names[index],
            region: regions[index],
          );
        },
      ),
    );
  }
}

class _DestinationTile extends StatelessWidget {
  final Rect crop;
  final String name;
  final String region;

  const _DestinationTile({
    required this.crop,
    required this.name,
    required this.region,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return SizedBox(
      width: 152.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 112.h,
            width: double.infinity,
            child: ScreenshotCrop(crop: crop, borderRadius: 10.r),
          ),
          Gap(9.h),
          AppTextWidget(
            text: name,
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
            color: theme.textPrimary,
          ),
          Gap(2.h),
          AppTextWidget(
            text: region,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: theme.textSecondary,
          ),
        ],
      ),
    );
  }
}
