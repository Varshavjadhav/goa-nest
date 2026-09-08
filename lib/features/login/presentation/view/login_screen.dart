import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/core/di/injector.dart';
import 'package:goanest/features/login/domain/usecase/get_login.dart';
import 'package:goanest/features/login/presentation/bloc/login_bloc.dart';
import 'package:goanest/features/login/presentation/bloc/login_event.dart';
import 'package:goanest/features/login/presentation/bloc/login_state.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => LoginBloc(sl<GetLoginUseCase>()),
    child: BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) context.go(RouteName.homeView);
        if (state.status == LoginStatus.failure && state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
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
                AppTextWidget.titleLarge(
                  text: 'GoaNest',
                  color: AppColor.primary,
                ),
                SizedBox(height: 5.h),
                AppTextWidget.bodyLarge(text: 'Log in or sign up'),
                SizedBox(height: 28.h),
                const _EmailField(),
                SizedBox(height: 16.h),
                const _PasswordField(),
                SizedBox(height: 9.h),
                CommonWidgets.primaryButton(
                  label: context.watch<LoginBloc>().state.isSubmitting
                      ? 'Signing in...'
                      : 'Continue with Email',
                  onTap: context.watch<LoginBloc>().state.isSubmitting
                      ? () {}
                      : () => _submit(context),
                ),
                SizedBox(height: 28.h),
                CommonWidgets.dividerLabel(label: 'or'),
                SizedBox(height: 20.h),
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
                SizedBox(height: 5.h),
                Center(
                  child: Wrap(
                    children: [
                      AppTextWidget.bodyMedium(
                        text: "Don't have an account? ",
                        color: AppColor.textSecondary,
                      ),
                      GestureDetector(
                        onTap: () => context.go(RouteName.registerView),
                        child: AppTextWidget(
                          text: 'Sign up',
                          fontSize: 13,
                          color: AppColor.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                Center(
                  child: AppTextWidget.labelMedium(
                    text:
                        'By signing in, you agree to our Terms of Service and\nPrivacy Policy.',
                    textAlign: TextAlign.center,
                    color: AppColor.textQuaternary,
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
      },
      decoration: CommonWidgets.inputDecoration(
        hint: 'Email address',
        errorText: state.identifierError,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    final bloc = context.read<LoginBloc>();
    return TextField(
      obscureText: state.obscurePassword,
      onChanged: (value) => bloc.add(LoginPasswordChanged(value)),
      decoration: CommonWidgets.inputDecoration(
        hint: 'Password',
        errorText: state.passwordError,
        suffixIcon: IconButton(
          onPressed: () => bloc.add(const LoginPasswordVisibilityToggled()),
          icon: Icon(
            state.obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
