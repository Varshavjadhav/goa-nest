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
    color: AppColor.white,
    child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _SearchBar(data.search)),
        SliverToBoxAdapter(
          child: _Tabs(
            data.tabs,
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
}

class _SearchBar extends StatelessWidget {
  final ExploreSearch data;
  const _SearchBar(this.data);

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
    child: GestureDetector(
      onTap: () => context.push(RouteName.searchView),
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(color: AppColor.homeDivider),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: .06),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: AppTextWidget(
                text: data.placeholder,
                fontSize: 14,
                color: AppColor.textSecondary,
              ),
            ),
            if (data.filtersAvailable)
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: AppColor.greyExtraLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.tune_rounded, size: 16.sp),
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
    height: 54.h,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
      itemCount: tabs.length,
      separatorBuilder: (_, __) => SizedBox(width: 8.w),
      itemBuilder: (_, index) {
        final item = tabs[index];
        final active = index == selected;
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: active ? AppColor.textPrimary : AppColor.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: active ? AppColor.textPrimary : AppColor.homeDivider,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _icon(item.icon),
                  size: 14.sp,
                  color: active ? AppColor.white : AppColor.textPrimary,
                ),
                SizedBox(width: 5.w),
                AppTextWidget(
                  text: item.label,
                  fontSize: 12,
                  color: active ? AppColor.white : AppColor.textPrimary,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  static IconData _icon(String value) => switch (value.toLowerCase()) {
    'home' => Icons.home_outlined,
    'camera' => Icons.camera_alt_outlined,
    'settings' => Icons.settings_outlined,
    _ => Icons.auto_awesome,
  };
}

class _ContinueSearching extends StatelessWidget {
  final ExploreContinueSearching data;
  const _ContinueSearching(this.data);

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
    child: Container(
      padding: EdgeInsets.all(12.p),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColor.homeDivider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget(
                  text: data.title,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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
          if (data.imageUrl.isNotEmpty) _Image(data.imageUrl, 70.w, 62.h),
        ],
      ),
    ),
  );
}

class _PropertySection extends StatelessWidget {
  final String title;
  final ExplorePropertySection data;
  final bool seeAll;
  const _PropertySection(this.title, this.data, {this.seeAll = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 28.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Expanded(
                child: AppTextWidget(
                  text: title,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (seeAll)
                GestureDetector(
                  onTap: () => context.push(RouteName.recentlyViewedView),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextWidget(
                        text: 'See all',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textSecondary,
                      ),
                      SizedBox(width: 2.w),
                      Icon(Icons.chevron_right_rounded, size: 20.sp),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 236.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: data.items.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, index) => _PropertyCard(data.items[index]),
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
      width: 185.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _Image(data.imageUrl, 185.w, 132.h),
              Positioned(top: 8.h, right: 8.w, child: _Heart(data)),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: AppTextWidget(
                  text: data.title,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.star_rounded, size: 12.sp, color: AppColor.primary),
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
            fontSize: 12,
            fontWeight: FontWeight.w700,
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
              color: AppColor.white.withValues(alpha: .92),
              shape: BoxShape.circle,
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
    padding: EdgeInsets.only(top: 30.h),
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
        SizedBox(height: 14.h),
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
    padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget(
          text: 'Explore more',
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 14.h),
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
                    ),
                    child: Text(item.icon, style: TextStyle(fontSize: 25.sp)),
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
    padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 40.h),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColor.textPrimary,
        borderRadius: BorderRadius.circular(14.r),
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
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(10.r),
    child: SizedBox(
      width: width,
      height: height,
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
            ElevatedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    ),
  );
}
