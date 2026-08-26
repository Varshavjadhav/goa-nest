import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({super.key});
  static const collections = [
    (
      'Summer Trip',
      '4 saved',
      'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=500',
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
    ),
    (
      'Dream Homes',
      '3 saved',
      'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=500',
      'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=500',
    ),
    (
      'Winter Getaway',
      '1 saved',
      'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=500',
      '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xfffafafa),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xfffafafa),
            surfaceTintColor: Colors.transparent,
            pinned: true,
            elevation: 0,
            title: const Text(
              'Wishlists',
              style: TextStyle(
                color: Color(0xff222222),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Edit',
                  style: TextStyle(color: Color(0xff333333), fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                for (final item in collections) _CollectionCard(item: item),
                const SizedBox(height: 20),
                const Text(
                  'Create new',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _CreateCollection(onTap: () {}),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final (String, String, String, String) item;
  const _CollectionCard({required this.item});
  @override
  Widget build(BuildContext context) {
    final images = item.$4.isEmpty ? [item.$3] : [item.$3, item.$4];
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          RouteName.propertyView.replaceFirst(':propertyId', 'saved-home'),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 148,
                child: Row(
                  children: [
                    Expanded(child: _CollectionImage(url: images[0])),
                    const SizedBox(width: 3),
                    Expanded(
                      child: images.length > 1
                          ? _CollectionImage(url: images[1])
                          : Container(
                              color: const Color(0xffeeeeee),
                              child: const Icon(Icons.home_outlined),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.$1,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              item.$2,
              style: const TextStyle(fontSize: 11, color: Color(0xff777777)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionImage extends StatelessWidget {
  final String url;
  const _CollectionImage({required this.url});
  @override
  Widget build(BuildContext context) => Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => Container(
      color: const Color(0xffeeeeee),
      child: const Icon(Icons.image_outlined, color: Color(0xff999999)),
    ),
  );
}

class _CreateCollection extends StatelessWidget {
  final VoidCallback onTap;
  const _CreateCollection({required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      height: 112,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffdddddd)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xffeeeeee),
          child: Icon(Icons.add, size: 18, color: Color(0xff555555)),
        ),
      ),
    ),
  );
}
