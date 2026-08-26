import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/features/login/presentation/bloc/login_bloc.dart';
import 'package:goanest/features/login/presentation/bloc/login_event.dart';
import 'package:goanest/features/login/presentation/bloc/login_state.dart';

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
    backgroundColor: const Color(0xfffafafa),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 72, 14, 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Havenstay',
                  style: TextStyle(
                    color: Color(0xffe0002b),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                const Text('Log in or sign up', style: TextStyle(fontSize: 15)),
                const SizedBox(height: 28),
                const _EmailField(),
                const SizedBox(height: 9),
                _PrimaryButton(
                  label: 'Continue with Email',
                  onTap: () => _submit(context),
                ),
                const SizedBox(height: 28),
                const _DividerLabel(),
                const SizedBox(height: 20),
                const _ProviderButton(
                  icon: Icons.phone_iphone,
                  label: 'Continue with Phone',
                ),
                const _ProviderButton(
                  icon: Icons.g_mobiledata,
                  label: 'Continue with Google',
                  color: Colors.red,
                ),
                const _ProviderButton(
                  icon: Icons.apple,
                  label: 'Continue with Apple',
                ),
                const SizedBox(height: 5),
                Center(
                  child: Wrap(
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff666666),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(RouteName.registerView),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xffe0002b),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Center(
                  child: Text(
                    'By signing in, you agree to our Terms of Service and\nPrivacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Color(0xff777777)),
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
        hintStyle: const TextStyle(fontSize: 13, color: Color(0xff777777)),
        errorText: state.identifierError,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xffdddddd)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xffdddddd)),
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
    height: 42,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffc90032),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel();
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(child: Divider(color: Color(0xffe5e5e5))),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'or',
          style: TextStyle(fontSize: 13, color: Color(0xff777777)),
        ),
      ),
      Expanded(child: Divider(color: Color(0xffe5e5e5))),
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
    padding: const EdgeInsets.only(bottom: 6),
    child: SizedBox(
      width: double.infinity,
      height: 34,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 15, color: color ?? Colors.black),
        label: Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xff222222)),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xffdddddd)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    ),
  );
}
