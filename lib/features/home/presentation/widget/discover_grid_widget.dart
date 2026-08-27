import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

class DiscoverGrid extends StatelessWidget {
  const DiscoverGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: const [
              _IconTile(
                icon: Icons.directions_boat_filled_outlined,
                label: 'Yacht Rentals',
              ),
              _IconTile(icon: Icons.eco_outlined, label: 'Wellness Trails'),
            ],
          ),
        ),
        Gap(14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 145.h,
                width: double.infinity,
                child: const ScreenshotCrop(
                  crop: Rect.fromLTWH(164, 1360, 118, 117),
                  borderRadius: 8,
                ),
              ),
              Gap(12.h),
              AppTextWidget(
                text: "Chef's Table",
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: theme.textPrimary,
              ),
              Gap(4.h),
              AppTextWidget(
                text: 'Book an exclusive culinary journey with local masters.',
                fontSize: 11.sp,
                height: 1.25,
                color: theme.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      height: 145.h,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.brandPrimary, size: 26.sp),
          Gap(9.h),
          AppTextWidget(
            text: label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: theme.textPrimary,
          ),
        ],
      ),
    );
  }
}
