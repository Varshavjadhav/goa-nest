import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_button_widget.dart';
import 'package:goanest/widgets/app_scaffold.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = true;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isSafe: false,
      backgroundColor: AppColor.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _RegistrationBackground(),
          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.sizeOf(context).height -
                      MediaQuery.paddingOf(context).vertical,
                ),
                child: Column(
                  children: [
                    Gap(16.h),
                    const _BrandHeader(),
                    Gap(28.h),
                    _RegistrationCard(
                      obscurePassword: _obscurePassword,
                      obscureConfirmPassword: _obscureConfirmPassword,
                      acceptTerms: _acceptTerms,
                      onTogglePassword: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      onToggleConfirmPassword: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      onToggleTerms: () {
                        setState(() {
                          _acceptTerms = !_acceptTerms;
                        });
                      },
                    ),
                    Gap(20.h),
                    const _LoginLink(),
                    Gap(24.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => context.pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                color: AppColor.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.loginAccentSoft),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColor.primary,
                size: 20.sp,
              ),
            ),
          ),
        ),
        Gap(20.h),
        Container(
          height: 92.h,
          width: 92.w,
          decoration: BoxDecoration(
            color: AppColor.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.loginAccentSoft, width: 8.w),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withValues(alpha: 0.14),
                blurRadius: 26,
                offset: Offset(0, 14.h),
              ),
            ],
          ),
          child: Icon(
            Icons.holiday_village_rounded,
            color: AppColor.primary,
            size: 44.sp,
          ),
        ),
        Gap(24.h),
        AppTextWidget(
          text: 'Create account',
          textAlign: TextAlign.center,
          color: AppColor.primaryDark,
          fontSize: 28.sp,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
        Gap(8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: AppTextWidget(
            text: 'Set up your profile to book stays, save favorites, and manage trips.',
            textAlign: TextAlign.center,
            color: AppColor.textSecondary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _RegistrationCard extends StatelessWidget {
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool acceptTerms;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onToggleTerms;

  const _RegistrationCard({
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.acceptTerms,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onToggleTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 22.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColor.loginCardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryDark.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: Offset(0, 18.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(
            text: 'Join GoaNest',
            color: AppColor.textPrimary,
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
          ),
          Gap(6.h),
          AppTextWidget(
            text: 'Create your account to get started',
            color: AppColor.textTertiary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          Gap(24.h),
          _RegisterTextField(
            label: 'Full name',
            hintText: 'Enter your full name',
            prefixIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          Gap(18.h),
          _RegisterTextField(
            label: 'Mobile number',
            hintText: 'Enter 10-digit mobile number',
            prefixIcon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          Gap(18.h),
          _RegisterTextField(
            label: 'Email address',
            hintText: 'you@example.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          Gap(18.h),
          _RegisterTextField(
            label: 'Password',
            hintText: 'Create password',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.next,
            suffixIcon: obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixTap: onTogglePassword,
          ),
          Gap(18.h),
          _RegisterTextField(
            label: 'Confirm password',
            hintText: 'Confirm password',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            suffixIcon: obscureConfirmPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixTap: onToggleConfirmPassword,
          ),
          Gap(14.h),
          _TermsToggle(
            value: acceptTerms,
            onTap: onToggleTerms,
          ),
          Gap(24.h),
          AppButton(
            title: 'Create account',
            height: 54.h,
            borderRadius: 14.r,
            backgroundColor: AppColor.primary,
            borderColor: AppColor.primary,
            onPressed: () => context.go(RouteName.homeView),
            textStyle: TextStyle(
              color: AppColor.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              fontFamily: AppTextWidget.defaultFontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onSuffixTap;

  const _RegisterTextField({
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget(
          text: label,
          color: AppColor.textPrimary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
        Gap(8.h),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          onChanged: (_) {},
          cursorColor: AppColor.primary,
          style: TextStyle(
            color: AppColor.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppTextWidget.defaultFontFamily,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColor.textTertiary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppTextWidget.defaultFontFamily,
            ),
            filled: true,
            fillColor: AppColor.loginInputFill,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 16.h,
            ),
            prefixIcon: Icon(prefixIcon, color: AppColor.primary, size: 20.sp),
            suffixIcon: suffixIcon == null
                ? null
                : IconButton(
                    onPressed: onSuffixTap,
                    icon: Icon(
                      suffixIcon,
                      color: AppColor.textTertiary,
                      size: 20.sp,
                    ),
                  ),
            border: _border(AppColor.loginInputBorder),
            enabledBorder: _border(AppColor.loginInputBorder),
            focusedBorder: _border(AppColor.primary),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: color),
    );
  }
}

class _TermsToggle extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;

  const _TermsToggle({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 20.h,
              width: 20.w,
              decoration: BoxDecoration(
                color: value ? AppColor.primary : AppColor.white,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: value ? AppColor.primary : AppColor.loginInputBorder,
                ),
              ),
              child: value
                  ? Icon(
                      Icons.check_rounded,
                      color: AppColor.white,
                      size: 15.sp,
                    )
                  : null,
            ),
            Gap(8.w),
            Expanded(
              child: AppTextWidget(
                text: 'I agree to receive booking updates and accept the terms of service.',
                color: AppColor.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          text: 'Already have an account?',
          color: AppColor.textTertiary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        Gap(4.w),
        AppTextWidget(
          text: 'Sign in',
          color: AppColor.primary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          onTap: () => context.go(RouteName.loginView),
        ),
      ],
    );
  }
}

class _RegistrationBackground extends StatelessWidget {
  const _RegistrationBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColor.loginBackgroundTop, AppColor.loginBackgroundBottom],
        ),
      ),
      child: CustomPaint(painter: _WaterBackgroundPainter()),
    );
  }
}

class _WaterBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final topWave = Paint()..color = AppColor.primary.withValues(alpha: 0.08);
    final midWave = Paint()..color = AppColor.secondary.withValues(alpha: 0.08);
    final badge = Paint()
      ..color = AppColor.loginBadgeBackground.withValues(alpha: 0.62);

    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.12),
      size.width * 0.22,
      badge,
    );
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.28),
      size.width * 0.18,
      badge,
    );

    final path = Path()
      ..moveTo(0, size.height * 0.16)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.09,
        size.width * 0.42,
        size.height * 0.24,
        size.width * 0.62,
        size.height * 0.16,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.10,
        size.width * 0.90,
        size.height * 0.13,
        size.width,
        size.height * 0.08,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    final lowerPath = Path()
      ..moveTo(0, size.height * 0.93)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.87,
        size.width * 0.44,
        size.height * 0.98,
        size.width * 0.68,
        size.height * 0.91,
      )
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.87,
        size.width * 0.92,
        size.height * 0.89,
        size.width,
        size.height * 0.84,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, topWave);
    canvas.drawPath(lowerPath, midWave);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
