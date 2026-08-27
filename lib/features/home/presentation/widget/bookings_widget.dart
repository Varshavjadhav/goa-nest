import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';

const _screenAsset = 'assets/images/bookings_figma_reference.png';
const _screenWidth = 464.0;
const _screenHeight = 1108.0;
const _confirmedBg = Color(0xFFE9F6E9);

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
                  const _BookingsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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

class _BookingsList extends StatelessWidget {
  const _BookingsList();

  static const _bookings = [
    (
      crop: Rect.fromLTWH(24, 258, 148, 137),
      title: 'Azure Wave Sanctuary',
      dates: 'Oct 12 - Oct 15, 2023',
      days: '3 days to go',
      highlight: true,
    ),
    (
      crop: Rect.fromLTWH(24, 425, 148, 137),
      title: 'The Palms Boutique',
      dates: 'Nov 04 - Nov 09, 2023',
      days: '22 days to go',
      highlight: false,
    ),
    (
      crop: Rect.fromLTWH(24, 594, 148, 136),
      title: 'Nomad Zen Studio',
      dates: 'Dec 20 - Dec 24, 2023',
      days: '68 days to go',
      highlight: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_bookings.length, (index) {
        final booking = _bookings[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == _bookings.length - 1 ? 0 : 18.h),
          child: _BookingCard(
            crop: booking.crop,
            title: booking.title,
            dates: booking.dates,
            days: booking.days,
            highlight: booking.highlight,
          ),
        );
      }),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Rect crop;
  final String title;
  final String dates;
  final String days;
  final bool highlight;

  const _BookingCard({
    required this.crop,
    required this.title,
    required this.dates,
    required this.days,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      height: 118.h,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 128.w,
            height: double.infinity,
            child: _Thumbnail(crop: crop),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(13.w, 16.h, 12.w, 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppTextWidget(
                          text: title,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.textPrimary,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap(8.w),
                      const _StatusChip(),
                    ],
                  ),
                  Gap(12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: theme.textTertiary,
                        size: 12.sp,
                      ),
                      Gap(5.w),
                      Expanded(
                        child: AppTextWidget(
                          text: dates,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.textSecondary,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Gap(12.h),
                  _DaysPill(text: days, highlight: highlight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.p, vertical: 3.h),
      decoration: BoxDecoration(
        color: _confirmedBg,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: AppTextWidget(
        text: 'CONFIRMED',
        fontSize: 9.sp,
        fontWeight: FontWeight.w900,
        color: AppColor.success,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _DaysPill extends StatelessWidget {
  final String text;
  final bool highlight;

  const _DaysPill({required this.text, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;
    final background =
        highlight ? theme.brandPrimary.withValues(alpha: 0.1) : theme.divider;
    final foreground =
        highlight ? theme.brandPrimary : theme.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.p, vertical: 4.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: AppTextWidget(
        text: text,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
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
