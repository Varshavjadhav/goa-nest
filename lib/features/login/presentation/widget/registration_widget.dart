import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/widgets/app_scaffold.dart';
import 'package:goanest/widgets/app_text_widget.dart';

import '../../../../utilities/extensions/extensions.dart';

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({super.key});

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 900;

    return AppScaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isWide ? 40 : 22, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: isWide
                  ? Row(
                      children: [
                        Expanded(child: _buildForm(context, compact: false)),
                        const SizedBox(width: 38),
                        const Expanded(child: _RegistrationPreviewPanel()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [const _MobileHeader(), const SizedBox(height: 24), _buildForm(context, compact: true)],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, {required bool compact}) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(compact ? 22 : 30),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.primaryLight),
        boxShadow: [BoxShadow(color: AppColor.primaryDark.withValues(alpha: 0.08), blurRadius: 30, offset: const Offset(0, 18))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 8),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.holiday_village_rounded, color: AppColor.white),
              ),
              Gap(12.h),
              AppTextWidget(
                text: 'GoaNest',
                // style: textTheme.headlineMedium?.copyWith(
                color: AppColor.textPrimary,
                fontWeight: FontWeight.w800,
                // ),
              ),
            ],
          ),
          Gap(28.h),
          AppTextWidget(
            text: 'Create account',
            // style: textTheme.displaySmall?.copyWith(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w800,
            // ),
          ),
          Gap(8.h),
          AppTextWidget(
            text: 'Set up your profile to book stays, save favorites, and manage trips.',
            // style: textTheme.bodyMedium?.copyWith(
            color: AppColor.textSecondary,
            height: 1.45,
            // ),
          ),
          Gap(28.h),
          const _FieldLabel(text: 'Full name'),
          Gap(8.h),
          TextFormField(
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Enter your full name', prefixIcon: Icon(Icons.person_outline_rounded)),
          ),
          const SizedBox(height: 18),
          const _FieldLabel(text: 'Mobile number'),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
            decoration: const InputDecoration(
              hintText: 'Enter mobile number',
              prefixIcon: Icon(Icons.phone_android_rounded),
              counterText: '',
            ),
          ),
          const SizedBox(height: 18),
          const _FieldLabel(text: 'Email address'),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: 'you@example.com', prefixIcon: Icon(Icons.mail_outline_rounded)),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _PasswordField(
                  label: 'Password',
                  hintText: 'Create password',
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onToggle: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              if (!compact) const SizedBox(width: 14),
              if (!compact)
                Expanded(
                  child: _PasswordField(
                    label: 'Confirm password',
                    hintText: 'Confirm password',
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    onToggle: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
            ],
          ),
          if (compact) ...[
            const SizedBox(height: 18),
            _PasswordField(
              label: 'Confirm password',
              hintText: 'Confirm password',
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onToggle: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ],
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _acceptTerms,
                  activeColor: AppColor.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'I agree to receive booking updates and accept the terms of service.',
                  style: textTheme.bodyMedium?.copyWith(color: AppColor.textSecondary, height: 1.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Create account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Already have an account?', style: textTheme.bodyMedium?.copyWith(color: AppColor.textSecondary)),
                TextButton(
                  onPressed: () {
                    context.go(RouteName.loginView);
                  },
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.hintText,
    required this.obscureText,
    required this.onToggle,
    required this.textInputAction,
  });

  final String label;
  final String hintText;
  final bool obscureText;
  final VoidCallback onToggle;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: obscureText,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              tooltip: obscureText ? 'Show password' : 'Hide password',
              onPressed: onToggle,
              icon: Icon(obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 210,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/onboarding_pool.png', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColor.black.withValues(alpha: 0.10), AppColor.black.withValues(alpha: 0.66)],
                ),
              ),
            ),
            const Positioned(left: 18, right: 18, bottom: 18, child: _HeroCopy()),
          ],
        ),
      ),
    );
  }
}

class _RegistrationPreviewPanel extends StatelessWidget {
  const _RegistrationPreviewPanel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 720,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/onboarding_pool.png', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColor.black.withValues(alpha: 0.04), AppColor.black.withValues(alpha: 0.74)],
                ),
              ),
            ),
            Positioned(
              left: 30,
              right: 30,
              top: 30,
              child: Row(
                children: const [
                  _BenefitPill(icon: Icons.favorite_rounded, label: 'Save favorite stays'),
                  SizedBox(width: 12),
                  _BenefitPill(icon: Icons.support_agent_rounded, label: 'Trip support'),
                ],
              ),
            ),
            const Positioned(left: 34, right: 34, bottom: 34, child: _HeroCopy()),
          ],
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Start planning your Goa escape',
          style: textTheme.displaySmall?.copyWith(color: AppColor.white, fontWeight: FontWeight.w800, height: 1.15),
        ),
        const SizedBox(height: 10),
        Text(
          'Create a GoaNest profile for faster bookings, saved homes, and personalized stay recommendations.',
          style: textTheme.bodyLarge?.copyWith(color: AppColor.white.withValues(alpha: 0.88), height: 1.45),
        ),
      ],
    );
  }
}

class _BenefitPill extends StatelessWidget {
  const _BenefitPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColor.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.white.withValues(alpha: 0.28)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelLarge?.copyWith(color: AppColor.white, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColor.textPrimary, fontWeight: FontWeight.w700),
    );
  }
}
