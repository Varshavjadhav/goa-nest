import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';

const _brand = Color(0xff004c3f);
const _ink = Color(0xff222222);
const _muted = Color(0xff717171);

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int category = 0;
  final categories = const ['All', 'Beach', 'Pool', 'Budget', 'Design'];
  final categoryIcons = const [
    Icons.apps_rounded,
    Icons.beach_access_rounded,
    Icons.pool_rounded,
    Icons.sell_outlined,
    Icons.auto_awesome_rounded,
  ];
  final homes = const [
    _HomeData(
      'Azure Bay Retreat',
      'Anjuna, North Goa',
      '₹18,500',
      '4.9',
      'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=900',
    ),
    _HomeData(
      'Casa Verde Manor',
      'Assagao, Goa',
      '₹12,200',
      '4.8',
      'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=900',
    ),
    _HomeData(
      'The Canopy Nest',
      'Agonda, South Goa',
      '₹9,800',
      '5.0',
      'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=900',
    ),
  ];

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xfff9f9f9),
    child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 105),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const _HomeHeader(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => context.push(RouteName.searchView),
                child: const _HomeSearch(),
              ),
              const SizedBox(height: 19),
              SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) => _CategoryChip(
                    label: categories[index],
                    icon: categoryIcons[index],
                    selected: index == category,
                    onTap: () => setState(() => category = index),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Featured Escapes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Curated collection for your next stay',
                style: TextStyle(fontSize: 12, color: _muted),
              ),
              const SizedBox(height: 17),
              for (final home in homes) _PropertyCard(home: home),
              const SizedBox(height: 2),
              const Text(
                'Discover More',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 15),
              const _DiscoverCard(),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(
                    child: _SmallDiscover(
                      icon: Icons.sailing_rounded,
                      title: 'Yacht Rentals',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _SmallDiscover(
                      icon: Icons.restaurant_rounded,
                      title: "Chef's Table",
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    ),
  );
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Text(
        'GoNest',
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w800,
          color: _brand,
        ),
      ),
      const Spacer(),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.notifications_none_rounded, color: _ink),
      ),
      const Icon(Icons.tune_rounded, size: 21, color: _ink),
    ],
  );
}

class _HomeSearch extends StatelessWidget {
  const _HomeSearch();
  @override
  Widget build(BuildContext context) => Container(
    height: 54,
    padding: const EdgeInsets.symmetric(horizontal: 17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: const Color(0xffe3e3e3)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: const Row(
      children: [
        Icon(Icons.search_rounded, size: 21, color: _muted),
        SizedBox(width: 12),
        Text('Where in Goa?', style: TextStyle(fontSize: 14, color: _muted)),
        Spacer(),
        Icon(Icons.tune_rounded, size: 19, color: _muted),
      ],
    ),
  );
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? _brand : Colors.white,
    elevation: selected ? 3 : 0,
    shadowColor: _brand.withValues(alpha: .25),
    borderRadius: BorderRadius.circular(24),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? _brand : const Color(0xffdedede),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: selected ? Colors.white : _brand),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white : _ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _HomeData {
  final String title, location, price, rating, image;
  const _HomeData(
    this.title,
    this.location,
    this.price,
    this.rating,
    this.image,
  );
}

class _PropertyCard extends StatelessWidget {
  final _HomeData home;
  const _PropertyCard({required this.home});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.push(
      RouteName.propertyView.replaceFirst(':propertyId', 'modern-villa'),
    ),
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 1.12,
                  child: Image.network(
                    home.image,
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
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .93),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border_rounded, size: 21),
                ),
              ),
              const Positioned(
                bottom: 12,
                left: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _brand,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    child: Text(
                      'PREMIER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  home.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xfff0f3f0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: _brand),
                    const SizedBox(width: 3),
                    Text(
                      home.rating,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: _muted),
              const SizedBox(width: 3),
              Text(
                home.location,
                style: const TextStyle(fontSize: 12, color: _muted),
              ),
            ],
          ),
          const SizedBox(height: 7),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: _ink, fontSize: 13),
              children: [
                TextSpan(
                  text: home.price,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _brand,
                  ),
                ),
                const TextSpan(
                  text: ' / night',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _DiscoverCard extends StatelessWidget {
  const _DiscoverCard();
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: Stack(
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: Image.network(
            'https://images.unsplash.com/photo-1500534623283-312aade485b7?w=900',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: _brand),
          ),
        ),
        const Positioned(
          left: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Private Plantation Tours',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Exclusive back-to-nature experiences',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SmallDiscover extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SmallDiscover({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) => Container(
    height: 112,
    decoration: BoxDecoration(
      color: const Color(0xffeeeeee),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: _brand, size: 28),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _ink,
          ),
        ),
      ],
    ),
  );
}
