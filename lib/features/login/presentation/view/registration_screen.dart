import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xfffafafa),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.go(RouteName.loginView),
                  icon: const Icon(Icons.arrow_back, size: 18),
                ),
                const Expanded(
                  child: Text(
                    'Registration',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xffc90032),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Create an account',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text(
              'Enter your email to get started.',
              style: TextStyle(fontSize: 13, color: Color(0xff777777)),
            ),
            const SizedBox(height: 28),
            const _RegistrationField(),
            const SizedBox(height: 16),
            const Text(
              'By continuing, you may receive an SMS for verification.\nMessage and data rates may apply.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Color(0xff777777)),
            ),
            const SizedBox(height: 58),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffc90032),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: const Text(
                  'Continue with Email',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _DividerLabel(),
            const SizedBox(height: 13),
            const _ProviderButton(
              icon: Icons.phone_iphone,
              label: 'Continue with Phone',
            ),
            const _ProviderButton(
              icon: Icons.g_mobiledata,
              label: 'Continue with Google',
              color: Colors.blue,
            ),
            const _ProviderButton(
              icon: Icons.apple,
              label: 'Continue with Apple',
            ),
            const SizedBox(height: 12),
            Wrap(
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 11),
                ),
                GestureDetector(
                  onTap: () => context.go(RouteName.loginView),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xffc90032),
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
  Widget build(BuildContext context) => const TextField(
    decoration: InputDecoration(
      hintText: 'Email address',
      hintStyle: TextStyle(fontSize: 13, color: Color(0xff777777)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Color(0xffcccccc)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Color(0xffcccccc)),
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
          side: const BorderSide(color: Color(0xffcccccc)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    ),
  );
}
