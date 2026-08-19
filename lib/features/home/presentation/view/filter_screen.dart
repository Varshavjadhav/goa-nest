import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  static const _propertyOptions = [
    'Villa',
    'Apartment',
    'Resort',
    'Boutique Hotel',
  ];

  static const _amenityOptions = [
    (icon: Icons.pool_rounded, label: 'Private Pool'),
    (icon: Icons.wifi_rounded, label: 'Wifi'),
    (icon: Icons.ac_unit_rounded, label: 'AC'),
    (icon: Icons.room_service_rounded, label: 'Chef-on-call'),
    (icon: Icons.beach_access_rounded, label: 'Beachfront'),
  ];

  static final _presetCards = [
    (label: '₹1,500 – ₹4,000', range: RangeValues(0.0, _valueFor(4000))),
    (
      label: '₹4,000 – ₹10,000',
      range: RangeValues(_valueFor(4000), _valueFor(10000)),
    ),
  ];

  RangeValues _priceRange = const RangeValues(0.0, 1.0);
  int? _selectedPreset;
  final Set<String> _selectedPropertyTypes = {'Villa', 'Apartment'};
  final Set<String> _selectedAmenities = {'Private Pool', 'Wifi'};
  int? _bedrooms;
  int? _bathrooms;
  bool _instantBook = false;
  bool _selfCheckIn = true;

  void _clearAll() {
    setState(() {
      _priceRange = const RangeValues(0.0, 1.0);
      _selectedPreset = null;
      _selectedPropertyTypes.clear();
      _selectedAmenities.clear();
      _bedrooms = null;
      _bathrooms = null;
      _instantBook = false;
      _selfCheckIn = true;
    });
  }

  void _toggleProperty(String type) {
    setState(() {
      if (!_selectedPropertyTypes.add(type)) {
        _selectedPropertyTypes.remove(type);
      }
    });
  }

  void _toggleAmenity(String label, bool value) {
    setState(() {
      if (value) {
        _selectedAmenities.add(label);
      } else {
        _selectedAmenities.remove(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.p, 8.p, 16.p, 32.p),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Gap(28.h),
                    _buildPriceRange(),
                    Gap(42.h),
                    _buildPropertyType(),
                    Gap(42.h),
                    _buildRoomsAndBeds(),
                    Gap(42.h),
                    _buildAmenities(),
                    Gap(26.h),
                    const _SectionDivider(),
                    Gap(26.h),
                    _buildBookingOptions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border(top: BorderSide(color: AppColor.divider)),
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.fromLTRB(16.p, 12.h, 16.p, 16.h),
        child: InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(26.r),
          child: Container(
            height: 52.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: AppTextWidget(
              text: 'Show 1,000+ stays',
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: AppColor.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(18.r),
          child: SizedBox(
            width: 34.w,
            height: 34.w,
            child: Icon(
              Icons.close_rounded,
              color: AppColor.textPrimary,
              size: 23.sp,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AppTextWidget(
              text: 'Filters',
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColor.textPrimary,
            ),
          ),
        ),
        AppTextWidget(
          text: 'Clear all',
          fontSize: 12.sp,
          fontWeight: FontWeight.w800,
          color: AppColor.primary,
          onTap: _clearAll,
        ),
      ],
    );
  }

  Widget _buildPriceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Price range'),
        Gap(4.h),
        AppTextWidget(
          text: 'Nightly prices before fees and taxes',
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: AppColor.textSecondary,
        ),
        Gap(18.h),
        _PriceHistogram(values: _priceRange),
        Gap(14.h),
        _RangeSlider(
          values: _priceRange,
          onChanged: (values) => setState(() {
            _priceRange = values;
            _selectedPreset = null;
          }),
        ),
        Gap(4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PriceLabel(value: _priceRange.start),
            _PriceLabel(value: _priceRange.end),
          ],
        ),
        Gap(16.h),
        Row(
          children: [
            Expanded(
              child: _PresetPriceCard(
                label: _presetCards[0].label,
                selected: _selectedPreset == 0,
                onTap: () => _onPresetTap(0),
              ),
            ),
            Gap(12.w),
            Expanded(
              child: _PresetPriceCard(
                label: _presetCards[1].label,
                selected: _selectedPreset == 1,
                onTap: () => _onPresetTap(1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onPresetTap(int index) {
    setState(() {
      if (_selectedPreset == index) {
        _selectedPreset = null;
        _priceRange = const RangeValues(0.0, 1.0);
      } else {
        _selectedPreset = index;
        _priceRange = _presetCards[index].range;
      }
    });
  }

  Widget _buildPropertyType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Property type'),
        Gap(14.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _PropertyTile(
                label: _propertyOptions[0],
                selected: _selectedPropertyTypes.contains(_propertyOptions[0]),
                onTap: () => _toggleProperty(_propertyOptions[0]),
              ),
            ),
            Gap(12.w),
            Expanded(
              child: _PropertyTile(
                label: _propertyOptions[1],
                selected: _selectedPropertyTypes.contains(_propertyOptions[1]),
                onTap: () => _toggleProperty(_propertyOptions[1]),
              ),
            ),
          ],
        ),
        Gap(12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _PropertyTile(
                label: _propertyOptions[2],
                selected: _selectedPropertyTypes.contains(_propertyOptions[2]),
                onTap: () => _toggleProperty(_propertyOptions[2]),
              ),
            ),
            Gap(12.w),
            Expanded(
              child: _PropertyTile(
                label: _propertyOptions[3],
                selected: _selectedPropertyTypes.contains(_propertyOptions[3]),
                onTap: () => _toggleProperty(_propertyOptions[3]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoomsAndBeds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Rooms and beds'),
        Gap(10.h),
        _RoomRow(
          label: 'Bedrooms',
          value: _bedrooms,
          onChanged: (value) => setState(() => _bedrooms = value),
        ),
        Gap(12.h),
        _RoomRow(
          label: 'Bathrooms',
          value: _bathrooms,
          onChanged: (value) => setState(() => _bathrooms = value),
        ),
      ],
    );
  }

  Widget _buildAmenities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Amenities'),
        Gap(12.h),
        ..._amenityOptions.map(
          (option) => _AmenityRow(
            icon: option.icon,
            label: option.label,
            checked: _selectedAmenities.contains(option.label),
            onChanged: (value) => _toggleAmenity(option.label, value),
          ),
        ),
        Gap(8.h),
        AppTextWidget(
          text: 'Show more',
          fontSize: 12.sp,
          fontWeight: FontWeight.w800,
          color: AppColor.primary,
        ),
      ],
    );
  }

  Widget _buildBookingOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Booking options'),
        Gap(12.h),
        _BookingRow(
          title: 'Instant book',
          subtitle: 'Listings you can book without waiting for host approval',
          value: _instantBook,
          onChanged: (value) => setState(() => _instantBook = value),
        ),
        Gap(16.h),
        _BookingRow(
          title: 'Self check-in',
          subtitle: 'Easy access to the property upon arrival',
          value: _selfCheckIn,
          onChanged: (value) => setState(() => _selfCheckIn = value),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppTextWidget(
      text: title,
      fontSize: 16.sp,
      fontWeight: FontWeight.w900,
      color: AppColor.textPrimary,
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColor.divider);
  }
}

class _PriceLabel extends StatelessWidget {
  final double value;

  const _PriceLabel({required this.value});

  @override
  Widget build(BuildContext context) {
    return AppTextWidget(
      text: '₹${_indianGroup(_priceFor(value))}',
      fontSize: 13.sp,
      fontWeight: FontWeight.w800,
      color: AppColor.textPrimary,
    );
  }
}

int _priceFor(double value) {
  const minPrice = 1500;
  const maxPrice = 45000;
  final raw = minPrice + value * (maxPrice - minPrice);
  return ((raw / 100).round()) * 100;
}

double _valueFor(int price) {
  const minPrice = 1500;
  const maxPrice = 45000;
  return (price - minPrice) / (maxPrice - minPrice);
}

String _indianGroup(int number) {
  final digits = number.toString();
  if (digits.length <= 3) return digits;
  final last3 = digits.substring(digits.length - 3);
  var rest = digits.substring(0, digits.length - 3);
  final groups = <String>[];
  while (rest.length > 2) {
    groups.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  groups.insert(0, rest);
  return '${groups.join(',')},$last3';
}

const _histogramBars = <double>[
  0.16, 0.22, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.88, 0.95,
  1.00, 0.96, 0.88, 0.78, 0.68, 0.58, 0.48, 0.38, 0.28, 0.20,
];

class _PriceHistogram extends StatelessWidget {
  final RangeValues values;

  const _PriceHistogram({required this.values});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 96.h,
      child: CustomPaint(
        painter: _HistogramPainter(values: values),
      ),
    );
  }
}

