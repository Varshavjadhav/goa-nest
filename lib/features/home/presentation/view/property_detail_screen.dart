import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';

class PropertyDetailScreen extends StatelessWidget {
  const PropertyDetailScreen({super.key});
  static const photos = [
    'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=1200',
    'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=800',
    'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 285,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: const FlexibleSpaceBar(background: _HeroImage()),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 105),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'Modern villa with pool',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Entire villa in North Goa, India',
                  style: TextStyle(fontSize: 13, color: Color(0xff555555)),
                ),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    Icon(Icons.star, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '· 24 reviews',
                      style: TextStyle(
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const _StaySummary(),
                const Divider(height: 35),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/100?img=47',
                    ),
                  ),
                  title: Text(
                    'Hosted by Anika',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Superhost · 5 years hosting',
                    style: TextStyle(fontSize: 12, color: Color(0xff666666)),
                  ),
                ),
                const Divider(height: 35),
                const Text(
                  'What this place offers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                const _AmenityGrid(),
                const SizedBox(height: 14),
                const Text(
                  'Show all 12 amenities',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const Divider(height: 35),
                const Text(
                  'About this place',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Wake up to open skies and relaxed coastal living in this beautiful Goa retreat. Enjoy a private pool, thoughtful interiors, and easy access to the beach, restaurants, and local markets.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.55,
                    color: Color(0xff444444),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Show more',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const Divider(height: 40),
                const Text(
                  'Where you’ll be',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 5),
                const Text(
                  'North Goa, Goa, India',
                  style: TextStyle(fontSize: 13, color: Color(0xff555555)),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 190,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: const Color(0xffdce8e5)),
                        const CustomPaint(painter: _MapPainter()),
                        const Center(
                          child: Icon(
                            Icons.location_on,
                            color: Color(0xffc90032),
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 40),
                const Text(
                  'Guest reviews',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                const _ReviewCard(
                  name: 'Rohan',
                  text:
                      'Beautiful home, thoughtful host, and the pool was perfect for a relaxing weekend.',
                ),
                const _ReviewCard(
                  name: 'Maya',
                  text:
                      'Exactly as pictured. The location made it easy to explore North Goa.',
                ),
                const Text(
                  'Show all 24 reviews',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const Divider(height: 40),
                const Text(
                  'Things to know',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                const _InfoRow(
                  icon: Icons.access_time,
                  title: 'Check-in after 2:00 pm',
                  subtitle: 'Checkout before 11:00 am',
                ),
                const _InfoRow(
                  icon: Icons.pets_outlined,
                  title: 'Pets allowed',
                  subtitle: 'Please let your host know',
                ),
                const _InfoRow(
                  icon: Icons.smoke_free,
                  title: 'No smoking',
                  subtitle: 'Smoking is not allowed indoors',
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Color(0x18000000), blurRadius: 12)],
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '₹18,500 night',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Add dates for prices',
                      style: TextStyle(fontSize: 11, color: Color(0xff666666)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 132,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => context.push(
                    RouteName.checkoutView.replaceFirst(
                      ':propertyId',
                      'modern-villa',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffc90032),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Reserve',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Image.network(
        PropertyDetailScreen.photos.first,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: const Color(0xffeeeeee)),
      ),
      Positioned(
        top: MediaQuery.paddingOf(context).top + 8,
        left: 12,
        child: _HeaderButton(
          icon: Icons.arrow_back,
          onTap: () => context.pop(),
        ),
      ),
      Positioned(
        top: MediaQuery.paddingOf(context).top + 8,
        right: 12,
        child: Row(
          children: [
            _HeaderButton(icon: Icons.ios_share, onTap: () {}),
            const SizedBox(width: 8),
            _HeaderButton(icon: Icons.favorite_border, onTap: () {}),
          ],
        ),
      ),
      Positioned(
        bottom: 16,
        right: 16,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .7),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            child: Text(
              '1 / 8',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ),
      ),
    ],
  );
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: const CircleBorder(),
    elevation: 2,
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 38,
        height: 38,
        child: Icon(icon, size: 19, color: Colors.black),
      ),
    ),
  );
}

class _StaySummary extends StatelessWidget {
  const _StaySummary();
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(
        child: Text(
          '8 guests · 4 bedrooms · 5 beds · 3 baths',
          style: TextStyle(fontSize: 13, color: Color(0xff444444)),
        ),
      ),
      Icon(Icons.verified_outlined, size: 20),
    ],
  );
}

class _ReviewCard extends StatelessWidget {
  final String name, text;
  const _ReviewCard({required this.name, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xffeeeeee),
          child: Text(name.substring(0, 1)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text('★★★★★', style: TextStyle(fontSize: 11)),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Color(0xff555555),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Color(0xff666666)),
            ),
          ],
        ),
      ],
    ),
  );
}

class _AmenityGrid extends StatelessWidget {
  const _AmenityGrid();
  @override
  Widget build(BuildContext context) => const Column(
    children: [
      Row(
        children: [
          Expanded(
            child: _Amenity(icon: Icons.pool_outlined, text: 'Private pool'),
          ),
          Expanded(
            child: _Amenity(icon: Icons.wifi, text: 'Wifi'),
          ),
        ],
      ),
      SizedBox(height: 18),
      Row(
        children: [
          Expanded(
            child: _Amenity(icon: Icons.kitchen_outlined, text: 'Kitchen'),
          ),
          Expanded(
            child: _Amenity(
              icon: Icons.local_parking_outlined,
              text: 'Free parking',
            ),
          ),
        ],
      ),
    ],
  );
}

class _Amenity extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Amenity({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 21),
      const SizedBox(width: 12),
      Text(text, style: const TextStyle(fontSize: 13)),
    ],
  );
}

class _MapPainter extends CustomPainter {
  const _MapPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: .75)
      ..strokeWidth = 2;
    for (var i = 1; i < 6; i++)
      canvas.drawLine(
        Offset(size.width * i / 6, 0),
        Offset(size.width * i / 6, size.height),
        p,
      );
    for (var i = 1; i < 4; i++)
      canvas.drawLine(
        Offset(0, size.height * i / 4),
        Offset(size.width, size.height * i / 4),
        p,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
