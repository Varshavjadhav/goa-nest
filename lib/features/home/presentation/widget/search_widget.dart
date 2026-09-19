import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';

import '../../data/model/explore_model.dart';
import '../../data/model/search_model.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

enum _SearchStage { destination, dates, guests, results }

class _DestinationSelection {
  final String label;
  final String city;
  final String country;

  const _DestinationSelection({
    required this.label,
    this.city = '',
    this.country = '',
  });
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  _SearchStage stage = _SearchStage.destination;
  String destination = '';
  DateTime? checkIn, checkOut;
  bool flexibleDates = false;
  String flexibleDuration = 'week';
  DateTime? flexibleMonth;
  int flexibilityDays = 0;
  int adults = 1;
  int children = 0;
  int infants = 0;
  int pets = 0;
  SearchQuery searchQuery = const SearchQuery(maxGuests: 1);

  int get guests => adults + children;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F7F7),
    body: SafeArea(
      child: Column(
        children: [
          _SearchCategoryHeader(
            onClose: () {
              if (stage != _SearchStage.destination) {
                setState(() => stage = _previous());
              } else if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteName.homeView);
              }
            },
          ),
          if (stage != _SearchStage.destination)
            _SearchSummary(
              stage: stage,
              onWhereTap: () =>
                  setState(() => stage = _SearchStage.destination),
              onWhenTap: () => setState(() => stage = _SearchStage.dates),
              destination: destination,
              checkIn: checkIn,
              checkOut: checkOut,
              guests: guests,
            ),
          Expanded(child: _content()),
          if (stage != _SearchStage.results)
            _SearchBottomBar(
              actionLabel: stage == _SearchStage.dates ? 'Next' : 'Search',
              enabled: stage == _SearchStage.destination
                  ? destination.isNotEmpty
                  : stage == _SearchStage.dates
                  ? flexibleDates
                        ? flexibleMonth != null
                        : checkIn != null && checkOut != null
                  : adults + children > 0,
              onClear: () => setState(() {
                destination = '';
                checkIn = null;
                checkOut = null;
                flexibleDates = false;
                flexibleDuration = 'week';
                flexibleMonth = null;
                flexibilityDays = 0;
                adults = 1;
                children = 0;
                infants = 0;
                pets = 0;
                searchQuery = const SearchQuery(maxGuests: 1);
              }),
              onAction: () {
                if (stage == _SearchStage.destination) {
                  setState(() => stage = _SearchStage.dates);
                } else if (stage == _SearchStage.dates) {
                  setState(() => stage = _SearchStage.guests);
                } else {
                  context.read<SearchBloc>().add(SearchProperties(searchQuery));
                  setState(() => stage = _SearchStage.results);
                }
              },
            ),
        ],
      ),
    ),
  );

  _SearchStage _previous() {
    switch (stage) {
      case _SearchStage.dates:
        return _SearchStage.destination;
      case _SearchStage.guests:
        return _SearchStage.dates;
      case _SearchStage.results:
        return _SearchStage.guests;
      case _SearchStage.destination:
        return _SearchStage.destination;
    }
  }

  Widget _content() {
    switch (stage) {
      case _SearchStage.destination:
        return _DestinationStep(
          onSelect: (selection) => setState(() {
            destination = selection.label;
            searchQuery = searchQuery.copyWith(
              query: selection.label,
              city: selection.city,
              country: selection.country,
            );
            stage = _SearchStage.dates;
          }),
          onQuickSelect: _searchFromDestination,
          onWhen: () => setState(() => stage = _SearchStage.dates),
          onWho: () => setState(() => stage = _SearchStage.guests),
        );
      case _SearchStage.dates:
        return _DatesStep(
          checkIn: checkIn,
          checkOut: checkOut,
          flexible: flexibleDates,
          flexibleDuration: flexibleDuration,
          flexibleMonth: flexibleMonth,
          onFlexibleChanged: (value) => setState(() {
            flexibleDates = value;
            if (value && flexibleMonth == null) {
              final now = DateTime.now();
              flexibleMonth = DateTime(now.year, now.month);
            }
            searchQuery = searchQuery.copyWith(
              flexibleMonth: value && flexibleMonth != null
                  ? _monthParam(flexibleMonth!)
                  : '',
              flexibleDuration: value ? flexibleDuration : '',
            );
          }),
          onFlexibleDurationChanged: (value) => setState(() {
            flexibleDuration = value;
            searchQuery = searchQuery.copyWith(flexibleDuration: value);
          }),
          onFlexibleMonthChanged: (value) => setState(() {
            flexibleMonth = value;
            searchQuery = searchQuery.copyWith(
              flexibleMonth: _monthParam(value),
            );
          }),
          flexibilityDays: flexibilityDays,
          onFlexibilityDaysChanged: (value) => setState(() {
            flexibilityDays = value;
            searchQuery = searchQuery.copyWith(flexibilityDays: value);
          }),
          onChanged: (start, end) => setState(() {
            checkIn = start;
            checkOut = end;
            searchQuery = searchQuery.copyWith(
              checkIn: start,
              checkOut: end,
              clearCheckOut: end == null,
            );
          }),
          onReset: () => setState(() {
            checkIn = null;
            checkOut = null;
            searchQuery = searchQuery.copyWith(
              clearCheckIn: true,
              clearCheckOut: true,
            );
          }),
          onNext: () => setState(() => stage = _SearchStage.guests),
        );
      case _SearchStage.guests:
        return _GuestsStep(
          adults: adults,
          children: children,
          infants: infants,
          pets: pets,
          onAdultsChanged: (value) => setState(() {
            adults = value;
            searchQuery = searchQuery.copyWith(maxGuests: adults + children);
          }),
          onChildrenChanged: (value) => setState(() {
            children = value;
            searchQuery = searchQuery.copyWith(maxGuests: adults + children);
          }),
          onInfantsChanged: (value) => setState(() {
            infants = value;
            searchQuery = searchQuery.copyWith(infants: value);
          }),
          onPetsChanged: (value) => setState(() {
            pets = value;
            searchQuery = searchQuery.copyWith(pets: value);
          }),
          onSearch: () {
            context.read<SearchBloc>().add(SearchProperties(searchQuery));
            setState(() => stage = _SearchStage.results);
          },
        );
      case _SearchStage.results:
        return _ResultsStep(query: searchQuery, onFilter: _openFilters);
    }
  }

  Future<void> _openFilters() async {
    final filters = await context.push<SearchFilters>(RouteName.filterView);
    if (!mounted || filters == null) return;
    setState(() {
      searchQuery = searchQuery.copyWith(
        minPrice: filters.minPrice,
        maxPrice: filters.maxPrice,
        propertyType: filters.propertyType,
        bedrooms: filters.bedrooms,
        amenities: filters.amenities,
        minRating: filters.minRating,
      );
    });
    context.read<SearchBloc>().add(SearchProperties(searchQuery));
  }

  void _searchFromDestination(_DestinationSelection selection) {
    final nextQuery = searchQuery.copyWith(
      query: selection.label,
      city: selection.city,
      country: selection.country,
    );
    setState(() {
      destination = selection.label;
      searchQuery = nextQuery;
      stage = _SearchStage.results;
    });
    context.read<SearchBloc>().add(SearchProperties(nextQuery));
  }

  static String _monthParam(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}';
}

