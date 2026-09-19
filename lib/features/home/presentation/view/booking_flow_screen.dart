import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/core/di/injector.dart';
import 'package:goanest/features/home/data/model/booking_model.dart';
import 'package:goanest/features/home/domain/usecase/check_availability.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

class BookingFlowScreen extends StatefulWidget {
  final String propertyId;
  final String propertyTitle;
  final double nightlyPrice;
  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;
  final int initialGuests;
  final bool useAvailabilityApi;

  const BookingFlowScreen({
    super.key,
    required this.propertyId,
    this.propertyTitle = 'Your stay',
    this.nightlyPrice = 0,
    this.initialCheckIn,
    this.initialCheckOut,
    this.initialGuests = 1,
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
        AppTextWidget.titleLarge(text: widget.propertyTitle),
        SizedBox(height: 5.h),
        AppTextWidget.bodySmall(
          text: 'Check availability before booking this stay.',
          color: AppColor.textSecondary,
        ),
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

  Widget _section({required String title, required Widget child}) => Container(
    decoration: BoxDecoration(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(18.r),
      boxShadow: [
        BoxShadow(
          color: AppColor.black.withValues(alpha: .06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 8.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget.titleMedium(text: title),
        SizedBox(height: 8.h),
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
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: AppColor.divider),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget.labelSmall(text: label, color: AppColor.textSecondary),
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
        IconButton(
          onPressed: onMinus,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        AppTextWidget.titleMedium(text: '$value'),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const AppTextWidget.legacy(
                'Dates available. You can reserve this stay.',
              ),
              backgroundColor: AppColor.success,
              behavior: SnackBarBehavior.floating,
            ),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppTextWidget.legacy(
                'These dates are available to book.',
              ),
              backgroundColor: AppColor.success,
              behavior: SnackBarBehavior.floating,
            ),
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
        'checkIn': _date(checkIn!),
        'checkOut': _date(checkOut!),
        'guests': guests.toString(),
        'total': result.totalAmount.toStringAsFixed(0),
        'title': widget.propertyTitle,
      };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const AppTextWidget.legacy(
          'Reservation successful. Opening checkout.',
        ),
        backgroundColor: AppColor.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 700),
      ),
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

  static String _date(DateTime value) =>
      '${value.day}/${value.month}/${value.year}';
}
