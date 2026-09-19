import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goanest/core.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';

import '../../data/model/explore_model.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../bloc/home_event.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) => BlocBuilder<HomeBloc, HomeState>(
    builder: (context, state) {
      if (state is HomeLoading || state is HomeInitial) {
        return const ColoredBox(
          color: AppColor.white,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (state is HomeError) {
        return _ErrorView(
          message: state.message,
          onRetry: () => context.read<HomeBloc>().add(LoadHome()),
        );
      }
      return _content(context, (state as HomeLoaded).home);
    },
  );

  Widget _content(BuildContext context, ExploreModel data) => ColoredBox(
    color: const Color(0xFFF7F7F7),
    child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _SearchBar(data.search)),
        SliverToBoxAdapter(
          child: _Tabs(
            _tabsFor(data.tabs),
            selectedTab,
            (index) => setState(() => selectedTab = index),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 100.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (data.continueSearching.visible)
                _ContinueSearching(data.continueSearching),
              if (data.recentlyViewed.items.isNotEmpty)
                _PropertySection(
                  'Recently viewed',
                  data.recentlyViewed,
                  seeAll: true,
                ),
              if (data.recommendedForYou.items.isNotEmpty)
                _PropertySection('Recommended for you', data.recommendedForYou),
              if (data.popularDestinationStays.items.isNotEmpty)
                _PropertySection(
                  'Popular destination stays',
                  data.popularDestinationStays,
                ),
              if (data.guestFavourites.items.isNotEmpty)
                _PropertySection(
                  data.guestFavourites.title.isEmpty
                      ? 'Guest favourites'
                      : data.guestFavourites.title,
                  data.guestFavourites,
                ),
              if (data.tripInspiration.isNotEmpty)
                _TripSection(data.tripInspiration),
              if (data.exploreMore.items.isNotEmpty)
                _ExploreMore(data.exploreMore.items),
              if (data.experiences.enabled)
                _ExperienceSection(data.experiences),
            ]),
          ),
        ),
      ],
    ),
  );

  static const _fallbackTabs = <ExploreTab>[
    ExploreTab(key: 'homes', label: 'Homes', icon: 'home'),
    ExploreTab(key: 'villas', label: 'Villas', icon: 'home'),
    ExploreTab(key: 'beach', label: 'Beach', icon: 'beach'),
    ExploreTab(key: 'experiences', label: 'Experiences', icon: 'camera'),
    ExploreTab(key: 'services', label: 'Services', icon: 'settings'),
  ];

  List<ExploreTab> _tabsFor(List<ExploreTab> apiTabs) {
    if (apiTabs.isEmpty) return _fallbackTabs;
    final result = <ExploreTab>[];
    for (final tab in apiTabs) {
      final value = '${tab.key} ${tab.label}'.toLowerCase();
      if (value.contains('beach') && value.contains('villa')) {
        result.add(
          const ExploreTab(key: 'villas', label: 'Villas', icon: 'home'),
        );
        result.add(
          const ExploreTab(key: 'beach', label: 'Beach', icon: 'beach'),
        );
      } else {
        result.add(tab);
      }
    }
    for (final fallback in _fallbackTabs) {
      if (!result.any(
        (tab) =>
            tab.key.toLowerCase() == fallback.key ||
            tab.label.toLowerCase() == fallback.label.toLowerCase(),
      )) {
        result.add(fallback);
      }
    }
    return result;
  }
}

class _SearchBar extends StatelessWidget {
  final ExploreSearch data;
  const _SearchBar(this.data);

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
    child: GestureDetector(
      onTap: () => context.push(RouteName.searchView),
      child: Container(
        height: 54.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(38.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: .16),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 21.sp,
              color: AppColor.textPrimary,
            ),
            SizedBox(width: 10.w),
            AppTextWidget(
              text: data.placeholder,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ],
        ),
      ),
    ),
  );
}

