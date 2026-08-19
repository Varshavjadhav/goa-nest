import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_search_field_widget.dart';
import 'package:goanest/widgets/section_header_widget.dart';

import 'category_tabs_widget.dart';
import 'popular_homes_grid_widget.dart';
import 'recently_viewed_strip_widget.dart';
import 'weekend_banner_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return ColoredBox(
      color: theme.homeBackground,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.p, 16.p, 16.p, 96.p),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchField(
                    hintText: 'Start your search',
                    showIcon: false,
                    height: 48.h,
                  ),
                  Gap(16.h),
                  CategoryTabs(
                    selectedIndex: _selectedCategory,
                    onSelected: (index) {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                  ),
                  Gap(28.h),
                  SectionHeader(
                    title: 'Recently viewed',
                    color: theme.homeTitleText,
                  ),
                  Gap(14.h),
                  const RecentlyViewedStrip(),
                  Gap(30.h),
                  SectionHeader(
                    title: 'Popular homes in Goa',
                    color: theme.homeTitleText,
                  ),
                  Gap(14.h),
                  const PopularHomesGrid(),
                  Gap(30.h),
                  const WeekendBanner(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
