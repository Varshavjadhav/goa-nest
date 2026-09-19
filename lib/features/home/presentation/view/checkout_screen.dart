import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? guests;
  final double? total;
  final String propertyId;
  final String propertyTitle;

  const CheckoutScreen({
    super.key,
    this.checkIn,
    this.checkOut,
    this.guests,
    this.total,
    this.propertyId = '',
    this.propertyTitle = 'Your stay',
  });
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int paymentMethod = 0;
  bool paymentStarted = false;
  @override
  Widget build(BuildContext context) {
    final checkIn = widget.checkIn ?? DateTime.now();
    final checkOut = widget.checkOut ?? checkIn.add(const Duration(days: 1));
    final nights = checkOut.difference(checkIn).inDays.clamp(1, 365);
    final total = widget.total ?? 0;
    final roomAmount = total * .87;
    final cleaningFee = total * .05;
    final serviceFee = total * .08;
    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        backgroundColor: AppColor.scaffoldBackground,
        appBar: CommonWidgets.appBar(
          title: 'Confirm and pay',
          showBack: false,
          actions: [
            IconButton(
              onPressed: () => _leaveCheckout(context),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 96.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryCard(checkIn, checkOut, total, nights),
              SizedBox(height: 22.h),
              AppTextWidget.headlineSmall(text: 'Price details'),
              SizedBox(height: 14.h),
              CommonWidgets.priceRow(
                label: '$nights nights × ₹${(roomAmount / nights).round()}',
                value: '₹${roomAmount.round()}',
              ),
              TextButton(
                onPressed: () => _showPriceDetails(
                  roomAmount,
                  cleaningFee,
                  serviceFee,
                  total,
                ),
                child: AppTextWidget.bodyMedium(
                  text: 'Price breakdown',
                  textDecoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 12.w),
                color: const Color(0xFFF1F1F1),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: AppTextWidget.bodyMedium(
                        text:
                            'Free cancellation before ${_shortDate(checkIn.subtract(const Duration(days: 1)))}',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              AppTextWidget.bodyMedium(
                text:
                    'You’ll be directed to payment to complete your reservation.',
                color: AppColor.textSecondary,
              ),
              SizedBox(height: 14.h),
              AppTextWidget.labelMedium(
                text:
                    'By selecting the button below, I agree to the booking terms.',
                color: AppColor.textSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        bottomNavigationBar: CommonWidgets.bottomBar(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextWidget.labelLarge(text: 'Total (INR)'),
                  AppTextWidget.titleLarge(text: '₹${total.round()}'),
                ],
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => _continueToPayment(total, checkIn, checkOut),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    elevation: 0,
                    minimumSize: Size(double.infinity, 52.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: AppTextWidget(
                    text: 'Continue to payment',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(
    DateTime checkIn,
    DateTime checkOut,
    double total,
    int nights,
  ) => Container(
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(18.r),
      border: Border.all(color: AppColor.divider),
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=300',
                width: 92.w,
                height: 92.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 92.w,
                  height: 92.w,
                  color: AppColor.greyExtraLight,
                  child: Icon(Icons.home_outlined, size: 28.sp),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget.titleLarge(
                    text: widget.propertyTitle,
                    maxLines: 3,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 17.sp),
                      SizedBox(width: 4.w),
                      AppTextWidget.bodyMedium(text: '5.0 (6)'),
                      SizedBox(width: 12.w),
                      Icon(Icons.workspace_premium_outlined, size: 17.sp),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: AppTextWidget.bodyMedium(
                          text: 'Guest favourite',
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(height: 28.h),
        _changeRow(
          'Dates',
          '${_shortDate(checkIn)} – ${_shortDate(checkOut)}',
          () => context.pop(),
        ),
        Divider(height: 24.h),
        _changeRow(
          'Guests',
          '${widget.guests ?? 1} guest${(widget.guests ?? 1) == 1 ? '' : 's'}',
          () => context.pop(),
        ),
        Divider(height: 24.h),
        _changeRow(
          'Total price',
          '₹${total.toStringAsFixed(2)} including taxes INR',
          () => _showPriceDetails(total * .87, total * .05, total * .08, total),
        ),
        Divider(height: 24.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.titleMedium(text: 'Free cancellation'),
              SizedBox(height: 5.h),
              AppTextWidget.bodyMedium(
                text:
                    'Cancel before ${_shortDate(checkIn.subtract(const Duration(days: 1)))} for a full refund.',
              ),
              SizedBox(height: 4.h),
              AppTextWidget.bodyMedium(
                text: 'Full policy',
                textDecoration: TextDecoration.underline,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _changeRow(String label, String value, VoidCallback onChange) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextWidget.titleMedium(text: label),
            SizedBox(height: 5.h),
            AppTextWidget.bodyLarge(text: value),
          ],
        ),
      ),
      TextButton(
        onPressed: onChange,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFF2F2F2),
          foregroundColor: AppColor.textPrimary,
          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 11.h),
        ),
        child: AppTextWidget.titleSmall(
          text: label == 'Total price' ? 'Details' : 'Change',
        ),
      ),
    ],
  );

  Future<void> _showPriceDetails(
    double roomAmount,
    double cleaningFee,
    double serviceFee,
    double total,
  ) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.close),
              ),
            ),
            AppTextWidget.headlineMedium(text: 'Price details'),
            SizedBox(height: 24.h),
            CommonWidgets.priceRow(
              label: 'Accommodation',
              value: '₹${roomAmount.toStringAsFixed(2)}',
            ),
            CommonWidgets.priceRow(
              label: 'Cleaning fee',
              value: '₹${cleaningFee.toStringAsFixed(2)}',
            ),
            CommonWidgets.priceRow(
              label: 'Service fee',
              value: '₹${serviceFee.toStringAsFixed(2)}',
            ),
            CommonWidgets.divider(height: 24),
            CommonWidgets.priceRow(
              label: 'Total INR',
              value: '₹${total.toStringAsFixed(2)}',
              bold: true,
            ),
            SizedBox(height: 8.h),
            AppTextWidget.bodyMedium(
              text: 'Price breakdown',
              textDecoration: TextDecoration.underline,
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _continueToPayment(
    double total,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    setState(() => paymentStarted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: AppTextWidget.legacy('Opening secure payment...'),
      ),
    );
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.white,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.headlineSmall(text: 'Choose a payment method'),
              SizedBox(height: 14.h),
              _PaymentOption(
                icon: Icons.credit_card,
                title: 'Credit or debit card',
                subtitle: 'Visa, Mastercard, RuPay',
                selected: paymentMethod == 0,
                onTap: () => setSheetState(() => paymentMethod = 0),
                child: const _CardFields(),
              ),
              _PaymentOption(
                icon: Icons.account_balance_wallet_outlined,
                title: 'UPI',
                subtitle: 'Google Pay, PhonePe, Paytm',
                selected: paymentMethod == 1,
                onTap: () => setSheetState(() => paymentMethod = 1),
              ),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(
                      RouteName.bookingConfirmationView.replaceFirst(
                        ':propertyId',
                        widget.propertyId.isEmpty
                            ? 'property'
                            : widget.propertyId,
                      ),
                    );
                  },
                  child: AppTextWidget(
                    text: 'Pay ₹${total.round()}',
                    color: AppColor.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (mounted) setState(() => paymentStarted = false);
  }

  Future<bool> _confirmExit() async {
    if (paymentStarted) return true;
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: AppTextWidget.titleLarge(text: 'Continue payment?'),
        content: AppTextWidget.bodyMedium(
          text:
              'Your reservation is not paid yet. Do you want to continue payment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: AppTextWidget.bodyMedium(text: 'Leave'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: AppTextWidget.bodyMedium(
              text: 'Continue payment',
              color: AppColor.white,
            ),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  void _leaveCheckout(BuildContext context) async {
    if (await _confirmExit() && context.mounted) context.pop();
  }

  static String _shortDate(DateTime value) =>
      '${_month(value.month)} ${value.day}, ${value.year}';

  static String _month(int month) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];
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