class _Tabs extends StatelessWidget {
  final List<ExploreTab> tabs;
  final int selected;
  final ValueChanged<int> onTap;
  const _Tabs(this.tabs, this.selected, this.onTap);

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 58.h,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(20.w, 13.h, 20.w, 0),
      itemCount: tabs.length,
      separatorBuilder: (_, __) => SizedBox(width: 8.w),
      itemBuilder: (_, index) {
        final item = tabs[index];
        final active = index == selected;
        return GestureDetector(
          onTap: () => onTap(index),
          child: AnimatedScale(
            scale: active ? 1.03 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFF4F4F4) : AppColor.white,
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(color: const Color(0xFFE7E7E7)),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: active ? .16 : .08),
                    blurRadius: active ? 7 : 3,
                    offset: Offset(0, active ? 3 : 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextWidget.legacy(
                    _emoji(item.icon),
                    style: TextStyle(fontSize: 17.sp, height: 1),
                  ),
                  SizedBox(width: 5.w),
                  AppTextWidget(
                    text: item.label,
                    fontSize: 15,
                    color: AppColor.textPrimary,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  static String _emoji(String value) => switch (value.toLowerCase()) {
    'home' || 'homes' => '🏠',
    'camera' || 'experience' || 'experiences' => '🎈',
    'settings' || 'service' || 'services' => '🛎️',
    'beach' => '🏖️',
    _ => '✨',
  };
}

class _ContinueSearching extends StatelessWidget {
  final ExploreContinueSearching data;
  const _ContinueSearching(this.data);

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
    child: Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 12.w, 14.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: .11),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget(
                  text: data.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  maxLines: 2,
                ),
                SizedBox(height: 4.h),
                AppTextWidget(
                  text: data.subtitle,
                  fontSize: 11,
                  color: AppColor.textSecondary,
                ),
              ],
            ),
          ),
          if (data.imageUrl.isNotEmpty) _Image(data.imageUrl, 80.w, 80.h),
        ],
      ),
    ),
  );
}

class _PropertySection extends StatefulWidget {
  final String title;
  final ExplorePropertySection data;
  final bool seeAll;
  const _PropertySection(this.title, this.data, {this.seeAll = false});

  @override
  State<_PropertySection> createState() => _PropertySectionState();
}

