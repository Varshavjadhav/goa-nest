import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/core.dart';
import 'package:goanest/core/di/injector.dart';
import 'package:goanest/features/home/data/model/profile_model.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/resources/constants/flags.dart';
import 'package:goanest/utilities/extensions/extensions.dart';

import '../../../../core/services/local_secure_storage/secure_storage_service.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) => BlocListener<ProfileBloc, ProfileState>(
    listenWhen: (_, state) => state is ProfileLoaded && state.message != null || state is ProfileError,
    listener: (context, state) {
      if (state is ProfileLoaded && state.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message!)));
      } else if (state is ProfileError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
      }
    },
    child: BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInitial || state is ProfileLoading) {
          return const ColoredBox(
            color: AppColor.surface,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final profile = switch (state) {
          ProfileLoaded value => value.profile,
          ProfileUpdating value => value.profile,
          ProfileError value when value.profile != null => value.profile!,
          _ => const ProfileModel(),
        };
        if (state is ProfileError && state.profile == null) {
          return ColoredBox(
            color: AppColor.surface,
            child: Center(
              child: TextButton(
                onPressed: () => context.read<ProfileBloc>().add(LoadProfile()),
                child: Text('Unable to load profile. Retry'),
              ),
            ),
          );
        }
        return _ProfileContent(
          profile: profile,
          updating: state is ProfileUpdating,
          onEdit: () => _editProfile(context, profile),
          onLogout: () => _logout(context),
        );
      },
    ),
  );
}

class _ProfileContent extends StatelessWidget {
  final ProfileModel profile;
  final bool updating;
  final VoidCallback onEdit;
  final VoidCallback onLogout;
  const _ProfileContent({required this.profile, required this.updating, required this.onEdit, required this.onLogout});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColor.surface,
    child: Stack(
      children: [
        _ProfileScrollContent(profile: profile, onEdit: onEdit, onLogout: onLogout),
        if (updating)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x66000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    ),
  );
}

class _ProfileScrollContent extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback onEdit;
  final VoidCallback onLogout;
  const _ProfileScrollContent({required this.profile, required this.onEdit, required this.onLogout});

  @override
  Widget build(BuildContext context) => CustomScrollView(
    physics: const BouncingScrollPhysics(),
    slivers: [
      SliverPadding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 105.h),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            Text(
              'Profile',
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700, color: AppColor.textPrimary),
            ),
            SizedBox(height: 20.h),
            _ProfileCard(profile: profile, onEdit: onEdit),
            SizedBox(height: 28.h),
            _Section(
              title: 'Account',
              items: [
                _ActionItem(
                  Icons.person_outline_rounded,
                  'Personal information',
                  profile.email.isEmpty ? 'Add your email and phone number' : profile.email,
                  onTap: onEdit,
                ),
              ],
            ),
            _Section(
              title: 'Settings',
              items: [
                _ActionItem(Icons.language_rounded, 'Language and currency', '${profile.language.toUpperCase()} · ${profile.currency}'),
                const _ActionItem(Icons.notifications_none_rounded, 'Notifications', 'Manage your notification preferences'),
                _ActionItem(
                  Icons.description_outlined,
                  'Terms & Conditions',
                  'Read the terms of using GoaNest',
                  onTap: () => _showLegalDocument(context, title: 'Terms & Conditions', body: _termsText),
                ),
                _ActionItem(
                  Icons.privacy_tip_outlined,
                  'Privacy Policy',
                  'Learn how your data is handled',
                  onTap: () => _showLegalDocument(context, title: 'Privacy Policy', body: _privacyText),
                ),
              ],
            ),
            _Section(
              title: 'Support',
              items: const [
                _ActionItem(Icons.help_outline_rounded, 'Help Center', 'Get help with your reservation'),
                _ActionItem(Icons.info_outline_rounded, 'About GoaNest', 'App information and support'),
              ],
            ),
            OutlinedButton(
              onPressed: onLogout,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.textPrimary,
                minimumSize: Size.fromHeight(52.h),
                side: const BorderSide(color: AppColor.divider),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                'Log out',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 18.h),
            Center(
              child: Text(
                'GoaNest v1.0.0',
                style: TextStyle(fontSize: 11.sp, color: AppColor.textSecondary),
              ),
            ),
          ]),
        ),
      ),
    ],
  );
}

Future<void> _editProfile(BuildContext context, ProfileModel profile) async {
  final request = await Navigator.of(
    context,
  ).push<ProfileUpdateRequest>(MaterialPageRoute(builder: (_) => EditProfileScreen(profile: profile)));
  if (request != null && context.mounted) {
    context.read<ProfileBloc>().add(UpdateProfile(request));
  }
}

