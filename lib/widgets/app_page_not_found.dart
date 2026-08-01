import '../core.dart';
import '../resources/constants/app_colors.dart';
import '../utilities/extensions/extensions.dart';
import 'app_text_widget.dart';

class AppPageNotFound extends StatelessWidget {
  const AppPageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.p, vertical: 40.p),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   AppImages.errorImg,
              //   height: 500,
              //   width: 500,
              // ),
              // SizedBox(height: 20.h),
              Material(
                color: AppColor.transparent,
                child: AppTextWidget(text: "Page Not Found", fontSize: 18.sp, fontWeight: FontWeight.bold, textAlign: TextAlign.center),
              ),
              Gap(10.w),
              Material(
                color: Colors.transparent,
                child: AppTextWidget(text: "Desc", fontSize: 16.sp, textAlign: TextAlign.center, color: AppColor.grey),
              ),
              // SizedBox(height: 30.h),
              // SizedBox(
              //   width: 400,
              //   child: AppPrimaryButton(
              //     label: "Go to Home",
              //     onClick: () {
              //       navigatorKey.currentContext!.go(AppRouter.splashScreen);
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
