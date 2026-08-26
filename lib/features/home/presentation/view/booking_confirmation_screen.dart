import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';

const _pink = Color(0xffff385c);
const _ink = Color(0xff222222);
const _muted = Color(0xff717171);

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xfff9f9f9),
    appBar: AppBar(
      backgroundColor: const Color(0xfff9f9f9),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.go(RouteName.homeView),
        icon: const Icon(Icons.close_rounded),
      ),
      title: const Text(
        'Booking confirmed',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      children: [
        Container(
          width: 82,
          height: 82,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: const BoxDecoration(
            color: Color(0xffe5f5e8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Color(0xff25833d),
            size: 48,
          ),
        ),
        const Text(
          'You’re all set!',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w700,
            color: _ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your trip is confirmed. We can’t wait to host you.',
          style: TextStyle(fontSize: 14, color: _muted, height: 1.4),
        ),
        const SizedBox(height: 28),
        const _BookingCard(),
        const SizedBox(height: 22),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () => context.go(RouteName.homeView),
            style: ElevatedButton.styleFrom(
              backgroundColor: _pink,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Explore more stays',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'Confirmation code: HN7K4P',
            style: TextStyle(fontSize: 12, color: _muted, letterSpacing: .4),
          ),
        ),
      ],
    ),
  );
}

class _BookingCard extends StatelessWidget {
  const _BookingCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xffdddddd)),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=300',
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 76,
                  height: 76,
                  color: const Color(0xffeeeeee),
                  child: const Icon(Icons.home_outlined),
                ),
              ),
            ),
            const SizedBox(width: 13),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Modern villa with pool',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Entire villa · North Goa',
                    style: TextStyle(fontSize: 12, color: _muted),
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: Color(0xffffb400),
                      ),
                      SizedBox(width: 3),
                      Text(
                        '4.9 · 24 reviews',
                        style: TextStyle(fontSize: 11, color: _muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1),
        ),
        const _InfoRow(label: 'Dates', value: 'Aug 28 – Sep 1, 2026'),
        const _InfoRow(label: 'Guests', value: '2 guests'),
        const _InfoRow(label: 'Total paid', value: '₹80,750', bold: true),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _InfoRow({required this.label, required this.value, this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: _muted),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: _ink,
          ),
        ),
      ],
    ),
  );
}
