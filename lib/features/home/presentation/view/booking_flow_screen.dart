import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/core/di/injector.dart';
import 'package:goanest/features/home/data/model/booking_model.dart';
import 'package:goanest/features/home/domain/usecase/check_availability.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/utilities/utils.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

class BookingFlowScreen extends StatefulWidget {
  final String propertyId;
  final String propertyTitle;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String location;
  final double nightlyPrice;
  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;
  final int initialGuests;
  final int initialRooms;
  final bool useAvailabilityApi;

  const BookingFlowScreen({
    super.key,
    required this.propertyId,
    this.propertyTitle = 'Your stay',
    this.imageUrl = '',
    this.rating = 0,
    this.reviewCount = 0,
    this.location = '',
    this.nightlyPrice = 0,
    this.initialCheckIn,
    this.initialCheckOut,
    this.initialGuests = 1,
    this.initialRooms = 1,
    this.useAvailabilityApi = false,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  DateTime? checkIn;
  DateTime? checkOut;
  late int guests;
  int rooms = 1;
  AvailabilityResult? availability;
  String? error;
  bool checking = false;

  @override
  void initState() {
    super.initState();
    checkIn = widget.initialCheckIn;
    checkOut = widget.initialCheckOut;
    guests = widget.initialGuests < 1 ? 1 : widget.initialGuests;
    rooms = widget.initialRooms < 1 ? 1 : widget.initialRooms;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.scaffoldBackground,
    appBar: CommonWidgets.appBar(
      title: 'Choose dates and guests',
      onBackTap: context.pop,
    ),
    body: ListView(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 110.h),
      children: [
        _heroHeader(),
        SizedBox(height: 18.h),
        _section(
          title: 'Dates',
          child: CalendarDatePicker(
            initialDate: checkIn ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 730)),
            onDateChanged: _selectDate,
          ),
        ),
        SizedBox(height: 14.h),
        _dateSummary(),
        SizedBox(height: 14.h),
        _section(
          title: 'Guests and rooms',
          child: Column(
            children: [
              _counter(
                label: 'Guests',
                value: guests,
                onMinus: guests > 1 ? () => setState(() => guests--) : null,
                onPlus: () => setState(() => guests++),
              ),
              const Divider(height: 1),
              _counter(
                label: 'Rooms',
                value: rooms,
                onMinus: rooms > 1 ? () => setState(() => rooms--) : null,
                onPlus: () => setState(() => rooms++),
              ),
            ],
          ),
        ),
        if (error != null) ...[
          SizedBox(height: 14.h),
          _message(error!, isError: true),
        ],
        if (availability != null) ...[
          SizedBox(height: 14.h),
          _availabilitySummary(availability!),
        ],
      ],
    ),
    bottomNavigationBar: SafeArea(
      child: CommonWidgets.bottomBar(
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: .12),
            blurRadius: 24,
            spreadRadius: -4,
            offset: const Offset(0, -8),
          ),
        ],
        child: Row(
          children: [
            Expanded(
              child: AppTextWidget.bodySmall(
                text: checkIn == null || checkOut == null
                    ? 'Select your dates'
                    : availability?.available == true
                    ? 'Dates are available'
                    : 'Check availability first',
                color: AppColor.textSecondary,
              ),
            ),
            SizedBox(
              width: 178.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: checking
                    ? null
                    : availability?.available == true
                    ? _continueToCheckout
                    : _checkAvailability,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: checking
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.white,
                        ),
                      )
                    : AppTextWidget(
                        text: availability?.available == true
                            ? availability!.bookingType == 'instant'
                                  ? 'Reserve'
                                  : 'Request to book'
                            : 'Check availability',
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

  Widget _heroHeader() {
    final theme = context.themeExt;
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 18.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.brandPrimary,
            theme.brandPrimary.withValues(alpha: .78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: theme.brandPrimary.withValues(alpha: .22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18.w,
            top: -28.h,
            child: Icon(
              Icons.home_work_rounded,
              size: 118.sp,
              color: AppColor.white.withValues(alpha: .1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.p),
                    decoration: BoxDecoration(
                      color: AppColor.white.withValues(alpha: .16),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(
                      Icons.luggage_rounded,
                      color: AppColor.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  AppTextWidget(
                    text: 'PLAN YOUR STAY',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: AppColor.white.withValues(alpha: .82),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              AppTextWidget(
                text: widget.propertyTitle,
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: AppColor.white,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5.h),
              AppTextWidget(
                text: 'Choose dates and guests to see your total',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColor.white.withValues(alpha: .84),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) => Container(
    decoration: BoxDecoration(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: AppColor.divider.withValues(alpha: .7)),
      boxShadow: [
        BoxShadow(
          color: AppColor.black.withValues(alpha: .075),
          blurRadius: 20,
          spreadRadius: -5,
          offset: const Offset(0, 9),
        ),
        BoxShadow(
          color: AppColor.black.withValues(alpha: .025),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 9.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: context.themeExt.brandPrimary,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 8.w),
            AppTextWidget.titleMedium(text: title),
          ],
        ),
        SizedBox(height: 10.h),
        child,
      ],
    ),
  );

  Widget _dateSummary() => Row(
    children: [
      Expanded(child: _dateTile('Check-in', checkIn)),
      SizedBox(width: 10.w),
      Expanded(child: _dateTile('Check-out', checkOut)),
    ],
  );

  Widget _dateTile(String label, DateTime? date) => Container(
    padding: EdgeInsets.all(13.w),
    decoration: BoxDecoration(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: AppColor.primaryLight.withValues(alpha: .7)),
      boxShadow: [
        BoxShadow(
          color: AppColor.primary.withValues(alpha: .07),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              label == 'Check-in' ? Icons.login_rounded : Icons.logout_rounded,
              color: AppColor.primary,
              size: 14.sp,
            ),
            SizedBox(width: 5.w),
            AppTextWidget.labelSmall(
              text: label,
              color: AppColor.textSecondary,
            ),
          ],
        ),
        SizedBox(height: 4.h),
        AppTextWidget.titleSmall(text: date == null ? 'Add date' : _date(date)),
      ],
    ),
  );

  Widget _counter({
    required String label,
    required int value,
    required VoidCallback? onMinus,
    required VoidCallback onPlus,
  }) => Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Row(
      children: [
        Expanded(child: AppTextWidget.bodyLarge(text: label)),
        _counterButton(icon: Icons.remove_rounded, onPressed: onMinus),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: AppTextWidget.titleMedium(text: '$value'),
        ),
        _counterButton(icon: Icons.add_rounded, onPressed: onPlus),
      ],
    ),
  );

  Widget _counterButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) => Container(
    width: 34.w,
    height: 34.w,
    decoration: BoxDecoration(
      color: onPressed == null
          ? AppColor.greyLight
          : AppColor.primary.withValues(alpha: .1),
      shape: BoxShape.circle,
      border: Border.all(
        color: onPressed == null
            ? AppColor.divider
            : AppColor.primary.withValues(alpha: .2),
      ),
    ),
    child: IconButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18.sp,
        color: onPressed == null ? AppColor.grey : AppColor.primary,
      ),
    ),
  );

  Widget _availabilitySummary(AvailabilityResult result) => _section(
    title: result.available ? 'Booking summary' : 'Not available',
    child: result.available
        ? Column(
            children: [
              _priceRow('Nightly price', result.nightlyAmount),
              _priceRow('Cleaning fee', result.cleaningFee),
              _priceRow('Service fee', result.serviceFee),
              _priceRow('Taxes', result.tax),
              if (result.discount > 0) _priceRow('Discount', -result.discount),
              const Divider(),
              _priceRow('Total', result.totalAmount, bold: true),
            ],
          )
        : _message(
            result.message.isEmpty
                ? 'These dates are not available.'
                : result.message,
            isError: true,
          ),
  );

  Widget _priceRow(String label, double amount, {bool bold = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AppTextWidget.bodyMedium(text: label),
      AppTextWidget(
        text: '₹${amount.toStringAsFixed(0)}',
        fontSize: 14,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      ),
    ],
  );

  Widget _message(String text, {required bool isError}) => Container(
    padding: EdgeInsets.all(13.w),
    decoration: BoxDecoration(
      color: isError ? const Color(0xFFFFF1F1) : AppColor.white,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: AppTextWidget.bodyMedium(text: text, color: AppColor.textPrimary),
  );

  void _selectDate(DateTime value) {
    setState(() {
      availability = null;
      error = null;
      if (checkIn == null || checkOut != null) {
        checkIn = value;
        checkOut = null;
      } else if (value.isAfter(checkIn!)) {
        checkOut = value;
      } else {
        checkIn = value;
        checkOut = null;
      }
    });
  }

  Future<void> _checkAvailability() async {
    if (checkIn == null || checkOut == null) {
      setState(() => error = 'Select both check-in and check-out dates.');
      return;
    }
    if (!checkOut!.isAfter(checkIn!)) {
      setState(() => error = 'Check-out must be after check-in.');
      return;
    }
    if (guests < 1 || rooms < 1) {
      setState(() => error = 'Select at least one guest and one room.');
      return;
    }
    setState(() {
      checking = true;
      error = null;
    });
    if (!widget.useAvailabilityApi) {
      final nights = checkOut!.difference(checkIn!).inDays;
      final nightly = widget.nightlyPrice;
      final roomTotal = nightly * nights * rooms;
      final cleaning = roomTotal * .05;
      final service = roomTotal * .08;
      final tax = (roomTotal + cleaning + service) * .05;
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      setState(() {
        checking = false;
        availability = AvailabilityResult(
          available: true,
          bookingType: 'instant',
          nightlyAmount: nightly,
          cleaningFee: cleaning,
          serviceFee: service,
          tax: tax,
          totalAmount: roomTotal + cleaning + service + tax,
          message: 'Available for testing',
        );
      });
      if (mounted) {
        Utils.showSnackBar(
          'Dates available. You can reserve this stay.',
          result: Result.success,
        );
      }
      return;
    }
    final result = await sl<CheckAvailabilityUseCase>()(
      AvailabilityRequest(
        propertyId: widget.propertyId,
        checkIn: checkIn!,
        checkOut: checkOut!,
        guests: guests,
        rooms: rooms,
      ),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        checking = false;
        error = failure.message;
      }),
      (value) {
        setState(() {
          checking = false;
          availability = value;
        });
        if (!value.available) {
          _showUnavailableDialog(
            value.message.isEmpty
                ? 'This property is not available for the selected dates.'
                : value.message,
          );
        } else {
          Utils.showSnackBar(
            value.message.isEmpty
                ? 'These dates are available to book.'
                : value.message,
            result: Result.success,
          );
        }
      },
    );
  }

  Future<void> _showUnavailableDialog(String message) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: AppTextWidget.titleLarge(text: 'Dates not available'),
      content: AppTextWidget.bodyMedium(text: message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            setState(() => availability = null);
          },
          child: AppTextWidget.bodyMedium(text: 'Change dates'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            context.pop();
          },
          child: AppTextWidget.bodyMedium(
            text: 'View similar stays',
            color: AppColor.white,
          ),
        ),
      ],
    ),
  );

  void _continueToCheckout() {
    final result = availability!;
    final query = <String, String>{
      'checkIn': _isoDate(checkIn!),
      'checkOut': _isoDate(checkOut!),
      'guests': guests.toString(),
      'rooms': rooms.toString(),
      'total': result.totalAmount.toStringAsFixed(0),
      'accommodation':
          (result.nightlyAmount * checkOut!.difference(checkIn!).inDays)
              .toStringAsFixed(0),
      'cleaningFee': result.cleaningFee.toStringAsFixed(0),
      'serviceFee': result.serviceFee.toStringAsFixed(0),
      'tax': result.tax.toStringAsFixed(0),
      'title': widget.propertyTitle,
      if (widget.imageUrl.isNotEmpty) 'image': widget.imageUrl,
      'rating': widget.rating.toString(),
      'reviewCount': widget.reviewCount.toString(),
      'location': widget.location,
    };
    Utils.showSnackBar(
      'Dates are available. Review your reservation.',
      result: Result.success,
      duration: 1,
    );
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      context.pushNamed(
        'checkout',
        pathParameters: {'propertyId': widget.propertyId},
        queryParameters: query,
      );
    });
  }

  static String _isoDate(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';

  static String _date(DateTime value) =>
      '${value.day}/${value.month}/${value.year}';
}
