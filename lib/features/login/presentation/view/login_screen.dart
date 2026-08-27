import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/features/login/presentation/bloc/login_bloc.dart';
import 'package:goanest/features/login/presentation/bloc/login_event.dart';
import 'package:goanest/features/login/presentation/bloc/login_state.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => LoginBloc(),
    child: BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) context.go(RouteName.homeView);
      },
      child: const _LoginView(),
    ),
  );
}

class _LoginView extends StatelessWidget {
  const _LoginView();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.scaffoldBackground,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(14.w, 72.h, 14.w, 20.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 430.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Havenstay',
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Log in or sign up',
                  style: TextStyle(fontSize: 15.sp),
                ),
                SizedBox(height: 28.h),
                const _EmailField(),
                SizedBox(height: 9.h),
                _PrimaryButton(
                  label: 'Continue with Email',
                  onTap: () => _submit(context),
                ),
                SizedBox(height: 28.h),
                const _DividerLabel(),
                SizedBox(height: 20.h),
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
                SizedBox(height: 5.h),
                Center(
                  child: Wrap(
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColor.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(RouteName.registerView),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                Center(
                  child: Text(
                    'By signing in, you agree to our Terms of Service and\nPrivacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColor.textQuaternary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  void _submit(BuildContext context) {
    context.read<LoginBloc>().add(const LoginSubmitted());
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();
  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    return TextField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        final bloc = context.read<LoginBloc>();
        bloc.add(LoginIdentifierChanged(value));
        bloc.add(const LoginPasswordChanged('stitch-email'));
      },
      decoration: InputDecoration(
        hintText: 'Email address',
        hintStyle: TextStyle(
          fontSize: 13.sp,
          color: AppColor.textQuaternary,
        ),
        errorText: state.identifierError,
        filled: true,
        fillColor: AppColor.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 16.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColor.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColor.borderGrey),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 50.h,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
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
