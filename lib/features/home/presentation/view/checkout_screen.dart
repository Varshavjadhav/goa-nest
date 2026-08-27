import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';

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
      appBar: AppBar(
        backgroundColor: AppColor.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, size: 20.sp),
        ),
        title: Text(
          'Confirm and pay',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 96.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _StayCard(),
            SizedBox(height: 26.h),
            const _SectionTitle('Your trip'),
            SizedBox(height: 14.h),
            const _TripRow(
              icon: Icons.calendar_month_outlined,
              title: 'Dates',
              value: 'Aug 28 – Sep 1, 2026',
            ),
            const _TripRow(
              icon: Icons.group_outlined,
              title: 'Guests',
              value: '2 guests',
            ),
            Divider(height: 35.h),
            const _SectionTitle('Payment method'),
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
            Text(
              'Price details',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
            const _PriceRow(label: '₹18,500 × 4 nights', value: '₹74,000'),
            const _PriceRow(label: 'Cleaning fee', value: '₹2,500'),
            const _PriceRow(label: 'Service fee', value: '₹4,250'),
            Divider(height: 25.h),
            const _PriceRow(
              label: 'Total (INR)',
              value: '₹80,750',
              bold: true,
            ),
            SizedBox(height: 22.h),
            Text(
              'By selecting the button below, I agree to the house rules, cancellation policy, and Havenstay terms.',
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.45,
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70.h,
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
          decoration: const BoxDecoration(
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.shadow,
                blurRadius: 12,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹80,750',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Total (INR)',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColor.textSecondary,
                      ),
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
                  child: Text(
                    'Confirm and pay',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StayCard extends StatelessWidget {
  const _StayCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(12.p),
    decoration: BoxDecoration(
      color: AppColor.white,
      border: Border.all(color: AppColor.divider),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(7.r),
          child: Image.network(
            'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=300',
            width: 92.w,
            height: 92.w,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 92.w,
              height: 92.w,
              color: AppColor.greyExtraLight,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Modern villa with pool',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Entire villa · North Goa',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColor.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.star, size: 14.sp),
                  SizedBox(width: 3.w),
                  Text(
                    '4.9 · 24 reviews',
                    style: TextStyle(fontSize: 11.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _TripRow extends StatelessWidget {
  final IconData icon;
  final String title, value;
  const _TripRow({
    required this.icon,
    required this.title,
    required this.value,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 18.h),
    child: Row(
      children: [
        Icon(icon, size: 22.sp),
        SizedBox(width: 14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ],
    ),
  );
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
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColor.textQuaternary,
                      ),
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
      const _Input(hint: 'Card number'),
      SizedBox(height: 8.h),
      Row(
        children: [
          const Expanded(child: _Input(hint: 'Expiration date')),
          SizedBox(width: 8.w),
          const Expanded(child: _Input(hint: 'CVV')),
        ],
      ),
      SizedBox(height: 8.h),
      const _Input(hint: 'ZIP code'),
    ],
  );
}

class _Input extends StatelessWidget {
  final String hint;
  const _Input({required this.hint});
  @override
  Widget build(BuildContext context) => TextField(
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 12.sp,
        color: AppColor.hintGrey,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 13.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.r),
        borderSide: const BorderSide(color: AppColor.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.r),
        borderSide: const BorderSide(color: AppColor.divider),
      ),
    ),
  );
}

class _PriceRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _PriceRow({
    required this.label,
    required this.value,
    this.bold = false,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
