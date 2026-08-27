import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues price = const RangeValues(1500, 30000);
  final selectedTypes = <String>{'Villa'};
  final selectedAmenities = <String>{'Pool', 'Wifi'};

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
          icon: const Icon(Icons.close),
        ),
        title: Text(
          'Filters',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clear,
            child: Text(
              'Clear all',
              style: TextStyle(color: AppColor.primary),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 30.h),
        children: [
          Text(
            'Price range',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Nightly prices before fees and taxes',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColor.textQuaternary,
            ),
          ),
          RangeSlider(
            values: price,
            min: 1500,
            max: 30000,
            divisions: 19,
            activeColor: AppColor.primary,
            labels: RangeLabels(
              '₹${price.start.round()}',
              '₹${price.end.round()}',
            ),
            onChanged: (value) => setState(() => price = value),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${price.start.round()}',
                style: TextStyle(fontSize: 13.sp),
              ),
              Text(
                '₹${price.end.round()}',
                style: TextStyle(fontSize: 13.sp),
              ),
            ],
          ),
          Divider(height: 40.h),
          Text(
            'Property type',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          _chips(
            ['Villa', 'Apartment', 'Hotel', 'Guesthouse'],
            selectedTypes,
          ),
          Divider(height: 40.h),
          Text(
            'Amenities',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          _chips(
            ['Pool', 'Wifi', 'Kitchen', 'Air conditioning', 'Beachfront', 'Free parking'],
            selectedAmenities,
          ),
          Divider(height: 40.h),
          Text(
            'Rooms and beds',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          const _Counter(label: 'Bedrooms'),
          const _Counter(label: 'Beds'),
          const _Counter(label: 'Bathrooms'),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
          child: SizedBox(
            height: 50.h,
            child: ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                'Show 1,000+ stays',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chips(List<String> values, Set<String> selected) => Wrap(
    spacing: 8.w,
    runSpacing: 8.h,
    children: values.map((value) => _chip(value, selected)).toList(),
  );

  Widget _chip(String value, Set<String> selected) => FilterChip(
    label: Text(
      value,
      style: TextStyle(fontSize: 13.sp),
    ),
    selected: selected.contains(value),
    selectedColor: AppColor.tertiary,
    checkmarkColor: AppColor.primary,
    onSelected: (on) => setState(() {
      if (on) {
        selected.add(value);
      } else {
        selected.remove(value);
      }
    }),
  );

  void _clear() => setState(() {
    price = const RangeValues(1500, 30000);
    selectedTypes.clear();
    selectedAmenities.clear();
  });
}

class _Counter extends StatelessWidget {
  final String label;
  const _Counter({required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.remove_circle_outline,
            size: 24.sp,
            color: AppColor.textSecondary,
          ),
        ),
        Text(
          '0',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add_circle_outline,
            size: 24.sp,
            color: AppColor.primary,
          ),
        ),
      ],
    ),
  );
}
