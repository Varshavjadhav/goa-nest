import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/utils.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';
import 'package:goanest/core/di/injector.dart';
import 'package:goanest/features/home/data/model/booking_model.dart';
import 'package:goanest/features/home/domain/usecase/booking_usecases.dart';

class CheckoutScreen extends StatefulWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? guests;
  final int rooms;
  final double? total;
  final double? accommodationAmount;
  final double? cleaningFee;
  final double? serviceFee;
  final double? tax;
  final String propertyId;
  final String propertyTitle;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String location;

  const CheckoutScreen({
    super.key,
    this.checkIn,
    this.checkOut,
    this.guests,
    this.rooms = 1,
    this.total,
    this.accommodationAmount,
    this.cleaningFee,
    this.serviceFee,
    this.tax,
    this.propertyId = '',
    this.propertyTitle = 'Your stay',
    this.imageUrl = '',
    this.rating = 0,
    this.reviewCount = 0,
    this.location = '',
  });
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isSubmitting = false;
  @override
  Widget build(BuildContext context) {
    final checkIn = widget.checkIn ?? DateTime.now();
    final checkOut = widget.checkOut ?? checkIn.add(const Duration(days: 1));
    final nights = checkOut.difference(checkIn).inDays.clamp(1, 365);
    final total = widget.total ?? 0;
    final roomAmount = widget.accommodationAmount ?? total;
    final cleaningFee = widget.cleaningFee ?? 0;
    final serviceFee = widget.serviceFee ?? 0;
    final tax = widget.tax ?? 0;
    return PopScope(
      canPop: !isSubmitting,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && !isSubmitting) await _leaveCheckout(context);
      },
      child: Scaffold(
        backgroundColor: AppColor.scaffoldBackground,
        appBar: CommonWidgets.appBar(
          title: 'Confirm reservation',
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
              _summaryCard(
                checkIn,
                checkOut,
                total,
                nights,
                roomAmount,
                cleaningFee,
                serviceFee,
                tax,
              ),
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
                  tax,
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
                    'Confirm your reservation for the selected dates and guest count.',
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
                  onPressed: isSubmitting
                      ? null
                      : () => _createBooking(checkIn, checkOut),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    elevation: 0,
                    minimumSize: Size(double.infinity, 52.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: isSubmitting
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.white,
                          ),
                        )
                      : AppTextWidget(
                          text: 'Confirm reservation',
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
    double roomAmount,
    double cleaningFee,
    double serviceFee,
    double tax,
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
              child: widget.imageUrl.isEmpty
                  ? Container(
                      width: 92.w,
                      height: 92.w,
                      color: AppColor.greyExtraLight,
                      child: Icon(Icons.home_outlined, size: 28.sp),
                    )
                  : Image.network(
                      widget.imageUrl,
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
                      AppTextWidget.bodyMedium(
                        text: widget.rating > 0
                            ? '${widget.rating.toStringAsFixed(1)} (${widget.reviewCount})'
                            : 'No reviews yet',
                      ),
                      SizedBox(width: 12.w),
                      Icon(Icons.workspace_premium_outlined, size: 17.sp),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: AppTextWidget.bodyMedium(
                          text: widget.location.isEmpty
                              ? 'GoaNest stay'
                              : widget.location,
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
          () => _showPriceDetails(
            roomAmount,
            cleaningFee,
            serviceFee,
            tax,
            total,
          ),
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
                    'Cancellation terms depend on the host’s policy. Review the property details before confirming.',
              ),
              SizedBox(height: 4.h),
              AppTextWidget.bodyMedium(
                text: 'View property details for house rules.',
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
    double tax,
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
            CommonWidgets.priceRow(
              label: 'Taxes',
              value: '₹${tax.toStringAsFixed(2)}',
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

  Future<void> _createBooking(DateTime checkIn, DateTime checkOut) async {
    setState(() => isSubmitting = true);
    final result = await sl<CreateBookingUseCase>()(
      CreateBookingRequest(
        propertyId: widget.propertyId,
        checkIn: checkIn,
        checkOut: checkOut,
        adults: widget.guests ?? 1,
        rooms: widget.rooms,
      ),
    );
    if (!mounted) return;
    setState(() => isSubmitting = false);
    result.fold(
      (failure) => Utils.showSnackBar(
        failure.message,
        result: Result.error,
      ),
      (booking) => context.push(
        RouteName.bookingConfirmationView.replaceFirst(
          ':propertyId',
          booking.propertyId.isEmpty ? widget.propertyId : booking.propertyId,
        ),
        extra: booking,
      ),
    );
  }

  Future<void> _leaveCheckout(BuildContext context) async {
    if (context.mounted) context.pop();
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
