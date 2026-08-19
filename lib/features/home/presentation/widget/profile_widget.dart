import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return ColoredBox(
      color: theme.background,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.p, 18.h, 16.p, 96.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _ProfileTopBar(),
                  Gap(22.h),
                  const _Avatar(),
                  Gap(18.h),
                  AppTextWidget(
                    text: 'Savio Fernandes',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: theme.textPrimary,
                    textAlign: TextAlign.center,
                  ),
                  Gap(6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.workspace_premium_rounded,
                        color: theme.textSecondary,
                        size: 14.sp,
                      ),
                      Gap(6.w),
                      AppTextWidget(
                        text: 'Platinum Member since 2021',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.textSecondary,
                      ),
                    ],
                  ),
                  Gap(24.h),
                  const _StatsCard(),
                  Gap(30.h),
                  const _MenuCard(),
                  Gap(20.h),
                  const _SignOutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar();

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    Widget icon(IconData data) => SizedBox(
          width: 34.w,
          height: 34.w,
          child: Icon(data, color: theme.textPrimary, size: 20.sp),
        );

    return Row(
      children: [
        icon(Icons.menu_rounded),
        const Spacer(),
        AppTextWidget(
          text: 'Profile',
          fontSize: 21.sp,
          fontWeight: FontWeight.w800,
          color: theme.textPrimary,
        ),
        const Spacer(),
        icon(Icons.notifications_none_rounded),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Center(
      child: SizedBox(
        width: 124.w,
        height: 124.w,
        child: Stack(
          children: [
            Container(
              width: 124.w,
              height: 124.w,
              decoration: BoxDecoration(
                color: theme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: theme.surface, width: 3.w),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: 0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_rounded,
                color: theme.textTertiary,
                size: 64.sp,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: theme.brandPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.background, width: 2.5.w),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColor.white,
                  size: 17.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  static const _stats = [
    (value: '2', label: 'TRIPS'),
    (value: '4', label: 'NIGHTS'),
    (value: '2', label: 'PLACES'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.p, vertical: 22.h),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.divider),
      ),
      child: Row(
        children: List.generate(_stats.length, (index) {
          final stat = _stats[index];
          return Expanded(
            child: Column(
              children: [
                AppTextWidget(
                  text: stat.value,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: theme.brandPrimary,
                ),
                Gap(5.h),
                AppTextWidget(
                  text: stat.label,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: theme.textTertiary,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard();

  static const _items = [
    (icon: Icons.person_outline_rounded, title: 'Personal Info'),
    (icon: Icons.receipt_long_outlined, title: 'My Bookings'),
    (icon: Icons.favorite_border_rounded, title: 'Saved Properties'),
    (icon: Icons.credit_card_rounded, title: 'Payment Methods'),
    (icon: Icons.help_outline_rounded, title: 'Help & Support'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.p, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.divider),
      ),
      child: Column(
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 13.h),
            child: Row(
              children: [
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: theme.containerBg,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Icon(item.icon, color: theme.textSecondary, size: 20.sp),
                ),
                Gap(15.w),
                Expanded(
                  child: AppTextWidget(
                    text: item.title,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.textPrimary,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.textTertiary,
                  size: 22.sp,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: theme.brandPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, color: theme.brandPrimary, size: 18.sp),
          Gap(8.w),
          AppTextWidget(
            text: 'Sign Out',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: theme.brandPrimary,
          ),
        ],
      ),
    );
  }
}
