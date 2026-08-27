import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';

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
                  child: Text(
                    'Registration',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              'Create an account',
              style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Enter your email to get started.',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColor.textQuaternary,
              ),
            ),
            SizedBox(height: 28.h),
            const _RegistrationField(),
            SizedBox(height: 16.h),
            Text(
              'By continuing, you may receive an SMS for verification.\nMessage and data rates may apply.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColor.textQuaternary,
              ),
            ),
            SizedBox(height: 58.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Continue with Email',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            const _DividerLabel(),
            SizedBox(height: 13.h),
            const _ProviderButton(
              icon: Icons.phone_iphone,
              label: 'Continue with Phone',
            ),
            _ProviderButton(
              icon: Icons.g_mobiledata,
              label: 'Continue with Google',
              color: Colors.red,
            ),
            const _ProviderButton(
              icon: Icons.apple,
              label: 'Continue with Apple',
            ),
            SizedBox(height: 12.h),
            Wrap(
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 11.sp),
                ),
                GestureDetector(
                  onTap: () => context.go(RouteName.loginView),
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600,
                    ),
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

class _RegistrationField extends StatelessWidget {
  const _RegistrationField();
  @override
  Widget build(BuildContext context) => TextField(
    decoration: InputDecoration(
      hintText: 'Email address',
      hintStyle: TextStyle(
        fontSize: 13.sp,
        color: AppColor.textQuaternary,
      ),
      filled: true,
      fillColor: AppColor.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 16.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        borderSide: const BorderSide(color: AppColor.borderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        borderSide: const BorderSide(color: AppColor.borderGrey),
      ),
    ),
  );
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel();
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider(color: AppColor.divider)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Text(
          'or',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColor.textQuaternary,
          ),
        ),
      ),
      const Expanded(child: Divider(color: AppColor.divider)),
    ],
  );
}

class _ProviderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _ProviderButton({required this.icon, required this.label, this.color});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18.sp, color: color ?? AppColor.black),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColor.textPrimary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColor.borderGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    ),
  );
}
