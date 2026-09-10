import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int paymentMethod = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: CommonWidgets.appBar(
        title: 'Confirm and pay',
        onBackTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 96.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets.stayCard(
              imageUrl:
                  'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=300',
              title: 'Modern villa with pool',
              subtitle: 'Entire villa · North Goa',
              rating: '4.9 · 24 reviews',
            ),
            SizedBox(height: 26.h),
            CommonWidgets.sectionTitle('Your trip'),
            SizedBox(height: 14.h),
            CommonWidgets.tripRow(
              icon: Icons.calendar_month_outlined,
              title: 'Dates',
              value: 'Aug 28 – Sep 1, 2026',
            ),
            CommonWidgets.tripRow(
              icon: Icons.group_outlined,
              title: 'Guests',
              value: '2 guests',
            ),
            CommonWidgets.divider(),
            CommonWidgets.sectionTitle('Payment method'),
            SizedBox(height: 12.h),
            _PaymentOption(
              icon: Icons.credit_card,
              title: 'Credit or debit card',
              subtitle: 'Visa, Mastercard, RuPay',
              selected: paymentMethod == 0,
              onTap: () => setState(() => paymentMethod = 0),
              child: const _CardFields(),
            ),
            _PaymentOption(
              icon: Icons.account_balance_wallet_outlined,
              title: 'UPI',
              subtitle: 'Google Pay, PhonePe, Paytm',
              selected: paymentMethod == 1,
              onTap: () => setState(() => paymentMethod = 1),
            ),
            _PaymentOption(
              icon: Icons.payments_outlined,
              title: 'Cash or bank transfer',
              subtitle: 'Pay securely at confirmation',
              selected: paymentMethod == 2,
              onTap: () => setState(() => paymentMethod = 2),
            ),
            SizedBox(height: 20.h),
            CommonWidgets.sectionTitle('Price details'),
            SizedBox(height: 14.h),
            CommonWidgets.priceRow(
              label: '₹18,500 × 4 nights',
              value: '₹74,000',
            ),
            CommonWidgets.priceRow(label: 'Cleaning fee', value: '₹2,500'),
            CommonWidgets.priceRow(label: 'Service fee', value: '₹4,250'),
            CommonWidgets.divider(height: 25),
            CommonWidgets.priceRow(
              label: 'Total (INR)',
              value: '₹80,750',
              bold: true,
            ),
            SizedBox(height: 22.h),
            AppTextWidget.labelMedium(
              text:
                  'By selecting the button below, I agree to the house rules, cancellation policy, and Havenstay terms.',
              color: AppColor.textSecondary,
              height: 1.45,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonWidgets.bottomBar(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextWidget.titleLarge(text: '₹80,750'),
                  AppTextWidget.labelMedium(
                    text: 'Total (INR)',
                    color: AppColor.textSecondary,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => context.push(
                  RouteName.bookingConfirmationView.replaceFirst(
                    ':propertyId',
                    'modern-villa',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: AppTextWidget(
                  text: 'Confirm and pay',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColor.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final bool selected;
  final VoidCallback onTap;
  final Widget? child;
  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.child,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(9.r),
    child: Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(13.p),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(
          color: selected ? AppColor.primary : AppColor.divider,
          width: selected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 22.sp),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget(
                      text: title,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 3.h),
                    AppTextWidget.labelMedium(
                      text: subtitle,
                      color: AppColor.textQuaternary,
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColor.primary : AppColor.greyMedium,
                size: 20.sp,
              ),
            ],
          ),
          if (selected && child != null)
            Padding(
              padding: EdgeInsets.only(top: 13.h),
              child: child!,
            ),
        ],
      ),
    ),
  );
}

class _CardFields extends StatelessWidget {
  const _CardFields();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextField(decoration: CommonWidgets.inputDecoration(hint: 'Card number')),
      SizedBox(height: 8.h),
      Row(
        children: [
          Expanded(
            child: TextField(
              decoration: CommonWidgets.inputDecoration(
                hint: 'Expiration date',
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              decoration: CommonWidgets.inputDecoration(hint: 'CVV'),
            ),
          ),
        ],
      ),
      SizedBox(height: 8.h),
      TextField(decoration: CommonWidgets.inputDecoration(hint: 'ZIP code')),
    ],
  );
}
