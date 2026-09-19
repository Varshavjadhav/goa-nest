import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/search_model.dart';
import '../../data/model/explore_model.dart';
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
  int guests = 1;
  SearchQuery searchQuery = const SearchQuery(maxGuests: 1);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.surface,
    body: SafeArea(
      child: Column(
        children: [
          _TopBar(
            title: switch (stage) {
              _SearchStage.destination => 'Where to?',
              _SearchStage.dates => 'When?',
              _SearchStage.guests => 'Who?',
              _SearchStage.results =>
                destination.isEmpty ? 'Stays' : 'Stays in $destination',
            },
            onBack: () {
              if (stage != _SearchStage.destination) {
                setState(() => stage = _previous());
              } else if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteName.homeView);
              }
            },
            onFilter: stage == _SearchStage.results
                ? () => context.push(RouteName.filterView)
                : null,
          ),
          if (stage != _SearchStage.destination)
            _SearchSummary(
              destination: destination,
              checkIn: checkIn,
              checkOut: checkOut,
              guests: guests,
            ),
          Expanded(child: _content()),
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
        );
      case _SearchStage.dates:
        return _DatesStep(
          checkIn: checkIn,
          checkOut: checkOut,
          onChanged: (start, end) => setState(() {
            checkIn = start;
            checkOut = end;
            searchQuery = searchQuery.copyWith(
              checkIn: start,
              checkOut: end,
              clearCheckOut: end == null,
            );
          }),
          onNext: () => setState(() => stage = _SearchStage.guests),
        );
      case _SearchStage.guests:
        return _GuestsStep(
          guests: guests,
          onChanged: (value) => setState(() {
            guests = value;
            searchQuery = searchQuery.copyWith(maxGuests: value);
          }),
          onSearch: () {
            context.read<SearchBloc>().add(SearchProperties(searchQuery));
            setState(() => stage = _SearchStage.results);
          },
        );
      case _SearchStage.results:
        return _ResultsStep(
          query: searchQuery,
          onFilter: () => context.push(RouteName.filterView),
        );
    }
  }
}

class _SearchSummary extends StatelessWidget {
  final String destination;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int guests;