class _SearchSummary extends StatelessWidget {
  final _SearchStage stage;
  final VoidCallback onWhereTap;
  final VoidCallback onWhenTap;
  final String destination;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int guests;

  const _SearchSummary({
    required this.stage,
    required this.onWhereTap,
    required this.onWhenTap,
    required this.destination,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.fromLTRB(20.w, 2.h, 20.w, 10.h),
    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(18.r),
      border: Border.all(color: AppColor.divider),
      boxShadow: [
        BoxShadow(
          color: AppColor.black.withValues(alpha: .05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: stage == _SearchStage.dates
        ? _SummaryRow(
            label: 'Where',
            value: destination.isEmpty ? 'Nearby' : destination,
            onTap: onWhereTap,
          )
        : stage == _SearchStage.guests
        ? Column(
            children: [
              _SummaryRow(
                label: 'Where',
                value: destination.isEmpty ? 'Nearby' : destination,
                onTap: onWhereTap,
              ),
              Divider(height: 1, color: AppColor.divider),
              _SummaryRow(
                label: 'When',
                value: checkIn == null
                    ? 'Add dates'
                    : _dateRange(checkIn!, checkOut),
                onTap: onWhenTap,
              ),
            ],
          )
        : Row(
            children: [
              _SummaryItem(
                icon: Icons.location_on_outlined,
                label: destination,
              ),
              const _SummaryDivider(),
              _SummaryItem(
                icon: Icons.calendar_today_outlined,
                label: checkIn == null ? 'Add dates' : _shortDate(checkIn!),
              ),
              const _SummaryDivider(),
              _SummaryItem(
                icon: Icons.person_outline_rounded,
                label: '$guests ${guests == 1 ? 'guest' : 'guests'}',
              ),
            ],
          ),
  );

  static String _shortDate(DateTime value) => '${value.day}/${value.month}';

  static String _dateRange(DateTime start, DateTime? end) {
    if (end == null) return _shortDate(start);
    return '${_shortDate(start)} – ${_shortDate(end)}';
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18.r),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTextWidget.legacy(
            label,
            style: TextStyle(fontSize: 15.sp, color: AppColor.textSecondary),
          ),
          AppTextWidget.legacy(
            value,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}

class _SearchBottomBar extends StatelessWidget {
  final String actionLabel;
  final bool enabled;
  final VoidCallback onClear;
  final VoidCallback onAction;

  const _SearchBottomBar({
    required this.actionLabel,
    required this.enabled,
    required this.onClear,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(22.w, 10.h, 22.w, 12.h),
    decoration: BoxDecoration(
      color: const Color(0xFFF7F7F7),
      boxShadow: [
        BoxShadow(
          color: AppColor.black.withValues(alpha: .10),
          blurRadius: 12,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onClear,
          child: AppTextWidget.legacy(
            'Clear all',
            style: TextStyle(
              color: enabled ? AppColor.textPrimary : AppColor.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(
          width: 150.w,
          child: ElevatedButton.icon(
            onPressed: enabled ? onAction : null,
            icon: Icon(
              actionLabel == 'Search'
                  ? Icons.search_rounded
                  : Icons.arrow_forward_rounded,
              size: 18.sp,
            ),
            label: AppTextWidget.legacy(
              actionLabel,
              style: TextStyle(fontSize: 14.sp),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              disabledBackgroundColor: AppColor.divider,
              foregroundColor: AppColor.white,
              padding: EdgeInsets.symmetric(vertical: 13.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _SearchCategoryHeader extends StatelessWidget {
  final VoidCallback onClose;
  const _SearchCategoryHeader({required this.onClose});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 124.h,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(34.w, 8.h, 76.w, 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              _SearchCategory(icon: '🏠', label: 'Homes', active: true),
              _SearchCategory(icon: '🎈', label: 'Experiences'),
              _SearchCategory(icon: '🛎️', label: 'Services'),
            ],
          ),
        ),
        Positioned(
          right: 18.w,
          bottom: 80.h,
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              width: 30.w,
              height: 30.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: .12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.close_rounded, size: 20.sp),
            ),
          ),
        ),
      ],
    ),
  );
}

class _SearchCategory extends StatelessWidget {
  final String icon;
  final String label;
  final bool active;
  const _SearchCategory({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppTextWidget.legacy(icon, style: TextStyle(fontSize: 25.sp, height: 1)),
      SizedBox(height: 5.h),
      AppTextWidget.legacy(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          color: active ? AppColor.textPrimary : AppColor.textSecondary,
        ),
      ),
      SizedBox(height: 6.h),
      AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: active ? 32.w : 0,
        height: 3.h,
        decoration: BoxDecoration(
          color: AppColor.textPrimary,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    ],
  );
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SummaryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 15.sp, color: AppColor.textPrimary),
        SizedBox(width: 4.w),
        Flexible(
          child: AppTextWidget.legacy(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 20.h, color: AppColor.divider);
}

class _DestinationStep extends StatefulWidget {
  final ValueChanged<_DestinationSelection> onSelect;
  final ValueChanged<_DestinationSelection> onQuickSelect;
  final VoidCallback onWhen;
  final VoidCallback onWho;
  const _DestinationStep({
    required this.onSelect,
    required this.onQuickSelect,
    required this.onWhen,
    required this.onWho,
  });

  @override
  State<_DestinationStep> createState() => _DestinationStepState();
}

class _DestinationStepState extends State<_DestinationStep> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.fromLTRB(22.w, 10.h, 22.w, 0),
    decoration: BoxDecoration(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(28.r),
      boxShadow: [
        BoxShadow(
          color: AppColor.black.withValues(alpha: .08),
          blurRadius: 16,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: ListView(
      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 32.h),
      children: [
        AppTextWidget.legacy(
          'Where?',
          style: TextStyle(
            fontSize: 20.sp,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        SizedBox(height: 24.h),
        TextField(
          controller: _controller,
          onChanged: (value) =>
              context.read<SearchBloc>().add(SearchSuggestionsChanged(value)),
          onSubmitted: (value) {
            final label = value.trim();
            if (label.isNotEmpty) widget.onSelect(_parseDestination(label));
          },
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded),
            hintText: 'Search destinations',
            filled: true,
            fillColor: AppColor.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(color: AppColor.textSecondary, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(color: AppColor.textSecondary, width: 1.2),
            ),
          ),
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchSuggestionsLoading) {
              return Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: const LinearProgressIndicator(),
              );
            }
            if (state is! SearchSuggestionsLoaded ||
                state.suggestions.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
              child: Column(
                children: state.suggestions
                    .map(
                      (suggestion) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: AppColor.tertiary,
                          child: Icon(
                            Icons.location_on_outlined,
                            color: AppColor.primary,
                          ),
                        ),
                        title: AppTextWidget.legacy(suggestion.label),
                        subtitle: AppTextWidget.legacy(
                          '${suggestion.propertyCount} stays',
                        ),
                        onTap: () {
                          _controller.text = suggestion.label;
                          widget.onQuickSelect(
                            _DestinationSelection(
                              label: suggestion.label,
                              city: suggestion.city,
                              country: suggestion.country,
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
        SizedBox(height: 28.h),
        AppTextWidget.legacy(
          'Recent searches',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        _DestinationTile(
          title: 'North Goa',
          subtitle: 'Week in Oct · 1 guest',
          icon: Icons.beach_access_outlined,
          onTap: () => widget.onQuickSelect(_parseDestination('North Goa')),
        ),
        SizedBox(height: 16.h),
        AppTextWidget.legacy(
          'Suggested destinations',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        for (final item in const [
          ('Nearby', 'Find what’s around you', Icons.near_me_outlined),
          (
            'Calangute, Goa',
            'A short distance from your North Goa search',
            Icons.location_city_outlined,
          ),
          (
            'South Goa, Goa',
            'Guests interested in North Goa also search here',
            Icons.park_outlined,
          ),
        ])
          _DestinationTile(
            title: item.$1,
            subtitle: item.$2,
            icon: item.$3,
            onTap: () => widget.onQuickSelect(_parseDestination(item.$1)),
          ),
        SizedBox(height: 8.h),
        _CollapsedSearchRow(
          label: 'When',
          value: 'Add dates',
          onTap: widget.onWhen,
        ),
        _CollapsedSearchRow(
          label: 'Who',
          value: 'Add guests',
          onTap: widget.onWho,
        ),
      ],
    ),
  );

  static _DestinationSelection _parseDestination(String value) {
    final parts = value.split(',').map((part) => part.trim()).toList();
    return _DestinationSelection(
      label: value,
      city: parts.first,
      country: parts.length > 1 ? parts.last : '',
    );
  }
}

class _CollapsedSearchRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _CollapsedSearchRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 10.h),
    child: Material(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 17.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColor.divider),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: .06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextWidget.legacy(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColor.textSecondary,
                ),
              ),
              AppTextWidget.legacy(
                value,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _DestinationTile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _DestinationTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12.r),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 13.h),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: _tileColor(icon),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: AppColor.primary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.legacy(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                AppTextWidget.legacy(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColor.textSecondary),
        ],
      ),
    ),
  );

  static Color _tileColor(IconData icon) => switch (icon) {
    Icons.near_me_outlined => const Color(0xFFEAF3FA),
    Icons.park_outlined => const Color(0xFFEAF5EC),
    _ => const Color(0xFFF7F3EC),
  };
}

class _DatesStep extends StatefulWidget {
  final DateTime? checkIn, checkOut;
  final bool flexible;
  final String flexibleDuration;
  final DateTime? flexibleMonth;
  final int flexibilityDays;
  final void Function(DateTime start, DateTime? end) onChanged;
  final ValueChanged<bool> onFlexibleChanged;
  final ValueChanged<String> onFlexibleDurationChanged;
  final ValueChanged<DateTime> onFlexibleMonthChanged;
  final ValueChanged<int> onFlexibilityDaysChanged;
  final VoidCallback onReset;
  final VoidCallback onNext;
  const _DatesStep({
    required this.checkIn,
    required this.checkOut,
    required this.flexible,
    required this.flexibleDuration,
    required this.flexibleMonth,
    required this.flexibilityDays,
    required this.onChanged,
    required this.onFlexibleChanged,
    required this.onFlexibleDurationChanged,
    required this.onFlexibleMonthChanged,
    required this.onFlexibilityDaysChanged,
    required this.onReset,
    required this.onNext,
  });

  @override
  State<_DatesStep> createState() => _DatesStepState();
}

class _DatesStepState extends State<_DatesStep> {
  late bool selectingCheckout;

  @override
  void initState() {
    super.initState();
    selectingCheckout = widget.checkIn != null && widget.checkOut == null;
  }

  void _selectDate(DateTime date) {
    final start = widget.checkIn;
    if (start == null || widget.checkOut != null) {
      widget.onChanged(date, null);
      setState(() => selectingCheckout = true);
    } else if (date.isAfter(start)) {
      widget.onChanged(start, date);
      setState(() => selectingCheckout = false);
    } else {
      widget.onChanged(date, null);
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 28.h),
    children: [
      AppTextWidget.legacy(
        'When?',
        style: TextStyle(
          fontSize: 23.sp,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
      ),
      SizedBox(height: 18.h),
      Container(
        padding: EdgeInsets.all(4.p),
        decoration: BoxDecoration(
          color: const Color(0xFFECECEC),
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Row(
          children: [
            _DateMode(
              label: 'Dates',
              active: !widget.flexible,
              onTap: () => widget.onFlexibleChanged(false),
            ),
            _DateMode(
              label: 'Flexible',
              active: widget.flexible,
              onTap: () => widget.onFlexibleChanged(true),
            ),
          ],
        ),
      ),
      if (widget.flexible)
        _FlexibleDatesPanel(
          selectedDuration: widget.flexibleDuration,
          selectedMonth: widget.flexibleMonth,
          onDurationChanged: widget.onFlexibleDurationChanged,
          onMonthChanged: widget.onFlexibleMonthChanged,
        )
      else ...[
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(26.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: .08),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CalendarDatePicker(
            key: ValueKey(widget.checkIn ?? DateTime.now()),
            initialDate: widget.checkIn ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 730)),
            onDateChanged: _selectDate,
          ),
        ),
        SizedBox(height: 12.h),
        AppTextWidget.legacy(
          selectingCheckout
              ? 'Select your check-out date'
              : 'Select your check-in date',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 14.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _DateChip(
                label: 'Exact dates',
                active: widget.flexibilityDays == 0,
                onTap: () => widget.onFlexibilityDaysChanged(0),
              ),
              _DateChip(
                label: '± 1 day',
                active: widget.flexibilityDays == 1,
                onTap: () => widget.onFlexibilityDaysChanged(1),
              ),
              _DateChip(
                label: '± 2 days',
                active: widget.flexibilityDays == 2,
                onTap: () => widget.onFlexibilityDaysChanged(2),
              ),
              _DateChip(
                label: '± 3 days',
                active: widget.flexibilityDays == 3,
                onTap: () => widget.onFlexibilityDaysChanged(3),
              ),
            ],
          ),
        ),
      ],
    ],
  );
}

class _FlexibleDatesPanel extends StatelessWidget {
  final String selectedDuration;
  final DateTime? selectedMonth;
  final ValueChanged<String> onDurationChanged;
  final ValueChanged<DateTime> onMonthChanged;

  const _FlexibleDatesPanel({
    required this.selectedDuration,
    required this.selectedMonth,
    required this.onDurationChanged,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = List.generate(
      12,
      (index) => DateTime(now.year, now.month + index),
    );
    final selectedIndex = selectedMonth == null
        ? 0
        : months.indexWhere(
            (month) =>
                month.year == selectedMonth!.year &&
                month.month == selectedMonth!.month,
          );
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: .08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget.legacy(
            'How long would you like to stay?',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _FlexibleChoice(
                label: 'Weekend',
                active: selectedDuration == 'weekend',
                onTap: () => onDurationChanged('weekend'),
              ),
              _FlexibleChoice(
                label: 'Week',
                active: selectedDuration == 'week',
                onTap: () => onDurationChanged('week'),
              ),
              _FlexibleChoice(
                label: 'Month',
                active: selectedDuration == 'month',
                onTap: () => onDurationChanged('month'),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 22.h),
            child: Divider(color: AppColor.divider, height: 1),
          ),
          AppTextWidget.legacy(
            'Go anytime',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 118.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(right: 4.w),
              physics: const BouncingScrollPhysics(),
              itemCount: months.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (_, index) => GestureDetector(
                onTap: () => onMonthChanged(months[index]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 108.w,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? const Color(0xFFF7F7F7)
                        : AppColor.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: selectedIndex == index
                          ? AppColor.textPrimary
                          : AppColor.divider,
                      width: selectedIndex == index ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 25.sp,
                        color: AppColor.textSecondary,
                      ),
                      SizedBox(height: 8.h),
                      AppTextWidget.legacy(
                        months[index].monthName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppTextWidget.legacy(
                        '${months[index].year}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on DateTime {
  String get monthName => const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ][month - 1];
}

class _FlexibleChoice extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FlexibleChoice({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFF7F7F7) : AppColor.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: active ? AppColor.textPrimary : AppColor.divider,
        ),
      ),
      child: AppTextWidget.legacy(
        label,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

class _DateChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;
  const _DateChip({required this.label, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: active ? AppColor.textPrimary : AppColor.divider,
          width: active ? 1.5 : 1,
        ),
      ),
      child: AppTextWidget.legacy(
        label,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

class _DateMode extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _DateMode({
    required this.label,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: active ? AppColor.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9.r),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: .08),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: AppTextWidget.legacy(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: active ? AppColor.textPrimary : AppColor.textSecondary,
          ),
        ),
      ),
    ),
  );
}

class _GuestsStep extends StatelessWidget {
  final int adults;
  final int children;
  final int infants;
  final int pets;
  final ValueChanged<int> onAdultsChanged;
  final ValueChanged<int> onChildrenChanged;
  final ValueChanged<int> onInfantsChanged;
  final ValueChanged<int> onPetsChanged;
  final VoidCallback onSearch;
  const _GuestsStep({
    required this.adults,
    required this.children,
    required this.infants,
    required this.pets,
    required this.onAdultsChanged,
    required this.onChildrenChanged,
    required this.onInfantsChanged,
    required this.onPetsChanged,
    required this.onSearch,
  });
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 28.h),
    children: [
      AppTextWidget.legacy(
        'Who?',
        style: TextStyle(
          fontSize: 20.sp,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
      ),
      SizedBox(height: 16.h),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: .09),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            _GuestCounter(
              label: 'Adults',
              hint: 'Ages 13 or above',
              count: adults,
              onChanged: onAdultsChanged,
            ),
            const Divider(height: 1),
            _GuestCounter(
              label: 'Children',
              hint: 'Ages 2–12',
              count: children,
              onChanged: onChildrenChanged,
            ),
            const Divider(height: 1),
            _GuestCounter(
              label: 'Infants',
              hint: 'Under 2',
              count: infants,
              onChanged: onInfantsChanged,
            ),
            const Divider(height: 1),
            _GuestCounter(
              label: 'Pets',
              hint: 'Bringing a service animal?',
              count: pets,
              onChanged: onPetsChanged,
            ),
          ],
        ),
      ),
    ],
  );
}

class _GuestCounter extends StatelessWidget {
  final String label, hint;
  final int count;
  final ValueChanged<int>? onChanged;
  const _GuestCounter({
    required this.label,
    required this.hint,
    required this.count,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 16.h),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.legacy(
                label,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4.h),
              AppTextWidget.legacy(
                hint,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColor.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _CounterButton(
          icon: Icons.remove,
          enabled: count > 0 && onChanged != null,
          onTap: () => onChanged?.call(count - 1),
        ),
        SizedBox(
          width: 28.w,
          child: AppTextWidget.legacy(
            '$count',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
        ),
        _CounterButton(
          icon: Icons.add,
          enabled: onChanged != null,
          onTap: () => onChanged?.call(count + 1),
        ),
      ],
    ),
  );
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _CounterButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: enabled ? onTap : null,
    borderRadius: BorderRadius.circular(20.r),
    child: Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled ? const Color(0xFFF1F1F1) : const Color(0xFFF7F7F7),
      ),
      child: Icon(
        icon,
        size: 17.sp,
        color: enabled ? AppColor.textPrimary : AppColor.grey,
      ),
    ),
  );
}

