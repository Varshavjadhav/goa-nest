import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/core/di/injector.dart';
import 'package:goanest/features/login/domain/usecase/register_user.dart';
import 'package:goanest/features/login/presentation/bloc/register_bloc.dart';
import 'package:goanest/features/login/presentation/bloc/register_event.dart';
import 'package:goanest/features/login/presentation/bloc/register_state.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => RegisterBloc(sl<RegisterUserUseCase>()),
    child: BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          context.go(RouteName.homeView);
        } else if (state.status == RegisterStatus.failure &&
            state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      child: const _RegistrationView(),
    ),
  );
}

class _RegistrationView extends StatelessWidget {
  const _RegistrationView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterBloc>().state;
    final bloc = context.read<RegisterBloc>();
    return Scaffold(
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
                text: 'Enter your details to get started.',
                color: AppColor.textQuaternary,
              ),
              SizedBox(height: 28.h),
              TextField(
                onChanged: (value) => bloc.add(RegisterNameChanged(value)),
                decoration: CommonWidgets.inputDecoration(
                  hint: 'Full name',
                  errorText: state.nameError,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => bloc.add(RegisterEmailChanged(value)),
                decoration: CommonWidgets.inputDecoration(
                  hint: 'Email address',
                  errorText: state.emailError,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                obscureText: state.obscurePassword,
                onChanged: (value) => bloc.add(RegisterPasswordChanged(value)),
                decoration: CommonWidgets.inputDecoration(
                  hint: 'Password',
                  errorText: state.passwordError,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        bloc.add(const RegisterPasswordVisibilityToggled()),
                    icon: Icon(
                      state.obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              AppTextWidget.labelMedium(
                text:
                    'By continuing, you agree to our Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center,
                color: AppColor.textQuaternary,
              ),
              SizedBox(height: 35.h),
              CommonWidgets.primaryButton(
                label: state.isSubmitting
                    ? 'Creating account...'
                    : 'Continue with Email',
                onTap: state.isSubmitting
                    ? () {}
                    : () => bloc.add(const RegisterSubmitted()),
              ),
              SizedBox(height: 16.h),
              CommonWidgets.dividerLabel(label: 'or'),
              SizedBox(height: 13.h),
              CommonWidgets.providerButton(
                icon: Icons.g_mobiledata,
                label: 'Continue with Google',
                iconColor: Colors.red,
                onTap: () => _googleSignInUnavailable(context),
              ),
              CommonWidgets.providerButton(
                icon: Icons.phone_iphone,
                label: 'Continue with Phone',
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

  void _googleSignInUnavailable(
    BuildContext context,
  ) => ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Google sign-in needs an OAuth endpoint and platform configuration.',
      ),
    ),
  );
}
