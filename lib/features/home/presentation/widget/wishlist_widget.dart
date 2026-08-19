import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/section_header_widget.dart';

import 'collections_strip_widget.dart';
import 'saved_list_widget.dart';
import 'wishlist_fab_widget.dart';
import 'wishlist_top_bar_widget.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return ColoredBox(
      color: theme.background,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.p, 16.p, 16.p, 96.p),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WishlistTopBar(),
                        Gap(20.h),
                        const SectionHeader(title: 'Collections', action: 'See all'),
                        Gap(13.h),
                        const CollectionsStrip(),
                        Gap(26.h),
                        const SectionHeader(title: 'Saved Properties'),
                        Gap(14.h),
                        const SavedList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16.w,
            bottom: 20.h,
            child: const WishlistFab(),
          ),
        ],
      ),
    );
  }
}