class _ResultsStep extends StatefulWidget {
  final SearchQuery query;
  final VoidCallback onFilter;
  const _ResultsStep({required this.query, required this.onFilter});

  @override
  State<_ResultsStep> createState() => _ResultsStepState();
}

class _ResultsStepState extends State<_ResultsStep> {
  bool showMap = false;

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 32.h),
    children: [
      BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading || state is SearchInitial) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is SearchError) {
            return _SearchMessage(
              message: state.message,
              onRetry: () => context.read<SearchBloc>().add(
                SearchProperties(widget.query),
              ),
            );
          }
          final results = state is SearchLoaded
              ? state.results
              : const SearchResultsModel();
          if (results.items.isEmpty) {
            return const _SearchMessage(
              message: 'No stays found for this search.',
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppTextWidget.legacy(
                      '${results.total} ${results.total == 1 ? 'place' : 'places'} to stay',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'List view',
                    onPressed: () => setState(() => showMap = false),
                    icon: Icon(
                      Icons.view_list_rounded,
                      color: showMap
                          ? AppColor.textSecondary
                          : AppColor.textPrimary,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Map view',
                    onPressed: () => setState(() => showMap = true),
                    icon: Icon(
                      Icons.map_outlined,
                      color: showMap
                          ? AppColor.textPrimary
                          : AppColor.textSecondary,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: widget.onFilter,
                    icon: Icon(Icons.tune_rounded, size: 16.sp),
                    label: AppTextWidget.legacy(
                      'Filters',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.textPrimary,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      minimumSize: Size(0, 36.h),
                      side: const BorderSide(color: AppColor.divider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              if (showMap)
                _MapResults(properties: results.items)
              else
                for (final item in results.items) _ResultCard(property: item),
            ],
          );
        },
      ),
    ],
  );
}