  const _SearchSummary({
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
    child: Row(
      children: [
        _SummaryItem(
          icon: Icons.location_on_outlined,
          label: destination.isEmpty ? 'Anywhere' : destination,
        ),
        const _SummaryDivider(),
        _SummaryItem(
          icon: Icons.calendar_today_outlined,
          label: checkIn == null
              ? 'Any week'
              : checkOut == null
              ? '${_shortDate(checkIn!)} · Add checkout'
              : '${_shortDate(checkIn!)} – ${_shortDate(checkOut!)}',
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
          child: Text(
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

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback? onFilter;
  const _TopBar({required this.title, required this.onBack, this.onFilter});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
    child: Row(
      children: [
        IconButton(
          onPressed: onBack,
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_back_rounded, color: AppColor.textPrimary),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
        ),
        if (onFilter != null)
          IconButton(
            onPressed: onFilter,
            icon: Icon(Icons.tune_rounded, color: AppColor.textPrimary),
          )
        else
          SizedBox(width: 48.w),
      ],
    ),
  );
}

class _DestinationStep extends StatefulWidget {
  final ValueChanged<_DestinationSelection> onSelect;
  const _DestinationStep({required this.onSelect});

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
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 32.h),
    children: [
      Text(
        'Where do you want to stay?',
        style: TextStyle(
          fontSize: 24.sp,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
      ),
      SizedBox(height: 8.h),
      Text(
        'Search by city, landmark, or neighborhood',
        style: TextStyle(fontSize: 14.sp, color: AppColor.textSecondary),
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
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColor.textPrimary, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColor.textPrimary, width: 1.5),
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
          if (state is! SearchSuggestionsLoaded || state.suggestions.isEmpty) {
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
                      title: Text(suggestion.label),
                      subtitle: Text('${suggestion.propertyCount} stays'),
                      onTap: () {
                        _controller.text = suggestion.label;
                        widget.onSelect(
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
      Text(
        'Popular destinations',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
      ),
      SizedBox(height: 12.h),
      for (final item in const [
        (
          'Goa, India',
          'For sun, sand, and unforgettable stays',
          Icons.beach_access_rounded,
        ),
        (
          'North Goa',
          'Lively beaches and vibrant nightlife',
          Icons.wb_sunny_outlined,
        ),
        (
          'South Goa',
          'Quiet beaches and slow mornings',
          Icons.water_drop_outlined,
        ),
        (
          'Panaji',
          'Culture, food, and riverfront walks',
          Icons.location_city_outlined,
        ),
      ])
        _DestinationTile(
          title: item.$1,
          subtitle: item.$2,
          icon: item.$3,
          onTap: () => widget.onSelect(_parseDestination(item.$1)),
        ),
    ],
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
              color: AppColor.tertiary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColor.primary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
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
}

class _DatesStep extends StatefulWidget {
  final DateTime? checkIn, checkOut;
  final void Function(DateTime start, DateTime? end) onChanged;
  final VoidCallback onNext;
  const _DatesStep({
    required this.checkIn,
    required this.checkOut,
    required this.onChanged,
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
    padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 32.h),
    children: [
      Text(
        'When do you want to stay?',
        style: TextStyle(
          fontSize: 23.sp,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
      ),
      SizedBox(height: 8.h),
      Text(
        'Choose your dates to see available stays',
        style: TextStyle(fontSize: 14.sp, color: AppColor.textSecondary),
      ),
      SizedBox(height: 18.h),
      Container(
        padding: EdgeInsets.all(4.p),
        decoration: BoxDecoration(
          color: AppColor.greyExtraLight,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            _DateMode(label: 'Dates', active: true),
            _DateMode(label: 'Months'),
            _DateMode(label: 'Flexible'),
          ],
        ),
      ),
      SizedBox(height: 16.h),
      Row(
        children: [
          Expanded(
            child: _DateBox(
              label: 'CHECK-IN',
              value: _format(widget.checkIn),
              active: !selectingCheckout,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _DateBox(
              label: 'CHECK-OUT',
              value: _format(widget.checkOut),
              active: selectingCheckout,
            ),
          ),
        ],
      ),
      SizedBox(height: 14.h),
      Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColor.divider),
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
      Text(
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
      SizedBox(height: 16.h),
      _PrimaryButton(
        label: 'Next',
        enabled: widget.checkIn != null && widget.checkOut != null,
        onPressed: widget.onNext,
      ),
    ],
  );
  static String _format(DateTime? date) =>
      date == null ? 'Add date' : '${date.day}/${date.month}/${date.year}';
}

class _DateMode extends StatelessWidget {
  final String label;
  final bool active;

  const _DateMode({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) => Expanded(
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
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: active ? AppColor.textPrimary : AppColor.textSecondary,
        ),
      ),
    ),
  );
}

class _DateBox extends StatelessWidget {
  final String label, value;
  final bool active;
  const _DateBox({
    required this.label,
    required this.value,
    this.active = false,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.p),
    decoration: BoxDecoration(
      color: AppColor.white,
      border: Border.all(
        color: active ? AppColor.textPrimary : AppColor.divider,
        width: active ? 1.5 : 1,
      ),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        Icon(Icons.calendar_today_outlined, color: AppColor.textSecondary),
        SizedBox(width: 14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textSecondary,
                letterSpacing: .7,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _GuestsStep extends StatelessWidget {
  final int guests;
  final ValueChanged<int> onChanged;
  final VoidCallback onSearch;
  const _GuestsStep({
    required this.guests,
    required this.onChanged,
    required this.onSearch,
  });
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 32.h),
    children: [
      Text(
        "Who's coming?",
        style: TextStyle(
          fontSize: 24.sp,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
      ),
      SizedBox(height: 8.h),
      Text(
        'Add guests to find the right space for your trip',
        style: TextStyle(fontSize: 14.sp, color: AppColor.textSecondary),
      ),
      SizedBox(height: 20.h),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColor.divider),
        ),
        child: Column(
          children: [
            _GuestCounter(
              label: 'Adults',
              hint: 'Ages 13 or above',
              count: guests,
              onChanged: onChanged,
            ),
            const Divider(height: 1),
            const _GuestCounter(label: 'Children', hint: 'Ages 2–12', count: 0),
            const Divider(height: 1),
            const _GuestCounter(label: 'Infants', hint: 'Under 2', count: 0),
            const Divider(height: 1),
            const _GuestCounter(
              label: 'Pets',
              hint: 'Bringing a service animal?',
              count: 0,
            ),
          ],
        ),
      ),
      SizedBox(height: 18.h),
      Text(
        '$guests ${guests == 1 ? 'guest' : 'guests'} selected',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColor.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 12.h),
      _PrimaryButton(
        label: 'Search stays',
        enabled: guests > 0,
        onPressed: onSearch,
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
              Text(
                label,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4.h),
              Text(
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
          child: Text(
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
        border: Border.all(
          color: enabled ? AppColor.textSecondary : AppColor.divider,
        ),
      ),
      child: Icon(
        icon,
        size: 17.sp,
        color: enabled ? AppColor.textPrimary : AppColor.grey,
      ),
    ),
  );
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onPressed;
  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52.h,
    child: ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        disabledBackgroundColor: AppColor.divider,
        foregroundColor: AppColor.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _ResultsStep extends StatelessWidget {
  final SearchQuery query;
  final VoidCallback onFilter;
  const _ResultsStep({required this.query, required this.onFilter});
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
              onRetry: () =>
                  context.read<SearchBloc>().add(SearchProperties(query)),
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
                    child: Text(
                      '${results.total} ${results.total == 1 ? 'place' : 'places'} to stay',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: onFilter,
                    icon: Icon(Icons.tune_rounded, size: 16.sp),
                    label: Text('Filters', style: TextStyle(fontSize: 13.sp)),
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
              for (final item in results.items) _ResultCard(property: item),
            ],
          );
        },
      ),
    ],
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
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            SizedBox(height: 12.h),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
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
          Text(
            property.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            property.location,
            style: TextStyle(fontSize: 13.sp, color: AppColor.textSecondary),
          ),
          SizedBox(height: 5.h),
          Text(
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
