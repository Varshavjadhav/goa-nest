import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/widgets/app_text_widget.dart';

import '../../../../core.dart';
import '../../../../utilities/extensions/extensions.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 360,
            child: Image.asset('assets/images/onboarding_pool.png', fit: BoxFit.cover, alignment: Alignment.topCenter),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 18.h, right: 22.w),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: .35),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 360.h,
              padding: EdgeInsets.fromLTRB(28.w, 54.h, 28.w, 26.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
              ),
              child: Column(
                children: [
                  AppTextWidget(
                    text: "Discover Goa's Best\nStays",
                    color: AppColor.textPrimary,
                    fontSize: 28.sp,
                    height: 1.22,
                    fontWeight: FontWeight.w800,
                    textAlign: TextAlign.center,
                  ),
                  Gap(22.h),
                  AppTextWidget(
                    text: '300+ verified hotels, villas, resorts\nand homestays across Goa',
                    textAlign: TextAlign.center,
                    color: AppColor.textSecondary,
                    fontSize: 15.sp,
                    height: 1.6,
                  ),
                  const Spacer(),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: const [_Dot(active: true), _Dot(), _Dot()]),
                  Gap(34.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.r)),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppTextWidget(
                            text: 'Next',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                          ),
                          Gap(12.w),
                          Icon(Icons.arrow_forward, size: 22.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 26.w : 9.w,
      height: 9.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: active ? AppColor.primary : AppColor.grey,
        borderRadius: BorderRadius.circular(99.r),
      ),
    );
  }
}
