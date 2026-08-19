import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';

import 'popular_home_card_widget.dart';

class PopularHomesGrid extends StatelessWidget {
  const PopularHomesGrid({super.key});

  static const _items = [
    (
      crop: Rect.fromLTWH(33, 313, 249, 165),
      badge: 'Guest favourite',
      title: 'Azure Bay Retreat',
      price: '₹18,500',
      rating: '4.9',
    ),
    (
      crop: Rect.fromLTWH(33, 581, 249, 148),
      badge: 'Guest favourite',
      title: 'Casa Verde Manor',
      price: '₹12,200',
      rating: '4.8',
    ),
    (
      crop: Rect.fromLTWH(33, 847, 249, 166),
      badge: null,
      title: 'The Canopy Nest',
      price: '₹9,800',
      rating: '5.0',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PopularHomeCard(
                crop: _items[0].crop,
                badge: _items[0].badge,
                title: _items[0].title,
                price: _items[0].price,
                rating: _items[0].rating,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: PopularHomeCard(
                crop: _items[1].crop,
                badge: _items[1].badge,
                title: _items[1].title,
                price: _items[1].price,
                rating: _items[1].rating,
              ),
            ),
          ],
        ),
        Gap(22.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PopularHomeCard(
                crop: _items[2].crop,
                title: _items[2].title,
                price: _items[2].price,
                rating: _items[2].rating,
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }
}
