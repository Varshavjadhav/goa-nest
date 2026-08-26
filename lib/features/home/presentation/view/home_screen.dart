import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_main_nav_bar.dart';
import 'package:goanest/widgets/app_scaffold.dart';

import '../widget/bookings_widget.dart';
import '../widget/home_widget.dart';
import '../widget/profile_widget.dart';
import '../widget/wishlist_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _navItems = [
    AppMainNavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      label: 'Explore',
    ),
    AppMainNavItem(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Wishlists',
    ),
    AppMainNavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      label: 'Bookings',
    ),
    AppMainNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: context.themeExt.homeScaffold,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeWidget(),
          WishlistWidget(),
          BookingsWidget(),
          ProfileWidget(),
        ],
      ),
      bottomNavigationBar: AppMainNavBar(
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
