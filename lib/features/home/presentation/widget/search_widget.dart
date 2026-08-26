import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';

const _pink = Color(0xffba0036);
const _coral = Color(0xffff385c);
const _ink = Color(0xff222222);
const _muted = Color(0xff717171);
const _surface = Color(0xfff9f9f9);

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

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _surface,
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
          }),
          onNext: () => setState(() => stage = _SearchStage.guests),
        );
      case _SearchStage.guests:
        return _GuestsStep(
          guests: guests,
          onChanged: (value) => setState(() => guests = value),
          onSearch: () => setState(() => stage = _SearchStage.results),
        );
      case _SearchStage.results:
        return _ResultsStep(onFilter: () => context.push(RouteName.filterView));
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
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: Row(
      children: [
        IconButton(
          onPressed: onBack,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back_rounded, color: _ink),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
        ),
        if (onFilter != null)
          IconButton(
            onPressed: onFilter,
            icon: const Icon(Icons.tune_rounded, color: _ink),
          )
        else
          const SizedBox(width: 48),
      ],
    ),
  );
}

class _DestinationStep extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const _DestinationStep({required this.onSelect});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
    children: [
      const Text(
        'Where do you want to stay?',
        style: TextStyle(
          fontSize: 25,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: _ink,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Search by city, landmark, or neighborhood',
        style: TextStyle(fontSize: 14, color: _muted),
      ),
      const SizedBox(height: 24),
      Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _ink, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.search_rounded),
            SizedBox(width: 12),
            Text(
              'Search destinations',
              style: TextStyle(color: _muted, fontSize: 15),
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      const Text(
        'Popular destinations',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _ink,
        ),
      ),
      const SizedBox(height: 12),
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
          onTap: () => onSelect(item.$1),
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
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xffffe5e8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _pink),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: _muted),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: _muted),
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
    padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
    children: [
      const Text(
        'When are you going?',
        style: TextStyle(
          fontSize: 25,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: _ink,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Choose your dates to see available stays',
        style: TextStyle(fontSize: 14, color: _muted),
      ),
      const SizedBox(height: 22),
      _DateBox(label: 'CHECK-IN', value: _format(checkIn)),
      const SizedBox(height: 12),
      _DateBox(label: 'CHECK-OUT', value: _format(checkOut)),
      const SizedBox(height: 20),
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
        label: const Text('Choose dates'),
        style: OutlinedButton.styleFrom(
          foregroundColor: _ink,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: Color(0xffdddddd)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      const SizedBox(height: 18),
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
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xffdddddd)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.calendar_today_outlined, color: _muted),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _muted,
                letterSpacing: .7,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _ink,
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
    padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
    children: [
      const Text(
        "Who's coming?",
        style: TextStyle(
          fontSize: 25,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: _ink,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Add guests to find the right space for your trip',
        style: TextStyle(fontSize: 14, color: _muted),
      ),
      const SizedBox(height: 28),
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
      const SizedBox(height: 22),
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
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(hint, style: const TextStyle(fontSize: 12, color: _muted)),
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
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
    height: 54,
    child: ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _coral,
        disabledBackgroundColor: const Color(0xffdddddd),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _ResultsStep extends StatelessWidget {
  final VoidCallback onFilter;
  const _ResultsStep({required this.onFilter});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              '100+ places to stay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _ink,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: onFilter,
            icon: const Icon(Icons.tune_rounded, size: 16),
            label: const Text('Filters'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _ink,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: const Size(0, 36),
              side: const BorderSide(color: Color(0xffdddddd)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),
      const _ResultCard(
        title: 'Stunning oceanfront villa',
        location: 'North Goa, India',
        price: '₹18,500 night',
        image:
            'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=900',
      ),
      const _ResultCard(
        title: 'Casa Verde Manor',
        location: 'Assagao, Goa',
        price: '₹12,200 night',
        image:
            'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=900',
      ),
    ],
  );
}

class _ResultCard extends StatelessWidget {
  final String title, location, price, image;
  const _ResultCard({
    required this.title,
    required this.location,
    required this.price,
    required this.image,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.push(
      RouteName.propertyView.replaceFirst(':propertyId', 'search-result'),
    ),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 1.08,
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xffeeeeee),
                      child: const Icon(Icons.home_outlined, size: 42),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border_rounded, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(location, style: const TextStyle(fontSize: 13, color: _muted)),
          const SizedBox(height: 5),
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
        ],
      ),
    ),
  );
}