class _HistogramPainter extends CustomPainter {
  final RangeValues values;

  const _HistogramPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final n = _histogramBars.length;
    final gap = 4.p;
    final barWidth = (size.width - gap * (n - 1)) / n;
    final maxBarHeight = size.height - 6.p;

    for (var i = 0; i < n; i++) {
      final mid = (i + 0.5) / n;
      final selected = mid >= values.start && mid <= values.end;
      final barHeight = _histogramBars[i] * maxBarHeight;
      final left = i * (barWidth + gap);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, size.height - barHeight, barWidth, barHeight),
        Radius.circular(barWidth / 2),
      );
      canvas.drawRRect(
        rect,
        Paint()
          ..color = selected
              ? AppColor.primary
              : AppColor.divider,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HistogramPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

class _PresetPriceCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PresetPriceCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColor.primaryLight : AppColor.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? AppColor.primary : AppColor.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: AppTextWidget(
          text: label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w800,
          color: selected ? AppColor.primary : AppColor.textPrimary,
        ),
      ),
    );
  }
}

class _RangeSlider extends StatefulWidget {
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  const _RangeSlider({required this.values, required this.onChanged});

  @override
  State<_RangeSlider> createState() => _RangeSliderState();
}

class _RangeSliderState extends State<_RangeSlider> {
  bool? _dragThumbIsLeft;

