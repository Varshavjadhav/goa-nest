import 'package:flutter/material.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColor.surface,
    child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 105.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 20.h),
              const _ProfileCard(),
              SizedBox(height: 16.h),
              const _HostBanner(),
              SizedBox(height: 28.h),
              const _Section(
                title: 'Account',
                items: [
                  _ActionItem(
                    Icons.person_outline_rounded,
                    'Personal information',
                    'Manage your name, email, and phone',
                  ),
                  _ActionItem(
                    Icons.credit_card_outlined,
                    'Payments and payouts',
                    'Manage payment methods',
                  ),
                  _ActionItem(
                    Icons.notifications_none_rounded,
                    'Notifications',
                    'Choose what you want to hear about',
                  ),
                ],
              ),
              const _Section(
                title: 'Preferences',
                items: [
                  _ActionItem(
                    Icons.language_rounded,
                    'Language and currency',
                    'English · INR',
                  ),
                  _ActionItem(
                    Icons.lock_outline_rounded,
                    'Privacy and sharing',
                    'Control your privacy settings',
                  ),
                ],
              ),
              const _Section(
                title: 'Support',
                items: [
                  _ActionItem(
                    Icons.help_outline_rounded,
                    'Help Center',
                    'Get help with your reservation',
                  ),
                  _ActionItem(
                    Icons.shield_outlined,
                    'Safety information',
                    'Learn about staying safe',
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.textPrimary,
                  minimumSize: Size.fromHeight(52.h),
                  side: const BorderSide(color: AppColor.divider),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Center(
                child: Text(
                  'GoNest v1.0.0',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColor.textSecondary,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    ),
  );
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(18.p),
    decoration: BoxDecoration(
      color: AppColor.white,
      border: Border.all(color: AppColor.divider),
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 34.r,
          backgroundImage: const NetworkImage('https://i.pravatar.cc/140?img=47'),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alex Johnson',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'alex.johnson@email.com',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColor.textSecondary,
                ),
              ),
              SizedBox(height: 9.h),
              Row(
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 15.sp,
                    color: AppColor.success,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Verified guest',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          color: AppColor.textSecondary,
        ),
      ],
    ),
  );
}

class _HostBanner extends StatelessWidget {
  const _HostBanner();
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(17.p),
    decoration: BoxDecoration(
      color: AppColor.tertiary,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Row(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: const BoxDecoration(
            color: AppColor.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.home_work_outlined,
            color: AppColor.primary,
          ),
        ),
        SizedBox(width: 13.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch to hosting',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Share your space and earn extra income.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColor.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_rounded,
          size: 20.sp,
          color: AppColor.primary,
        ),
      ],
    ),
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
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            border: Border.all(color: AppColor.divider),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                items[i].build(i != items.length - 1),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ActionItem {
  final IconData icon;
  final String title, subtitle;
  const _ActionItem(this.icon, this.title, this.subtitle);
  Widget build(bool divider) => Column(
    children: [
      ListTile(
        onTap: () {},
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 5.h,
        ),
        leading: Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            color: AppColor.tertiary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20.sp, color: AppColor.primary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColor.textSecondary,
            ),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 21.sp,
          color: AppColor.textSecondary,
        ),
      ),
      if (divider)
        Divider(
          height: 1,
          indent: 66.w,
          endIndent: 14.w,
        ),
    ],
  );
}
