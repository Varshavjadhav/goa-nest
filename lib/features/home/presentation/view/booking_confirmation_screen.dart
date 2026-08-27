import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.surface,
    appBar: CommonWidgets.appBar(
      title: 'Booking confirmed',
      onBackTap: () => context.go(RouteName.homeView),
      actions: [
        IconButton(
          onPressed: () => context.go(RouteName.homeView),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    ),
    body: ListView(
      padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 36.h),
      children: [
        Container(
          width: 82.w,
          height: 82.w,
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: const BoxDecoration(
            color: Color(0xffe5f5e8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: AppColor.success,
            size: 48.sp,
          ),
        ),
        AppTextWidget.displaySmall(
          text: 'You\'re all set!',
        ),
        SizedBox(height: 8.h),
        AppTextWidget.titleSmall(
          text: 'Your trip is confirmed. We can\'t wait to host you.',
          color: AppColor.textSecondary,
          height: 1.4,
        ),
        SizedBox(height: 28.h),
        CommonWidgets.appCard(
          padding: EdgeInsets.all(16.p),
          borderRadius: 14,
          borderColor: AppColor.divider,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9.r),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=300',
                      width: 76.w,
                      height: 76.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 76.w,
                        height: 76.w,
                        color: AppColor.greyExtraLight,
                        child: const Icon(Icons.home_outlined),
                      ),
                    ),
                  ),
                  SizedBox(width: 13.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextWidget.titleLarge(
                          text: 'Modern villa with pool',
                        ),
                        SizedBox(height: 5.h),
                        AppTextWidget.bodySmall(
                          text: 'Entire villa · North Goa',
                          color: AppColor.textSecondary,
                        ),
                        SizedBox(height: 7.h),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 15.sp,
                              color: AppColor.goldPlan,
                            ),
                            SizedBox(width: 3.w),
                            AppTextWidget.labelMedium(
                              text: '4.9 · 24 reviews',
                              color: AppColor.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Divider(height: 1),
              ),
              _InfoRow(label: 'Dates', value: 'Aug 28 – Sep 1, 2026'),
              _InfoRow(label: 'Guests', value: '2 guests'),
              _InfoRow(
                label: 'Total paid',
                value: '₹80,750',
                bold: true,
              ),
            ],
          ),
        ),
        SizedBox(height: 22.h),
        CommonWidgets.primaryButton(
          label: 'Explore more stays',
          onTap: () => context.go(RouteName.homeView),
          height: 52,
        ),
        SizedBox(height: 24.h),
        Center(
          child: AppTextWidget.bodySmall(
            text: 'Confirmation code: HN7K4P',
            color: AppColor.textSecondary,
            letterSpacing: .4,
          ),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _InfoRow({required this.label, required this.value, this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 11.h),
    child: Row(
      children: [
        Expanded(
          child: AppTextWidget.bodyMedium(
            text: label,
            color: AppColor.textSecondary,
          ),
        ),
        AppTextWidget(
          text: value,
          fontSize: 13,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          color: AppColor.textPrimary,
        ),
      ],
    ),
  );
}