class _MapResults extends StatelessWidget {
  final List<ExploreProperty> properties;
  const _MapResults({required this.properties});

  @override
  Widget build(BuildContext context) => Container(
    height: 460.h,
    margin: EdgeInsets.only(top: 4.h),
    decoration: BoxDecoration(
      color: const Color(0xFFE8E5DE),
      borderRadius: BorderRadius.circular(22.r),
      image: const DecorationImage(
        image: NetworkImage(
          'https://images.unsplash.com/photo-1524666041070-9f5b8c6c7f3d?auto=format&fit=crop&w=900&q=80',
        ),
        fit: BoxFit.cover,
        opacity: .22,
      ),
    ),
    child: Stack(
      children: [
        for (var index = 0; index < properties.length && index < 12; index++)
          Positioned(
            left: 20.w + ((index * 67.w) % 250.w),
            top: 28.h + ((index * 89.h) % 330.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: .16),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: AppTextWidget.legacy(
                '${properties[index].currency} ${properties[index].pricePerNight.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 16.h,
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColor.white.withValues(alpha: .94),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: AppTextWidget.legacy(
              '${properties.length} stays in this area',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    ),
  );
}

class _SearchMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const _SearchMessage({required this.message, this.onRetry});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 60.h),
    child: Center(
      child: Column(
        children: [
          AppTextWidget.legacy(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            SizedBox(height: 12.h),
            TextButton(
              onPressed: onRetry,
              child: const AppTextWidget.legacy('Retry'),
            ),
          ],
        ],
      ),
    ),
  );
}

class _ResultCard extends StatelessWidget {
  final ExploreProperty property;
  const _ResultCard({required this.property});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: property.id.isEmpty
        ? null
        : () => context.push(
            RouteName.propertyView.replaceFirst(':propertyId', property.id),
          ),
    child: Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: AspectRatio(
                  aspectRatio: 1.08,
                  child: Image.network(
                    property.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColor.greyExtraLight,
                      child: Icon(Icons.home_outlined, size: 42.sp),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    property.isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 20.sp,
                    color: property.isLiked
                        ? AppColor.primary
                        : AppColor.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          AppTextWidget.legacy(
            property.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          AppTextWidget.legacy(
            property.location,
            style: TextStyle(fontSize: 13.sp, color: AppColor.textSecondary),
          ),
          SizedBox(height: 5.h),
          AppTextWidget.legacy(
            '${property.currency} ${property.pricePerNight.toStringAsFixed(0)} / night',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}
