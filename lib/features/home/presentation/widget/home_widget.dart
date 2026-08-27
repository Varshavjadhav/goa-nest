import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int category = 0;
  final categories = const ['All', 'Beach', 'Pool', 'Budget', 'Design'];
  final categoryIcons = const [
    Icons.apps_rounded,
    Icons.beach_access_rounded,
    Icons.pool_rounded,
    Icons.sell_outlined,
    Icons.auto_awesome_rounded,
  ];
  final homes = const [
    _HomeData(
      'Azure Bay Retreat',
      'Anjuna, North Goa',
      '₹18,500',
      '4.9',
      'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=900',
    ),
    _HomeData(
      'Casa Verde Manor',
      'Assagao, Goa',
      '₹12,200',
      '4.8',
      'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=900',
    ),
    _HomeData(
      'The Canopy Nest',
      'Agonda, South Goa',
      '₹9,800',
      '5.0',
      'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=900',
    ),
  ];

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColor.surface,
    child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 105.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const _HomeHeader(),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () => context.push(RouteName.searchView),
                child: const _HomeSearch(),
              ),
              SizedBox(height: 19.h),
              SizedBox(
                height: 46.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (_, index) => _CategoryChip(
                    label: categories[index],
                    icon: categoryIcons[index],
                    selected: index == category,
                    onTap: () => setState(() => category = index),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              AppTextWidget.headlineMedium(
                text: 'Featured Escapes',
                color: AppColor.textPrimary,
              ),
              SizedBox(height: 4.h),
              AppTextWidget.bodySmall(
                text: 'Curated collection for your next stay',
                color: AppColor.textSecondary,
              ),
              SizedBox(height: 17.h),
              for (final home in homes) _PropertyCard(home: home),
              SizedBox(height: 2.h),
              AppTextWidget.headlineMedium(
                text: 'Discover More',
                color: AppColor.textPrimary,
              ),
              SizedBox(height: 15.h),
              const _DiscoverCard(),
              SizedBox(height: 12.h),
              Row(
                children: [
                  const Expanded(
                    child: _SmallDiscover(
                      icon: Icons.sailing_rounded,
                      title: 'Yacht Rentals',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  const Expanded(
                    child: _SmallDiscover(
                      icon: Icons.restaurant_rounded,
                      title: "Chef's Table",
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    ),
  );
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();
  @override
  Widget build(BuildContext context) => Row(
    children: [
      AppTextWidget(
        text: 'GoaNest',
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: AppColor.primary,
      ),
      const Spacer(),
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.notifications_none_rounded,
          color: AppColor.textPrimary,
        ),
      ),
      Icon(
        Icons.tune_rounded,
        size: 21.sp,
        color: AppColor.textPrimary,
      ),
    ],
  );
}

class _HomeSearch extends StatelessWidget {
  const _HomeSearch();
  @override
  Widget build(BuildContext context) => Container(
    height: 54.h,
    padding: EdgeInsets.symmetric(horizontal: 17.w),
    decoration: BoxDecoration(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(28.r),
      border: Border.all(color: AppColor.homeDivider),
      boxShadow: const [
        BoxShadow(
          color: AppColor.shadow,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(
          Icons.search_rounded,
          size: 21.sp,
          color: AppColor.textSecondary,
        ),
        SizedBox(width: 12.w),
        AppTextWidget.bodyLarge(
          text: 'Where in Goa?',
          color: AppColor.textSecondary,
        ),
        const Spacer(),
        Icon(
          Icons.tune_rounded,
          size: 19.sp,
          color: AppColor.textSecondary,
        ),
      ],
    ),
  );
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? AppColor.primary : AppColor.white,
    elevation: selected ? 3 : 0,
    shadowColor: AppColor.primary.withValues(alpha: .25),
    borderRadius: BorderRadius.circular(24.r),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: selected ? AppColor.primary : AppColor.homeDivider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 17.sp,
              color: selected ? AppColor.white : AppColor.primary,
            ),
            SizedBox(width: 7.w),
            AppTextWidget(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? AppColor.white : AppColor.textPrimary,
            ),
          ],
        ),
      ),
    ),
  );
}

class _HomeData {
  final String title, location, price, rating, image;
  const _HomeData(
    this.title,
    this.location,
    this.price,
    this.rating,
    this.image,
  );
}

class _PropertyCard extends StatelessWidget {
  final _HomeData home;
  const _PropertyCard({required this.home});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.push(
      RouteName.propertyView.replaceFirst(':propertyId', 'modern-villa'),
    ),
    borderRadius: BorderRadius.circular(14.r),
    child: Padding(
      padding: EdgeInsets.only(bottom: 25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: AspectRatio(
                  aspectRatio: 1.12,
                  child: Image.network(
                    home.image,
                    fit: BoxFit.cover,
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
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('IMAGE_ERROR: ${error.toString()}');
                      debugPrint('IMAGE_ERROR_URL: ${home.image}');
                      return Container(
                        color: AppColor.greyExtraLight,
                        child: Icon(
                          Icons.home_outlined,
                          size: 42.sp,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: AppColor.white.withValues(alpha: .93),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 21.sp,
                  ),
                ),
              ),
              Positioned(
                bottom: 12.h,
                left: 12.w,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.all(Radius.circular(4.r)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 5.h,
                    ),
                    child: AppTextWidget(
                      text: 'PREMIER',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColor.white,
                      letterSpacing: .5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: AppTextWidget.titleLarge(
                  text: home.title,
                  color: AppColor.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 7.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColor.greyExtraLight,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14.sp,
                      color: AppColor.primary,
                    ),
                    SizedBox(width: 3.w),
                    AppTextWidget(
                      text: home.rating,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: AppColor.textSecondary,
              ),
              SizedBox(width: 3.w),
              AppTextWidget.bodySmall(
                text: home.location,
                color: AppColor.textSecondary,
              ),
            ],
          ),
          SizedBox(height: 7.h),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: AppColor.textPrimary,
                fontSize: 13.sp,
              ),
              children: [
                TextSpan(
                  text: home.price,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.primary,
                  ),
                ),
                TextSpan(
                  text: ' / night',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _DiscoverCard extends StatelessWidget {
  const _DiscoverCard();
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14.r),
    child: Stack(
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: Image.network(
            'https://images.unsplash.com/photo-1500534623283-312aade485b7?w=900',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColor.primary),
          ),
        ),
        Positioned(
          left: 16.w,
          bottom: 16.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.titleLarge(
                text: 'Private Plantation Tours',
                color: AppColor.white,
              ),
              SizedBox(height: 4.h),
              AppTextWidget.labelMedium(
                text: 'Exclusive back-to-nature experiences',
                color: AppColor.white,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SmallDiscover extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SmallDiscover({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) => Container(
    height: 112.h,
    decoration: BoxDecoration(
      color: AppColor.greyExtraLight,
      borderRadius: BorderRadius.circular(13.r),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: AppColor.primary,
          size: 28.sp,
        ),
        SizedBox(height: 10.h),
        AppTextWidget(
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
      ],
    ),
  );
}
