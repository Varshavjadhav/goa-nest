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

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  _SearchStage stage = _SearchStage.destination;
  String destination = '';
  DateTime? checkIn, checkOut;
  int guests = 0;
  SearchQuery searchQuery = const SearchQuery();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.surface,
    body: SafeArea(
      child: Column(
        children: [
          _TopBar(
            title: stage == _SearchStage.results ? 'Stays in Goa' : 'Search',
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
          onSelect: (value) => setState(() {
            destination = value;
            searchQuery = searchQuery.copyWith(query: value);
            stage = _SearchStage.dates;
          }),
        );
      case _SearchStage.dates:
        return _DatesStep(
          checkIn: checkIn,
          checkOut: checkOut,
          onChanged: (range) => setState(() {
            checkIn = range.start;
            checkOut = range.end;
            searchQuery = searchQuery.copyWith(
              checkIn: range.start,
              checkOut: range.end,
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
  final ValueChanged<String> onSelect;
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
          if (value.trim().isNotEmpty) widget.onSelect(value.trim());
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
                        widget.onSelect(suggestion.label);
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
          onTap: () => widget.onSelect(item.$1),
        ),
    ],
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

class _DatesStep extends StatelessWidget {
  final DateTime? checkIn, checkOut;
  final ValueChanged<DateTimeRange> onChanged;
  final VoidCallback onNext;
  const _DatesStep({
    required this.checkIn,
    required this.checkOut,
    required this.onChanged,
    required this.onNext,
  });
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 32.h),
    children: [
      Text(
        'When are you going?',
        style: TextStyle(
          fontSize: 24.sp,
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
      SizedBox(height: 22.h),
      _DateBox(label: 'CHECK-IN', value: _format(checkIn)),
      SizedBox(height: 12.h),
      _DateBox(label: 'CHECK-OUT', value: _format(checkOut)),
      SizedBox(height: 20.h),
      OutlinedButton.icon(
        onPressed: () async {
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2027, 12, 31),
          );
          if (range != null) onChanged(range);
        },
        icon: const Icon(Icons.date_range_rounded),
        label: Text('Choose dates', style: TextStyle(fontSize: 14.sp)),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.textPrimary,
          minimumSize: Size.fromHeight(50.h),
          side: const BorderSide(color: AppColor.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
      SizedBox(height: 18.h),
      _PrimaryButton(
        label: 'Next',
        enabled: checkIn != null && checkOut != null,
        onPressed: onNext,
      ),
    ],
  );
  static String _format(DateTime? date) =>
      date == null ? 'Add date' : '${date.day}/${date.month}/${date.year}';
}

class _DateBox extends StatelessWidget {
  final String label, value;
  const _DateBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.p),
    decoration: BoxDecoration(
      color: AppColor.white,
      border: Border.all(color: AppColor.divider),
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
      SizedBox(height: 28.h),
      _GuestCounter(
        label: 'Adults',
        hint: 'Ages 13 or above',
        count: guests,
        onChanged: onChanged,
      ),
      const _GuestCounter(label: 'Children', hint: 'Ages 2–12', count: 0),
      const _GuestCounter(label: 'Infants', hint: 'Under 2', count: 0),
      const _GuestCounter(
        label: 'Pets',
        hint: 'Bringing a service animal?',
        count: 0,
      ),
      SizedBox(height: 22.h),
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
        IconButton(
          onPressed: count > 0 && onChanged != null
              ? () => onChanged!(count - 1)
              : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          '$count',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
        IconButton(
          onPressed: onChanged == null ? null : () => onChanged!(count + 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
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