Future<void> _logout(BuildContext context) async {
  await sl<SecureStorageService>().delete(Flags.token);
  await sl<SecureStorageService>().delete(Flags.refreshToken);
  await sl<SecureStorageService>().delete(Flags.user);
  await sl<SecureStorageService>().write(Flags.isLoggedIn, false);
  if (context.mounted) context.go(RouteName.loginView);
}

class _ProfileCard extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback onEdit;
  const _ProfileCard({required this.profile, required this.onEdit});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onEdit,
    borderRadius: BorderRadius.circular(16.r),
    child: Container(
      padding: EdgeInsets.all(18.p),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: AppColor.divider),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          _ProfileAvatar(profile: profile, radius: 34.r),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name.isEmpty ? 'GoaNest guest' : profile.name,
                  style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700, color: AppColor.textPrimary),
                ),
                SizedBox(height: 5.h),
                Text(
                  profile.email.isEmpty ? 'Email not added' : profile.email,
                  style: TextStyle(fontSize: 12.sp, color: AppColor.textSecondary),
                ),
                if (profile.phone.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    profile.phone,
                    style: TextStyle(fontSize: 12.sp, color: AppColor.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          TextButton(onPressed: onEdit, child: const Text('Edit')),
        ],
      ),
    ),
  );
}

class _ProfileAvatar extends StatelessWidget {
  final ProfileModel profile;
  final double radius;
  const _ProfileAvatar({required this.profile, required this.radius});

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radius,
    backgroundColor: AppColor.tertiary,
    backgroundImage: profile.profileImage.isEmpty ? null : NetworkImage(profile.profileImage),
    onBackgroundImageError: profile.profileImage.isEmpty ? null : (_, __) {},
    child: profile.profileImage.isEmpty
        ? Text(
            profile.initials,
            style: TextStyle(color: AppColor.primary, fontSize: radius * .65, fontWeight: FontWeight.w700),
          )
        : null,
  );
}

class _Section extends StatelessWidget {
  final String title;
  final List<_ActionItem> items;
  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 24.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColor.textPrimary),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            border: Border.all(color: AppColor.divider),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(children: [for (var i = 0; i < items.length; i++) items[i].build(i != items.length - 1)]),
        ),
      ],
    ),
  );
}

class _ActionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _ActionItem(this.icon, this.title, this.subtitle, {this.onTap});

  Widget build(bool divider) => Column(
    children: [
      ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
        leading: Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(color: AppColor.tertiary, borderRadius: BorderRadius.circular(10.r)),
          child: Icon(icon, size: 20.sp, color: AppColor.primary),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 11.sp, color: AppColor.textSecondary),
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, size: 21.sp, color: AppColor.textSecondary),
      ),
      if (divider) Divider(height: 1, indent: 66.w, endIndent: 14.w),
    ],
  );
}

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _bioController = TextEditingController(text: widget.profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name and email are required')));
      return;
    }
    Navigator.pop(context, ProfileUpdateRequest(name: name, phone: _phoneController.text.trim(), bio: _bioController.text.trim()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.scaffoldBackground,
    appBar: AppBar(
      title: const Text('Edit profile'),
      backgroundColor: AppColor.scaffoldBackground,
      foregroundColor: AppColor.textPrimary,
      elevation: 0,
      actions: [TextButton(onPressed: _save, child: const Text('Save'))],
    ),
    body: ListView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      children: [
        Center(
          child: _ProfileAvatar(profile: widget.profile, radius: 44.r),
        ),
        SizedBox(height: 26.h),
        _EditField(controller: _nameController, label: 'Name'),
        SizedBox(height: 14.h),
        _EditField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress, readOnly: true),
        SizedBox(height: 14.h),
        _EditField(controller: _phoneController, label: 'Phone number', keyboardType: TextInputType.phone),
        SizedBox(height: 14.h),
        _EditField(controller: _bioController, label: 'Bio', maxLines: 3),
        SizedBox(height: 10.h),
        Text(
          'Email is managed by your account and cannot be changed here.',
          style: TextStyle(fontSize: 11.sp, color: AppColor.textSecondary),
        ),
      ],
    ),
  );
}

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool readOnly;
  final int maxLines;
  const _EditField({required this.controller, required this.label, this.keyboardType, this.readOnly = false, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    readOnly: readOnly,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColor.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
  );
}

void _showLegalDocument(BuildContext context, {required String title, required String body}) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: Text(body)),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
    ),
  );
}

const _termsText =
    'By using GoaNest, you agree to provide accurate account information, respect property rules, and use the platform lawfully. Reservations, cancellations, payments, and guest responsibilities are governed by the terms shown during booking.';

const _privacyText =
    'GoaNest uses your account details to authenticate you, manage reservations, provide search and wishlist features, and improve the service. We do not use your information for purposes unrelated to providing the app experience.';
