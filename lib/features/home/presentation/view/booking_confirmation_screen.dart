import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.surface,
    appBar: AppBar(
      backgroundColor: AppColor.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.go(RouteName.homeView),
        icon: const Icon(Icons.close_rounded),
      ),
      title: Text(
        'Booking confirmed',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
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
        Text(
          'You\'re all set!',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Your trip is confirmed. We can\'t wait to host you.',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColor.textSecondary,
            height: 1.4,
          ),
        ),
        SizedBox(height: 28.h),
        const _BookingCard(),
        SizedBox(height: 22.h),
        SizedBox(
          height: 52.h,
          child: ElevatedButton(
            onPressed: () => context.go(RouteName.homeView),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'Explore more stays',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Center(
          child: Text(
            'Confirmation code: HN7K4P',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColor.textSecondary,
              letterSpacing: .4,
            ),
          ),
        ),
      ],
    ),
  );
}

class _BookingCard extends StatelessWidget {
  const _BookingCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.p),
    decoration: BoxDecoration(
      color: AppColor.white,
      border: Border.all(color: AppColor.divider),
      borderRadius: BorderRadius.circular(14.r),
    ),
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
                  Text(
                    'Modern villa with pool',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Entire villa · North Goa',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColor.textSecondary,
                    ),
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
                      Text(
                        '4.9 · 24 reviews',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColor.textSecondary,
                        ),
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
        const _InfoRow(label: 'Dates', value: 'Aug 28 – Sep 1, 2026'),
        const _InfoRow(label: 'Guests', value: '2 guests'),
        const _InfoRow(
          label: 'Total paid',
          value: '₹80,750',
          bold: true,
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
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColor.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: AppColor.textPrimary,
          ),
        ),
      ],
    ),
  );
}