  double _dxToValue(double dx, double trackPadding, double usable) {
    return ((dx - trackPadding) / usable).clamp(0.0, 1.0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final values = widget.values;

    return SizedBox(
      height: 46.h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final trackPadding = 14.p;
          final usable = width - trackPadding * 2;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              final dx = details.localPosition.dx;
              final leftDx = trackPadding + values.start * usable;
              final rightDx = trackPadding + values.end * usable;
              final value = _dxToValue(dx, trackPadding, usable);
              if ((dx - leftDx).abs() <= (dx - rightDx).abs()) {
                _dragThumbIsLeft = true;
                widget.onChanged(
                  RangeValues(min(value, values.end), values.end),
                );
              } else {
                _dragThumbIsLeft = false;
                widget.onChanged(
                  RangeValues(values.start, max(value, values.start)),
                );
              }
            },
            onTapUp: (_) => _dragThumbIsLeft = null,
            onPanDown: (details) {
              final dx = details.localPosition.dx;
              final leftDx = trackPadding + values.start * usable;
              final rightDx = trackPadding + values.end * usable;
              _dragThumbIsLeft = (dx - leftDx).abs() <= (dx - rightDx).abs();
            },
            onPanUpdate: (details) {
              final value = _dxToValue(
                details.localPosition.dx,
                trackPadding,
                usable,
              );
              if (_dragThumbIsLeft ?? true) {
                widget.onChanged(
                  RangeValues(min(value, values.end), values.end),
                );
              } else {
                widget.onChanged(
                  RangeValues(values.start, max(value, values.start)),
                );
              }
            },
            onPanEnd: (_) => _dragThumbIsLeft = null,
            onPanCancel: () => _dragThumbIsLeft = null,
            child: CustomPaint(
              size: Size(width, 46.h),
              painter: _RangeSliderPainter(
                values: values,
                trackPadding: trackPadding,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RangeSliderPainter extends CustomPainter {
  final RangeValues values;
  final double trackPadding;

  _RangeSliderPainter({required this.values, required this.trackPadding});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final usable = size.width - trackPadding * 2;
    final leftX = trackPadding + values.start * usable;
    final rightX = trackPadding + values.end * usable;

    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        trackPadding,
        centerY - 3.p,
        size.width - trackPadding,
        centerY + 3.p,
      ),
      Radius.circular(3.r),
    );
    canvas.drawRRect(trackRect, Paint()..color = AppColor.divider);

    if (rightX > leftX) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(leftX, centerY - 3.p, rightX, centerY + 3.p),
          Radius.circular(3.r),
        ),
        Paint()..color = AppColor.secondary,
      );
    }

