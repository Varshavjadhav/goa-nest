import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/di/injector.dart';
import 'package:goanest/features/home/data/model/booking_model.dart';
import 'package:goanest/features/home/data/repository/home_repository_impl.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late Future<Either<AppException, BookingModel>> _bookingFuture;

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  void _loadBooking() {
    _bookingFuture = sl<HomeRepositoryImpl>().getBooking(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.surface,
    appBar: AppBar(
      title: const Text('Booking details'),
      backgroundColor: AppColor.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    body: FutureBuilder<Either<AppException, BookingModel>>(
      future: _bookingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final result = snapshot.data;
        if (snapshot.hasError || result == null) {
          return _BookingDetailError(
            message: 'Could not load this booking. Please try again.',
            onRetry: _retry,
          );
        }
        return result.fold(
          (error) => _BookingDetailError(
            message: error.message,
            onRetry: _retry,
          ),
          (booking) => _BookingDetails(booking: booking),
        );
      },
    ),
  );

  void _retry() => setState(_loadBooking);
}

class _BookingDetails extends StatelessWidget {
  final BookingModel booking;

  const _BookingDetails({required this.booking});

  @override
  Widget build(BuildContext context) {
    final total = booking.totalPrice +
        booking.cleaningFee +
        booking.serviceFee +
        booking.tax;
    final status = booking.status.toLowerCase();
    final statusColor = status == 'cancelled'
        ? AppColor.error
        : status == 'completed'
        ? AppColor.greyMedium
        : AppColor.success;

    return ListView(
      padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 32.h),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: SizedBox(
            height: 205.h,
            child: booking.propertyImage.isEmpty
                ? const ColoredBox(
                    color: AppColor.greyExtraLight,
                    child: Icon(Icons.home_work_outlined, size: 54),
                  )
                : Image.network(
                    booking.propertyImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: AppColor.greyExtraLight,
                      child: Icon(Icons.home_work_outlined, size: 54),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 18.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget.titleLarge(
                    text: booking.propertyTitle.isEmpty
                        ? 'Your stay'
                        : booking.propertyTitle,
                  ),
                  if (booking.propertyLocation.isNotEmpty) ...[
                    SizedBox(height: 5.h),
                    AppTextWidget.bodySmall(
                      text: booking.propertyLocation,
                      color: AppColor.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AppTextWidget.labelSmall(
                text: booking.status.toUpperCase(),
                color: statusColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        _DetailSection(
          title: 'Your trip',
          children: [
            _DetailRow(
              icon: Icons.login_rounded,
              label: 'Check-in',
              value: _date(booking.checkIn),
            ),
            _DetailRow(
              icon: Icons.logout_rounded,
              label: 'Check-out',
              value: _date(booking.checkOut),
            ),
            _DetailRow(
              icon: Icons.nights_stay_outlined,
              label: 'Length of stay',
              value: '${booking.nights} ${booking.nights == 1 ? 'night' : 'nights'}',
            ),
            _DetailRow(
              icon: Icons.people_outline_rounded,
              label: 'Guests',
              value: '${booking.adults} adults'
                  '${booking.children > 0 ? ', ${booking.children} children' : ''}'
                  '${booking.infants > 0 ? ', ${booking.infants} infants' : ''}',
            ),
            _DetailRow(
              icon: Icons.meeting_room_outlined,
              label: 'Rooms',
              value: '${booking.rooms}',
              isLast: true,
            ),
          ],
        ),
        SizedBox(height: 14.h),
        _DetailSection(
          title: 'Price details',
          children: [
            _PriceRow(
              label: '₹${booking.pricePerNight.toStringAsFixed(0)} × ${booking.nights} nights',
              amount: booking.totalPrice,
            ),
            if (booking.cleaningFee > 0)
              _PriceRow(label: 'Cleaning fee', amount: booking.cleaningFee),
            if (booking.serviceFee > 0)
              _PriceRow(label: 'Service fee', amount: booking.serviceFee),
            if (booking.tax > 0) _PriceRow(label: 'Taxes', amount: booking.tax),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(height: 1, color: AppColor.divider),
            ),
            _PriceRow(label: 'Total', amount: total, isTotal: true),
          ],
        ),
        if (booking.specialRequests.isNotEmpty) ...[
          SizedBox(height: 14.h),
          _DetailSection(
            title: 'Special requests',
            children: [
              AppTextWidget.bodyMedium(
                text: booking.specialRequests,
                color: AppColor.textSecondary,
              ),
            ],
          ),
        ],
        if (booking.cancellationReason.isNotEmpty) ...[
          SizedBox(height: 14.h),
          _DetailSection(
            title: 'Cancellation reason',
            children: [
              AppTextWidget.bodyMedium(
                text: booking.cancellationReason,
                color: AppColor.error,
              ),
            ],
          ),
        ],
        SizedBox(height: 18.h),
        Center(
          child: AppTextWidget.bodySmall(
            text: 'Booking reference: ${booking.id}',
            color: AppColor.textSecondary,
          ),
        ),
      ],
    );
  }

  static String _date(DateTime? value) {
    if (value == null) return 'Not available';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${value.day} ${months[value.month - 1]} ${value.year}';
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.p),
    decoration: BoxDecoration(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: AppColor.black.withValues(alpha: .045),
          blurRadius: 16,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget.titleSmall(text: title),
        SizedBox(height: 12.h),
        ...children,
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: isLast ? 0 : 13.h),
    child: Row(
      children: [
        Icon(icon, size: 19.sp, color: AppColor.textSecondary),
        SizedBox(width: 10.w),
        Expanded(
          child: AppTextWidget.bodySmall(text: label, color: AppColor.textSecondary),
        ),
        AppTextWidget(
          text: value,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
      ],
    ),
  );
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: isTotal ? 0 : 10.h),
    child: Row(
      children: [
        Expanded(
          child: AppTextWidget(
            text: label,
            fontSize: 13.sp,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: AppColor.textPrimary,
          ),
        ),
        AppTextWidget(
          text: '₹${amount.toStringAsFixed(0)}',
          fontSize: 13.sp,
          fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
          color: AppColor.textPrimary,
        ),
      ],
    ),
  );
}

class _BookingDetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _BookingDetailError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(28.p),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy_outlined, size: 48.sp, color: AppColor.greyMedium),
          SizedBox(height: 12.h),
          AppTextWidget.bodyMedium(text: message, textAlign: TextAlign.center),
          SizedBox(height: 12.h),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ],
      ),
    ),
  );
}
