import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_search_field_widget.dart';
import 'package:goanest/widgets/section_header_widget.dart';

import 'destination_strip_widget.dart';
import 'recent_search_list_widget.dart';
import 'results_grid_widget.dart';
import 'search_top_bar_widget.dart';
import 'trending_wrap_widget.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return ColoredBox(
      color: theme.background,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.p, 16.p, 16.p, 96.p),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SearchTopBar(),
                  Gap(22.h),
                  const AppSearchField(showFilterButton: true),
                  Gap(26.h),
                  const SectionHeader(title: 'Recent Searches', action: 'Clear all'),
                  Gap(14.h),
                  const RecentSearchList(),
                  Gap(30.h),
                  const SectionHeader(
                    title: 'Popular Destinations',
                    action: 'View all',
                  ),
                  Gap(14.h),
                  const DestinationStrip(),
                  Gap(30.h),
                  const SectionHeader(title: 'Trending Searches'),
                  Gap(16.h),
                  const TrendingWrap(),
                  Gap(30.h),
                  const SectionHeader(title: 'Explore Stays', action: 'View all'),
                  Gap(16.h),
                  const ResultsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
