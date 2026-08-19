import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

class PlantationCard extends StatelessWidget {
  const PlantationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 249.h,
      width: double.infinity,
      child: Stack(
        children: [
          const Positioned.fill(
            child: ScreenshotCrop(
              crop: Rect.fromLTWH(33, 1165, 249, 248),
              borderRadius: 8,
            ),
          ),
          Positioned(
            left: 20.p,
            right: 20.p,
            bottom: 20.p,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget(
                  text: 'Private Plantation Tours',
                  color: AppColor.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                ),
                Gap(3.h),
                AppTextWidget(
                  text: 'Exclusive back-to-nature experiences',
                  color: AppColor.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
