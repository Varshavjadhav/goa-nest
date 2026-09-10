import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

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
      appBar: CommonWidgets.appBar(
        title: 'Filters',
        onBackTap: () => context.pop(),
        actions: [
          TextButton(
            onPressed: _clear,
            child: AppTextWidget.bodyMedium(
              text: 'Clear all',
              color: AppColor.primary,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 30.h),
        children: [
          CommonWidgets.sectionTitle('Price range'),
          SizedBox(height: 5.h),
          AppTextWidget.bodySmall(
            text: 'Nightly prices before fees and taxes',
            color: AppColor.textQuaternary,
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
              AppTextWidget.bodyMedium(text: '₹${price.start.round()}'),
              AppTextWidget.bodyMedium(text: '₹${price.end.round()}'),
            ],
          ),
          CommonWidgets.divider(height: 40),
          CommonWidgets.sectionTitle('Property type'),
          SizedBox(height: 12.h),
          _chips(['Villa', 'Apartment', 'Hotel', 'Guesthouse'], selectedTypes),
          CommonWidgets.divider(height: 40),
          CommonWidgets.sectionTitle('Amenities'),
          SizedBox(height: 12.h),
          _chips([
            'Pool',
            'Wifi',
            'Kitchen',
            'Air conditioning',
            'Beachfront',
            'Free parking',
          ], selectedAmenities),
          CommonWidgets.divider(height: 40),
          CommonWidgets.sectionTitle('Rooms and beds'),
          SizedBox(height: 12.h),
          const _Counter(label: 'Bedrooms'),
          const _Counter(label: 'Beds'),
          const _Counter(label: 'Bathrooms'),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
          child: CommonWidgets.primaryButton(
            label: 'Show 1,000+ stays',
            onTap: () => context.pop(),
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
    label: AppTextWidget.bodyMedium(text: value),
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
        Expanded(child: AppTextWidget.titleSmall(text: label)),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.remove_circle_outline,
            size: 24.sp,
            color: AppColor.textSecondary,
          ),
        ),
        AppTextWidget.titleLarge(text: '0'),
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
