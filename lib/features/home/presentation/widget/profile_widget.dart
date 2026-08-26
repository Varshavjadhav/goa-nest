import 'package:flutter/material.dart';

const _brand = Color(0xffff385c);
const _ink = Color(0xff222222);
const _muted = Color(0xff717171);

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xfff9f9f9),
    child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 105),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 20),
              const _ProfileCard(),
              const SizedBox(height: 16),
              const _HostBanner(),
              const SizedBox(height: 28),
              const _Section(
                title: 'Account',
                items: [
                  _ActionItem(
                    Icons.person_outline_rounded,
                    'Personal information',
                    'Manage your name, email, and phone',
                  ),
                  _ActionItem(
                    Icons.credit_card_outlined,
                    'Payments and payouts',
                    'Manage payment methods',
                  ),
                  _ActionItem(
                    Icons.notifications_none_rounded,
                    'Notifications',
                    'Choose what you want to hear about',
                  ),
                ],
              ),
              const _Section(
                title: 'Preferences',
                items: [
                  _ActionItem(
                    Icons.language_rounded,
                    'Language and currency',
                    'English · INR',
                  ),
                  _ActionItem(
                    Icons.lock_outline_rounded,
                    'Privacy and sharing',
                    'Control your privacy settings',
                  ),
                ],
              ),
              const _Section(
                title: 'Support',
                items: [
                  _ActionItem(
                    Icons.help_outline_rounded,
                    'Help Center',
                    'Get help with your reservation',
                  ),
                  _ActionItem(
                    Icons.shield_outlined,
                    'Safety information',
                    'Learn about staying safe',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: _ink,
                  minimumSize: const Size.fromHeight(52),
                  side: const BorderSide(color: Color(0xffd9d9d9)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Log out',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  'GoNest v1.0.0',
                  style: TextStyle(fontSize: 11, color: _muted),
                ),
              ),
            ]),
          ),
        ),
      ],
    ),
  );
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xffe1e1e1)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 34,
          backgroundImage: NetworkImage('https://i.pravatar.cc/140?img=47'),
        ),
        const SizedBox(width: 15),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alex Johnson',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'alex.johnson@email.com',
                style: TextStyle(fontSize: 12, color: _muted),
              ),
              SizedBox(height: 9),
              Row(
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 15,
                    color: Color(0xff25833d),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Verified guest',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff25833d),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: _muted),
      ],
    ),
  );
}

class _HostBanner extends StatelessWidget {
  const _HostBanner();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: const Color(0xffffeef0),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.home_work_outlined, color: _brand),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch to hosting',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Share your space and earn extra income.',
                style: TextStyle(fontSize: 12, color: _muted),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_rounded, size: 20, color: _brand),
      ],
    ),
  );
}

class _Section extends StatelessWidget {
  final String title;
  final List<_ActionItem> items;
  const _Section({required this.title, required this.items});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _ink,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xffe1e1e1)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                items[i].build(i != items.length - 1),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ActionItem {
  final IconData icon;
  final String title, subtitle;
  const _ActionItem(this.icon, this.title, this.subtitle);
  Widget build(bool divider) => Column(
    children: [
      ListTile(
        onTap: () {},
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xfffff1f2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: _brand),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _ink,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: _muted),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          size: 21,
          color: _muted,
        ),
      ),
      if (divider) const Divider(height: 1, indent: 66, endIndent: 14),
    ],
  );
}
