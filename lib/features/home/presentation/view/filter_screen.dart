import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(backgroundColor: const Color(0xfffafafa), surfaceTintColor: Colors.transparent, elevation: 0, leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)), title: const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), actions: [TextButton(onPressed: _clear, child: const Text('Clear all', style: TextStyle(color: Color(0xffc90032))))]),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 10, 16, 30), children: [
        const Text('Price range', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), const SizedBox(height: 5), const Text('Nightly prices before fees and taxes', style: TextStyle(fontSize: 12, color: Color(0xff777777))),
        RangeSlider(values: price, min: 1500, max: 30000, divisions: 19, activeColor: const Color(0xffc90032), labels: RangeLabels('₹${price.start.round()}', '₹${price.end.round()}'), onChanged: (value) => setState(() => price = value)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('₹${price.start.round()}'), Text('₹${price.end.round()}')]),
        const Divider(height: 40), const Text('Property type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), const SizedBox(height: 12), _chips(['Villa', 'Apartment', 'Hotel', 'Guesthouse'], selectedTypes),
        const Divider(height: 40), const Text('Amenities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), const SizedBox(height: 12), _chips(['Pool', 'Wifi', 'Kitchen', 'Air conditioning', 'Beachfront', 'Free parking'], selectedAmenities),
        const Divider(height: 40), const Text('Rooms and beds', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), const SizedBox(height: 12), const _Counter(label: 'Bedrooms'), const _Counter(label: 'Beds'), const _Counter(label: 'Bathrooms'),
      ],),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffc90032), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
              child: const Text('Show 1,000+ stays', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
  Widget _chips(List<String> values, Set<String> selected) => Wrap(spacing: 8, runSpacing: 8, children: values.map((value) => _chip(value, selected)).toList());
  Widget _chip(String value, Set<String> selected) => FilterChip(label: Text(value), selected: selected.contains(value), selectedColor: const Color(0xffffd9df), checkmarkColor: const Color(0xffc90032), onSelected: (on) => setState(() { if (on) { selected.add(value); } else { selected.remove(value); } }));
  void _clear() => setState(() { price = const RangeValues(1500, 30000); selectedTypes.clear(); selectedAmenities.clear(); });
}

class _Counter extends StatelessWidget { final String label; const _Counter({required this.label}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [Expanded(child: Text(label, style: const TextStyle(fontSize: 14))), IconButton(onPressed: () {}, icon: const Icon(Icons.remove_circle_outline)), const Text('0'), IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline))])); }