    _drawThumb(canvas, Offset(leftX, centerY));
    _drawThumb(canvas, Offset(rightX, centerY));
  }

  void _drawThumb(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 9.p, Paint()..color = AppColor.primary);
    canvas.drawCircle(
      center,
      9.p,
      Paint()
        ..color = AppColor.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
  }

  @override
  bool shouldRepaint(covariant _RangeSliderPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.trackPadding != trackPadding;
  }
}

class _PropertyTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PropertyTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 72.h,
        padding: EdgeInsets.all(12.p),
        decoration: BoxDecoration(
          color: selected ? AppColor.primaryLight : AppColor.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected
                ? AppColor.secondary.withValues(alpha: 0.5)
                : AppColor.divider,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CheckBox(checked: selected),
            const Spacer(),
            AppTextWidget(
              text: label,
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColor.textPrimary,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool checked;

  const _CheckBox({required this.checked});

  @override
  Widget build(BuildContext context) {
    final boxSize = 16.p;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: checked ? AppColor.primary : AppColor.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: checked ? AppColor.primary : AppColor.borderGrey,
          width: 1.4,
        ),
      ),
      child: checked
          ? Icon(Icons.check_rounded, color: AppColor.white, size: boxSize * 0.72)
          : null,
    );
  }
}

class _RoomRow extends StatelessWidget {
  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;

  const _RoomRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextWidget(
            text: label,
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        _CountPill(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _CountPill extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const _CountPill({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(horizontal: 5.p),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColor.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) ...[
            _StepButton(
              icon: Icons.remove_rounded,
              onTap: value == 1
                  ? () => onChanged(null)
                  : () => onChanged(value! - 1),
            ),
            Gap(6.w),
          ],
          SizedBox(
            width: value == null ? 36.w : 24.w,
            child: AppTextWidget(
              text: value?.toString() ?? 'Any',
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColor.textPrimary,
              textAlign: TextAlign.center,
            ),
          ),
          Gap(6.w),
          _StepButton(
            icon: Icons.add_rounded,
            onTap: () => onChanged((value ?? 0) + 1),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13.r),
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: AppColor.secondary.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColor.textPrimary, size: 15.sp),
      ),
    );
  }
}

class _AmenityRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const _AmenityRow({
    required this.icon,
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!checked),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 9.h),
        child: Row(
          children: [
            Icon(icon, color: AppColor.textSecondary, size: 18.sp),
            Gap(12.w),
            Expanded(
              child: AppTextWidget(
                text: label,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
            _CheckBox(checked: checked),
          ],
        ),
      ),
    );
  }
}

class _BookingRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _BookingRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget(
                text: title,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
              Gap(3.h),
              AppTextWidget(
                text: subtitle,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.textSecondary,
                height: 1.3,
              ),
            ],
          ),
        ),
        Gap(16.w),
        _ToggleSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44.w,
        height: 26.h,
        padding: EdgeInsets.all(3.p),
        decoration: BoxDecoration(
          color: value ? AppColor.primary : AppColor.greyExtraLight,
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: const BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
