import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/utilities/utils.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import '../../data/model/booking_model.dart';
import '../../data/repository/home_repository_impl.dart';
import '../../../../core/di/injector.dart';
import '../bloc/bookings_bloc.dart';
import '../bloc/bookings_event.dart';
import '../bloc/bookings_state.dart';

const _screenAsset = 'assets/images/bookings_figma_reference.png';
const _screenWidth = 464.0;
const _screenHeight = 1108.0;

class BookingsWidget extends StatefulWidget {
  const BookingsWidget({super.key});

  @override
  State<BookingsWidget> createState() => _BookingsWidgetState();
}

class _BookingsWidgetState extends State<BookingsWidget> {
  int _selectedTab = 0;

  static const _tabs = ['Upcoming', 'Past', 'Cancelled'];

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
              padding: EdgeInsets.fromLTRB(16.p, 16.p, 16.p, 96.p),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BookingsTopBar(),
                  Gap(24.h),
                  AppTextWidget(
                    text: 'My Bookings',
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w800,
                    color: theme.textPrimary,
                  ),
                  Gap(20.h),
                  _StatusTabs(
                    tabs: _tabs,
                    selectedIndex: _selectedTab,
                    onSelected: (index) {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                  ),
                  Gap(30.h),
                  BlocBuilder<BookingsBloc, BookingsState>(
                    builder: (context, state) {
                      if (state is BookingsInitial ||
                          state is BookingsLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state is BookingsError && state.previous == null) {
                        return _BookingsMessage(
                          message: state.message,
                          onRetry: () =>
                              context.read<BookingsBloc>().add(LoadBookings()),
                        );
                      }
                      final collection = state is BookingsLoaded
                          ? state.collection
                          : state is BookingsUpdating
                          ? state.collection
                          : (state as BookingsError).previous ??
                                const BookingCollection();
                      return _ApiBookingsList(
                        bookings: collection.bookings,
                        selectedTab: _selectedTab,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiBookingsList extends StatelessWidget {
  final List<BookingModel> bookings;
  final int selectedTab;

  const _ApiBookingsList({required this.bookings, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    final visible = bookings.where((booking) {
      final status = booking.status.toLowerCase();
      return selectedTab == 0
          ? status == 'pending' || status == 'confirmed'
          : selectedTab == 1
          ? status == 'completed'
          : status == 'cancelled';
    }).toList();
    if (visible.isEmpty) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * .5,
        child: _BookingsMessage(
          message: selectedTab == 0
              ? 'No upcoming bookings'
              : selectedTab == 1
              ? 'No past bookings'
              : 'No cancelled bookings',
          verticallyCentered: true,
        ),
      );
    }
    return Column(
      children: [
        for (var index = 0; index < visible.length; index++) ...[
          _ApiBookingCard(booking: visible[index]),
          if (index != visible.length - 1) Gap(18.h),
        ],
      ],
    );
  }
}

class _ApiBookingCard extends StatelessWidget {
  final BookingModel booking;

  const _ApiBookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;
    final start = booking.checkIn;
    final end = booking.checkOut;
    final dates = start == null || end == null
        ? 'Dates not available'
        : '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
    final isUpcoming =
        booking.status == 'pending' || booking.status == 'confirmed';
    final statusColor = booking.status == 'cancelled'
        ? AppColor.error
        : booking.status == 'completed'
        ? theme.textSecondary
        : AppColor.success;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: booking.id.isEmpty
          ? null
          : () => context.pushNamed(
              'booking-detail',
              pathParameters: {'bookingId': booking.id},
            ),
      child: Container(
      height: isUpcoming ? 148.h : 124.h,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: theme.textPrimary.withValues(alpha: .045),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: .055),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColor.black.withValues(alpha: .025),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 128.w,
            height: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (booking.propertyImage.isEmpty)
                  const _Thumbnail(crop: Rect.fromLTWH(24, 258, 148, 137))
                else
                  Image.network(
                    booking.propertyImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const _Thumbnail(
                      crop: Rect.fromLTWH(24, 258, 148, 137),
                    ),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColor.black.withValues(alpha: .02),
                        AppColor.black.withValues(alpha: .30),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10.w,
                  bottom: 10.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.black.withValues(alpha: .30),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColor.white.withValues(alpha: .28),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.hotel_rounded,
                          color: AppColor.white,
                          size: 11.sp,
                        ),
                        SizedBox(width: 4.w),
                        AppTextWidget(
                          text: 'YOUR STAY',
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(13.w, 14.h, 12.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextWidget(
                          text: booking.propertyTitle.isEmpty
                              ? 'Your stay'
                              : booking.propertyTitle,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.textPrimary,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      AppTextWidget(
                        text: booking.status.toUpperCase(),
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w900,
                        color: statusColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  AppTextWidget(
                    text: dates,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.textSecondary,
                  ),
                  SizedBox(height: 7.h),
                  AppTextWidget(
                    text: booking.propertyLocation,
                    fontSize: 10.sp,
                    color: theme.textTertiary,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  AppTextWidget(
                    text: isUpcoming
                        ? '${booking.nights} ${booking.nights == 1 ? 'night' : 'nights'}'
                        : '₹${(booking.totalPrice + booking.cleaningFee + booking.serviceFee + booking.tax).toStringAsFixed(0)} total',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: isUpcoming
                        ? theme.brandPrimary
                        : theme.textSecondary,
                  ),
                  if (isUpcoming)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _cancelBooking(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 22.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: AppTextWidget.labelSmall(
                          text: 'Cancel booking',
                          color: AppColor.error,
                        ),
                      ),
                    )
                  else if (booking.status == 'completed')
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _writeReview(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 22.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: AppTextWidget.labelSmall(
                          text: 'Write a review',
                          color: theme.brandPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Future<void> _cancelBooking(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel this booking?'),
        content: const Text('This will cancel your reservation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep booking'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<BookingsBloc>().add(CancelBooking(booking.id));
    }
  }

  Future<void> _writeReview(BuildContext context) async {
    var rating = 5;
    final commentController = TextEditingController();
    final submit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Review your stay'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Rating'),
                  Expanded(
                    child: Slider(
                      value: rating.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$rating',
                      onChanged: (value) =>
                          setDialogState(() => rating = value.round()),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: commentController,
                maxLength: 1000,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Share a few details',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
    if (submit != true || !context.mounted) {
      commentController.dispose();
      return;
    }
    final result = await sl<HomeRepositoryImpl>().createReview(
      booking.propertyId,
      booking.id,
      rating,
      commentController.text.trim(),
    );
    commentController.dispose();
    if (!context.mounted) return;
    result.fold(
      (error) => Utils.showSnackBar(error.message, result: Result.error),
      (review) => Utils.showSnackBar(
        review.message.isEmpty
            ? 'Thanks for sharing your review.'
            : review.message,
        result: Result.success,
      ),
    );
  }
}

class _BookingsMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool verticallyCentered;

  const _BookingsMessage({
    required this.message,
    this.onRetry,
    this.verticallyCentered = false,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: verticallyCentered ? 0 : 48.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 44.sp,
            color: AppColor.greyMedium,
          ),
          SizedBox(height: 12.h),
          AppTextWidget(
            text: message,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: context.themeExt.textPrimary,
          ),
          if (onRetry != null) ...[
            SizedBox(height: 10.h),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    ),
  );
}

class _BookingsTopBar extends StatelessWidget {
  const _BookingsTopBar();

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Row(
      children: [
        const _BrandLogo(),
        const Spacer(),
        SizedBox(
          width: 34.w,
          height: 34.w,
          child: Icon(
            Icons.notifications_none_rounded,
            color: theme.brandPrimary.withValues(alpha: 0.55),
            size: 20.sp,
          ),
        ),
      ],
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return SizedBox(
      width: 45.w,
      height: 23.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 2.w,
            child: AppTextWidget(
              text: 'Go',
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: theme.brandPrimary.withValues(alpha: 0.85),
            ),
          ),
          Positioned(
            right: 2.w,
            child: AppTextWidget(
              text: 'A',
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFB48B3D),
            ),
          ),
          Positioned(
            top: 2.h,
            child: Icon(
              Icons.landscape_rounded,
              color: theme.brandPrimary,
              size: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _StatusTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Row(
      children: List.generate(tabs.length, (index) {
        final selected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onSelected(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppTextWidget(
                text: tabs[index],
                fontSize: 13.sp,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? theme.brandPrimary : theme.textSecondary,
              ),
              Gap(7.h),
              Container(
                height: 3.h,
                width: 76.w,
                decoration: BoxDecoration(
                  color: selected ? theme.brandPrimary : AppColor.transparent,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final Rect crop;

  const _Thumbnail({required this.crop});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = max(
            constraints.maxWidth / crop.width,
            constraints.maxHeight / crop.height,
          );
          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: -crop.left * scale,
                top: -crop.top * scale,
                width: _screenWidth * scale,
                height: _screenHeight * scale,
                child: Image.asset(_screenAsset, fit: BoxFit.fill),
              ),
            ],
          );
        },
      ),
    );
  }
}