class _PropertySectionState extends State<_PropertySection> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 12.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Expanded(
                child: AppTextWidget(
                  text: widget.title,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (widget.seeAll)
                GestureDetector(
                  onTap: () => context.push(RouteName.recentlyViewedView),
                  child: Container(
                    width: 34.w,
                    height: 34.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withValues(alpha: .12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(Icons.arrow_forward_rounded, size: 18.sp),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 228.h,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: widget.data.items.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, index) => AnimatedBuilder(
              animation: _scrollController,
              builder: (_, child) {
                final offset = _scrollController.hasClients
                    ? _scrollController.offset
                    : 0.0;
                final cardCenter =
                    (index * (156.w + 12.w)) + (156.w / 2) - offset;
                final viewportCenter = MediaQuery.sizeOf(context).width / 2;
                final distance = (cardCenter - viewportCenter).abs();
                final factor = (1 - (distance / viewportCenter) * .12)
                    .clamp(.88, 1.0)
                    .toDouble();
                return Opacity(
                  opacity: factor,
                  child: Transform.scale(scale: factor, child: child),
                );
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.94, end: 1),
                duration: Duration(milliseconds: 280 + (index * 45)),
                curve: Curves.easeOutCubic,
                builder: (_, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset((1 - value) * 18, 0),
                    child: child,
                  ),
                ),
                child: _PropertyCard(widget.data.items[index]),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _PropertyCard extends StatelessWidget {
  final ExploreProperty data;
  const _PropertyCard(this.data);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: data.id.isEmpty
        ? null
        : () => context.push(
            RouteName.propertyView.replaceFirst(':propertyId', data.id),
          ),
    child: SizedBox(
      width: 156.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _Image(data.imageUrl, 156.w, 140.h),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColor.black.withValues(alpha: .14),
                          AppColor.transparent,
                          AppColor.black.withValues(alpha: .18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(top: 9.h, right: 9.w, child: _Heart(data)),
              if (data.propertyType.isNotEmpty)
                Positioned(
                  left: 10.w,
                  bottom: 10.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.black.withValues(alpha: .72),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: AppTextWidget(
                      text: data.propertyType.toUpperCase(),
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: AppColor.white,
                      letterSpacing: .5,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: AppTextWidget(
                  text: data.title,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.star_rounded,
                size: 12.sp,
                color: AppColor.textPrimary,
              ),
              SizedBox(width: 2.w),
              AppTextWidget(text: data.rating.toStringAsFixed(2), fontSize: 10),
            ],
          ),
          SizedBox(height: 3.h),
          AppTextWidget(
            text: data.location,
            fontSize: 10,
            color: AppColor.textSecondary,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          AppTextWidget(
            text:
                '${data.currency} ${data.pricePerNight.toStringAsFixed(0)} / night',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColor.textPrimary,
          ),
        ],
      ),
    ),
  );
}

class _Heart extends StatefulWidget {
  final ExploreProperty data;
  const _Heart(this.data);
  @override
  State<_Heart> createState() => _HeartState();
}

class _HeartState extends State<_Heart> {
  late bool selected = widget.data.isLiked;
  @override
  Widget build(BuildContext context) =>
      BlocListener<WishlistBloc, WishlistState>(
        listenWhen: (_, state) =>
            state is FavoriteUpdated || state is FavoriteError,
        listener: (_, state) {
          if (state is FavoriteUpdated && state.propertyId == widget.data.id) {
            setState(() => selected = state.isLiked);
          } else if (state is FavoriteError &&
              state.propertyId == widget.data.id) {
            setState(() => selected = state.previousIsLiked);
          }
        },
        child: GestureDetector(
          onTap: widget.data.id.isEmpty
              ? null
              : () {
                  final wasLiked = selected;
                  setState(() => selected = !selected);
                  context.read<WishlistBloc>().add(
                    ToggleFavorite(widget.data.id, isLiked: wasLiked),
                  );
                },
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColor.white.withValues(alpha: .96),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withValues(alpha: .12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              selected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: 18.sp,
              color: selected ? AppColor.primary : AppColor.textPrimary,
            ),
          ),
        ),
      );
}

class _TripSection extends StatelessWidget {
  final List<TripInspiration> items;
  const _TripSection(this.items);
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 18.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: AppTextWidget(
            text: 'Inspiration for your next trip',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 160.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, index) {
              final item = items[index];
              return SizedBox(
                width: 150.w,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _Image(item.imageUrl, 150.w, 160.h),
                    Positioned(
                      left: 10.w,
                      right: 10.w,
                      bottom: 10.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget(
                            text: item.title,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.white,
                          ),
                          AppTextWidget(
                            text: item.subtitle,
                            fontSize: 10,
                            color: AppColor.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _ExploreMore extends StatelessWidget {
  final List<ExploreCategory> items;
  const _ExploreMore(this.items);
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget(
          text: 'Explore more',
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 14.h,
          children: items.map((item) {
            return SizedBox(
              width: 70.w,
              child: Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.greyExtraLight,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withValues(alpha: .10),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AppTextWidget.legacy(
                      item.icon,
                      style: TextStyle(fontSize: 25.sp),
                    ),
                  ),
                  SizedBox(height: 7.h),
                  AppTextWidget(
                    text: item.name,
                    fontSize: 10,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

class _ExperienceSection extends StatelessWidget {
  final ExploreExperiences data;
  const _ExperienceSection(this.data);
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 28.h),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColor.textPrimary,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: .18),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(
            text: data.title,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColor.white,
          ),
          SizedBox(height: 4.h),
          AppTextWidget(
            text: data.subtitle,
            fontSize: 13,
            color: AppColor.white.withValues(alpha: .85),
          ),
          if (data.message.isNotEmpty) ...[
            SizedBox(height: 10.h),
            AppTextWidget(
              text: data.message,
              fontSize: 12,
              color: AppColor.white.withValues(alpha: .7),
            ),
          ],
        ],
      ),
    ),
  );
}

class _Image extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  const _Image(this.url, this.width, this.height);
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.r),
      boxShadow: [
        BoxShadow(
          color: AppColor.black.withValues(alpha: .12),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: url.isEmpty
          ? _placeholder()
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : _placeholder(),
            ),
    ),
  );
  Widget _placeholder() => Container(
    color: AppColor.greyExtraLight,
    alignment: Alignment.center,
    child: Icon(Icons.home_outlined, size: 28.sp, color: AppColor.grey),
  );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColor.white,
    child: Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 44.sp, color: AppColor.grey),
            SizedBox(height: 12.h),
            AppTextWidget(
              text: message,
              fontSize: 14,
              color: AppColor.textSecondary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 14.h),
            ElevatedButton(
              onPressed: onRetry,
              child: const AppTextWidget.legacy('Try again'),
            ),
          ],
        ),
      ),
    ),
  );
}
