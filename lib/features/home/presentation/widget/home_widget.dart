import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedCategory = 0;

  static const _categories = [
    ('All', Icons.auto_awesome),
    ('Homes', Icons.home_outlined),
    ('Experiences', Icons.camera_alt_outlined),
    ('Services', Icons.build_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColor.white,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: _buildCategoryTabs()),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 100.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildContinueSearching(),
                _buildRecentlyViewed(),
                _buildRecommendedForYou(),
                _buildPopularDestinationStays(),
                _buildBasedOnSearch(),
                _buildTopDestinations(),
                _buildInspiration(),
                _buildExploreMore(),
                _buildExperiences(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // SEARCH BAR
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: GestureDetector(
        onTap: () => context.push(RouteName.searchView),
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(color: AppColor.homeDivider, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 20.sp,
                  color: AppColor.textPrimary,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: AppTextWidget(
                    text: 'Start your search',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textSecondary,
                  ),
                ),
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: AppColor.greyExtraLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 16.sp,
                    color: AppColor.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // CATEGORY TABS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildCategoryTabs() {
    return Container(
      height: 44.h,
      margin: EdgeInsets.only(top: 10.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final (label, icon) = _categories[index];
          final isSelected = index == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.textPrimary : AppColor.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: isSelected
                      ? AppColor.textPrimary
                      : AppColor.homeDivider,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 14.sp,
                    color: isSelected ? AppColor.white : AppColor.textPrimary,
                  ),
                  SizedBox(width: 5.w),
                  AppTextWidget(
                    text: label,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColor.white : AppColor.textPrimary,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // CONTINUE SEARCHING
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildContinueSearching() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Container(
        padding: EdgeInsets.all(12.p),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColor.homeDivider),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextWidget(
                    text: 'Continue searching for',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                  ),
                  SizedBox(height: 2.h),
                  AppTextWidget(
                    text: 'homes in North Goa',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                  ),
                  SizedBox(height: 3.h),
                  AppTextWidget(
                    text: 'Week in Oct · 1 guest',
                    fontSize: 11,
                    color: AppColor.textSecondary,
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                width: 70.w,
                height: 62.h,
                child: Image.network(
                  'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=400',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColor.greyExtraLight,
                    child: Icon(
                      Icons.home_outlined,
                      size: 24.sp,
                      color: AppColor.grey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // RECENTLY VIEWED
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildRecentlyViewed() {
    final items = [
      _RecentItem(
        'Lonavala',
        'Favourite',
        '4.92',
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=400',
      ),
      _RecentItem(
        'Commercial phot...',
        'Holiday Home™',
        null,
        'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=400',
      ),
      _RecentItem(
        'Gurugram',
        '3 homes',
        null,
        'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=400',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextWidget(
                text: 'Recently viewed',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22.sp,
                color: AppColor.textPrimary,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 130.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) => _buildRecentItem(items[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedForYou() {
    return _buildHorizontalStaySection(
      title: 'Recommended for you',
      items: const [
        _HorizontalStay(
          'The Canopy Nest',
          'Agonda, South Goa',
          '₹9,800',
          '5.0',
          Rect.fromLTWH(33, 847, 130, 112),
        ),
        _HorizontalStay(
          'Azure Bay Retreat',
          'Anjuna, North Goa',
          '₹18,500',
          '4.9',
          Rect.fromLTWH(33, 313, 130, 112),
        ),
        _HorizontalStay(
          'Palolem Hideaway',
          'Palolem, South Goa',
          '₹14,600',
          '4.7',
          Rect.fromLTWH(164, 600, 130, 112),
        ),
      ],
    );
  }

  Widget _buildPopularDestinationStays() {
    return _buildHorizontalStaySection(
      title: 'Popular destination stays',
      items: const [
        _HorizontalStay(
          'Casa Verde Manor',
          'Assagao, Goa',
          '₹12,200',
          '4.8',
          Rect.fromLTWH(164, 340, 130, 112),
        ),
        _HorizontalStay(
          'Palolem Hideaway',
          'Palolem, South Goa',
          '₹14,600',
          '4.7',
          Rect.fromLTWH(164, 600, 130, 112),
        ),
        _HorizontalStay(
          'Azure Bay Retreat',
          'Anjuna, North Goa',
          '₹18,500',
          '4.9',
          Rect.fromLTWH(33, 313, 130, 112),
        ),
      ],
    );
  }

  Widget _buildHorizontalStaySection({
    required String title,
    required List<_HorizontalStay> items,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: AppTextWidget(
              text: title,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 200.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (_, index) => _buildHorizontalStayCard(items[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalStayCard(_HorizontalStay item) {
    return SizedBox(
      width: 170.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 112.h,
            width: 170.w,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ScreenshotCrop(crop: item.crop, borderRadius: 10.r),
                ),
                Positioned(top: 7.h, right: 7.w, child: const _HeartButton()),
              ],
            ),
          ),
          SizedBox(height: 7.h),
          Row(
            children: [
              Expanded(
                child: AppTextWidget(
                  text: item.title,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.star_rounded, size: 12.sp, color: AppColor.primary),
              SizedBox(width: 2.w),
              AppTextWidget(
                text: item.rating,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          AppTextWidget(
            text: item.location,
            fontSize: 10,
            color: AppColor.textSecondary,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          AppTextWidget(
            text: '${item.price} / night',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItem(_RecentItem item) {
    return SizedBox(
      width: 125.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  height: 82.h,
                  width: 125.w,
                  color: AppColor.greyExtraLight,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.home_outlined,
                        size: 24.sp,
                        color: AppColor.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6.h,
                right: 6.w,
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: AppColor.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const _HeartButton(),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          AppTextWidget(
            text: item.title,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColor.textPrimary,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          if (item.rating != null)
            Row(
              children: [
                Icon(Icons.star_rounded, size: 12.sp, color: AppColor.primary),
                SizedBox(width: 2.w),
                AppTextWidget(
                  text: item.rating!,
                  fontSize: 11,
                  color: AppColor.textPrimary,
                ),
                SizedBox(width: 3.w),
                Flexible(
                  child: AppTextWidget(
                    text: item.subtitle,
                    fontSize: 11,
                    color: AppColor.textSecondary,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          else
            AppTextWidget(
              text: item.subtitle,
              fontSize: 11,
              color: AppColor.textSecondary,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // BASED ON YOUR SEARCH
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildBasedOnSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: AppTextWidget(
                  text: 'Based on your North Goa search',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColor.greyExtraLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 20.sp,
                  color: AppColor.textPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        SizedBox(
          // The card keeps the original 280.h image carousel plus its details
          // below it, so the horizontal list does not clip or overflow.
          height: 405.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemBuilder: (_, index) => SizedBox(
              width: 285.w,
              child: _buildSearchPropertyCard(
                horizontal: true,
                title: index == 0 ? 'Flat in Candolim' : 'Home in Candolim',
                location: index == 0
                    ? '2,305 kilometres away'
                    : '2,230 kilometres away',
                dates: index == 0 ? '10–15 Oct' : '20–25 Oct',
                price: index == 0 ? '₹34,978' : '₹20,844',
                priceNote: 'total before taxes',
                rating: index == 0 ? '5.0' : '4.82',
                images: index == 0
                    ? [
                        'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=900',
                        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=900',
                        'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=900',
                      ]
                    : [
                        'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=900',
                        'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=900',
                        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=900',
                      ],
                isGuestFavorite: index == 0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopDestinations() {
    const destinations = [
      ('Palolem', 'South Goa', Rect.fromLTWH(33, 313, 130, 112)),
      ('Vagator', 'North Goa', Rect.fromLTWH(164, 340, 130, 112)),
      ('Assagao', 'North Goa', Rect.fromLTWH(33, 581, 130, 112)),
      ('Divar Island', 'Islands', Rect.fromLTWH(164, 600, 130, 112)),
    ];

    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: AppTextWidget(
              text: 'Top destinations',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 166.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              physics: const BouncingScrollPhysics(),
              itemCount: destinations.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (_, index) {
                final destination = destinations[index];
                return SizedBox(
                  width: 152.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 112.h,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ScreenshotCrop(
                                crop: destination.$3,
                                borderRadius: 10.r,
                              ),
                            ),
                            Positioned(
                              top: 7.h,
                              right: 7.w,
                              child: const _HeartButton(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 9.h),
                      AppTextWidget(
                        text: destination.$1,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColor.textPrimary,
                      ),
                      SizedBox(height: 2.h),
                      AppTextWidget(
                        text: destination.$2,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textSecondary,
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

  Widget _buildSearchPropertyCard({
    bool horizontal = false,
    required String title,
    required String location,
    required String dates,
    required String price,
    required String priceNote,
    required String rating,
    required List<String> images,
    required bool isGuestFavorite,
  }) {
    return GestureDetector(
      onTap: () => context.push(
        RouteName.propertyView.replaceFirst(':propertyId', 'modern-villa'),
      ),
      child: Padding(
        padding: horizontal
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _ImageCarousel(images: images, isGuestFavorite: isGuestFavorite),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextWidget(
                    text: title,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14.sp,
                      color: AppColor.primary,
                    ),
                    SizedBox(width: 2.w),
                    AppTextWidget(
                      text: rating,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textPrimary,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            AppTextWidget(
              text: location,
              fontSize: 13,
              color: AppColor.textSecondary,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            AppTextWidget(
              text: dates,
              fontSize: 13,
              color: AppColor.textSecondary,
            ),
            SizedBox(height: 4.h),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: AppColor.textPrimary),
                children: [
                  TextSpan(
                    text: '$price ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: priceNote,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // INSPIRATION
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildInspiration() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextWidget(
            text: 'Inspiration for your next trip',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
          SizedBox(height: 14.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: SizedBox(
              height: 280.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=900',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: AppColor.greyExtraLight),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColor.black.withValues(alpha: 0.7),
                          ],
                          stops: const [0.3, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.w,
                    bottom: 16.h,
                    right: 16.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextWidget(
                          text: 'Udaipur',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColor.white,
                        ),
                        SizedBox(height: 4.h),
                        AppTextWidget(
                          text: 'Discover the city of lakes',
                          fontSize: 13,
                          color: AppColor.white.withValues(alpha: 0.9),
                        ),
                        SizedBox(height: 12.h),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: AppTextWidget(
                              text: 'Explore stays',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // EXPLORE MORE
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildExploreMore() {
    final items = [
      _ExploreItem('Amazing pools', Icons.pool_outlined),
      _ExploreItem('Castles', Icons.castle_outlined),
      _ExploreItem('Tiny Homes', Icons.home_mini_outlined),
      _ExploreItem('Treehouse', Icons.forest_outlined),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextWidget(
            text: 'Explore more',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
          SizedBox(height: 14.h),
          Row(
            children: items.map((item) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: AppColor.greyExtraLight,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          item.icon,
                          size: 26.sp,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      AppTextWidget(
                        text: item.label,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textPrimary,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // EXPERIENCES
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildExperiences() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 40.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          color: AppColor.textPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                child: AppTextWidget(
                  text: 'Airbnb',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColor.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 2.h, 18.w, 0),
                child: AppTextWidget(
                  text: 'Experiences',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColor.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 0),
                child: AppTextWidget(
                  text: 'Unforgettable activities\nhosted by locals',
                  fontSize: 13,
                  color: AppColor.white.withValues(alpha: 0.85),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 14.h),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(14.r),
                    ),
                    child: SizedBox(
                      height: 140.h,
                      width: double.infinity,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?w=900',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColor.greyDark),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18.w,
                    bottom: 18.h,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AppTextWidget(
                          text: 'Explore',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// PRIVATE WIDGETS
// ═══════════════════════════════════════════════════════════════════════

class _ImageCarousel extends StatefulWidget {
  final List<String> images;
  final bool isGuestFavorite;

  const _ImageCarousel({required this.images, this.isGuestFavorite = false});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColor.greyExtraLight,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.primary,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColor.greyExtraLight,
                    child: Icon(
                      Icons.home_outlined,
                      size: 42.sp,
                      color: AppColor.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(top: 12.h, right: 12.w, child: const _HeartButton()),
          if (widget.isGuestFavorite)
            Positioned(
              top: 12.h,
              left: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(6.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: AppTextWidget(
                  text: 'Guest favourite',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
            ),
          Positioned(
            bottom: 12.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: _currentIndex == index ? 7.w : 5.w,
                  height: _currentIndex == index ? 7.w : 5.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? AppColor.white
                        : AppColor.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColor.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: AppTextWidget(
                text: '${_currentIndex + 1} / ${widget.images.length}',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartButton extends StatefulWidget {
  const _HeartButton();

  @override
  State<_HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<_HeartButton> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isSelected = !_isSelected),
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: AppColor.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _isSelected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 18.sp,
          color: _isSelected ? AppColor.primary : AppColor.textPrimary,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════

class _RecentItem {
  final String title;
  final String subtitle;
  final String? rating;
  final String image;
  const _RecentItem(this.title, this.subtitle, this.rating, this.image);
}

class _HorizontalStay {
  final String title;
  final String location;
  final String price;
  final String rating;
  final Rect crop;

  const _HorizontalStay(
    this.title,
    this.location,
    this.price,
    this.rating,
    this.crop,
  );
}

class _ExploreItem {
  final String label;
  final IconData icon;
  const _ExploreItem(this.label, this.icon);
}
