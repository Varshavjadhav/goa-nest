import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_button_widget.dart';
import 'package:goanest/widgets/app_scaffold.dart';
import 'package:goanest/widgets/app_text_widget.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == LoginStatus.success && state.message != null) {
            context.go(RouteName.homeView);
          }
        },
        child: const _LoginView(),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isSafe: false,
      backgroundColor: AppColor.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _LoginBackground(),
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
                    Gap(52.h),
                    const _BrandHeader(),
                    Gap(34.h),
                    const _LoginCard(),
                    Gap(20.h),
                    const _RegisterLink(),
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
          text: 'Welcome back',
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
            text: 'Sign in to manage bookings, stays, and guest requests.',
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

class _LoginCard extends StatelessWidget {
  const _LoginCard();

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
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget(
                text: 'Sign in',
                color: AppColor.textPrimary,
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
              ),
              Gap(6.h),
              AppTextWidget(
                text: 'Enter your credentials below',
                color: AppColor.textTertiary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              Gap(24.h),
              _LoginTextField(
                label: 'Mobile number',
                hintText: 'Enter 10-digit mobile number',
                keyboardType: TextInputType.phone,
                errorText: state.identifierError,
                prefixIcon: Icons.phone_android_rounded,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (value) => context.read<LoginBloc>().add(
                  LoginIdentifierChanged(value),
                ),
              ),
              Gap(18.h),
              _LoginTextField(
                label: 'Password',
                hintText: 'Enter your password',
                obscureText: state.obscurePassword,
                errorText: state.passwordError,
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: state.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onSuffixTap: () => context.read<LoginBloc>().add(
                  const LoginPasswordVisibilityToggled(),
                ),
                onChanged: (value) =>
                    context.read<LoginBloc>().add(LoginPasswordChanged(value)),
              ),
              Gap(14.h),
              Row(
                children: [
                  _RememberToggle(
                    value: state.rememberMe,
                    onTap: () => context.read<LoginBloc>().add(
                      const LoginRememberMeToggled(),
                    ),
                  ),
                  const Spacer(),
                  AppTextWidget(
                    text: 'Forgot password?',
                    color: AppColor.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              Gap(24.h),
              AppButton(
                title: 'Sign in',
                height: 54.h,
                borderRadius: 14.r,
                backgroundColor: AppColor.primary,
                borderColor: AppColor.primary,
                isLoading: state.isSubmitting,
                onPressed: () =>
                    context.read<LoginBloc>().add(const LoginSubmitted()),
                textStyle: TextStyle(
                  color: AppColor.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppTextWidget.defaultFontFamily,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSuffixTap;

  const _LoginTextField({
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.inputFormatters,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

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
          inputFormatters: inputFormatters,
          onChanged: onChanged,
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
            border: _border(
              hasError ? AppColor.error : AppColor.loginInputBorder,
            ),
            enabledBorder: _border(
              hasError ? AppColor.error : AppColor.loginInputBorder,
            ),
            focusedBorder: _border(
              hasError ? AppColor.error : AppColor.primary,
            ),
          ),
        ),
        if (hasError) ...[
          Gap(6.h),
          AppTextWidget(
            text: errorText,
            color: AppColor.error,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
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

class _RememberToggle extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;

  const _RememberToggle({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
            AppTextWidget(
              text: 'Remember me',
              color: AppColor.textSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterLink extends StatelessWidget {
  const _RegisterLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          text: "Don't have an account?",
          color: AppColor.textTertiary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        Gap(4.w),
        AppTextWidget(
          text: 'Create one',
          color: AppColor.primary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          onTap: () => context.go(RouteName.registerView),
        ),
      ],
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

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
