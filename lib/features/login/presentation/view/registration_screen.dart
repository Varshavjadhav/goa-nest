import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.scaffoldBackground,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 20.h),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.go(RouteName.loginView),
                  icon: Icon(Icons.arrow_back, size: 18.sp),
                ),
                Expanded(
                  child: AppTextWidget.titleLarge(
                    text: 'Registration',
                    textAlign: TextAlign.center,
                    color: AppColor.primary,
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),
            SizedBox(height: 5.h),
            AppTextWidget(
              text: 'Create an account',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 4.h),
            AppTextWidget.bodyMedium(
              text: 'Enter your email to get started.',
              color: AppColor.textQuaternary,
            ),
            SizedBox(height: 28.h),
            TextField(
              decoration: CommonWidgets.inputDecoration(hint: 'Email address'),
            ),
            SizedBox(height: 16.h),
            AppTextWidget.labelMedium(
              text: 'By continuing, you may receive an SMS for verification.\nMessage and data rates may apply.',
              textAlign: TextAlign.center,
              color: AppColor.textQuaternary,
            ),
            SizedBox(height: 58.h),
            CommonWidgets.primaryButton(
              label: 'Continue with Email',
              onTap: () {},
            ),
            SizedBox(height: 16.h),
            CommonWidgets.dividerLabel(label: 'or'),
            SizedBox(height: 13.h),
            CommonWidgets.providerButton(
              icon: Icons.phone_iphone,
              label: 'Continue with Phone',
              onTap: () {},
            ),
            CommonWidgets.providerButton(
              icon: Icons.g_mobiledata,
              label: 'Continue with Google',
              iconColor: Colors.red,
              onTap: () {},
            ),
            CommonWidgets.providerButton(
              icon: Icons.apple,
              label: 'Continue with Apple',
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            Wrap(
              children: [
                AppTextWidget.bodySmall(text: 'Already have an account? '),
                GestureDetector(
                  onTap: () => context.go(RouteName.loginView),
                  child: AppTextWidget(
                    text: 'Log in',
                    fontSize: 12,
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
