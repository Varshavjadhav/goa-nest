import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

class PropertyDetailScreen extends StatelessWidget {
  const PropertyDetailScreen({super.key});
  static const photos = [
    'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=1200',
    'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=800',
    'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 285.h,
            pinned: true,
            backgroundColor: AppColor.white,
            foregroundColor: AppColor.textPrimary,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: const FlexibleSpaceBar(background: _HeroImage()),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 105.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AppTextWidget.headlineLarge(
                  text: 'Modern villa with pool',
                ),
                SizedBox(height: 7.h),
                AppTextWidget.bodyMedium(
                  text: 'Entire villa in North Goa, India',
                  color: AppColor.textSecondary,
                ),
                SizedBox(height: 14.h),
                CommonWidgets.starRatingRow(
                  rating: '4.9',
                  reviewCount: '24',
                ),
                SizedBox(height: 18.h),
                const _StaySummary(),
                CommonWidgets.divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 24.r,
                    backgroundImage: const NetworkImage(
                      'https://i.pravatar.cc/100?img=47',
                    ),
                  ),
                  title: AppTextWidget(
                    text: 'Hosted by Anika',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  subtitle: AppTextWidget.bodySmall(
                    text: 'Superhost · 5 years hosting',
                    color: AppColor.textSecondary,
                  ),
                ),
                CommonWidgets.divider(),
                AppTextWidget.headlineSmall(
                  text: 'What this place offers',
                ),
                SizedBox(height: 14.h),
                const _AmenityGrid(),
                SizedBox(height: 14.h),
                CommonWidgets.showMoreLink(text: 'Show all 12 amenities'),
                CommonWidgets.divider(),
                AppTextWidget.headlineSmall(
                  text: 'About this place',
                ),
                SizedBox(height: 10.h),
                AppTextWidget.bodyMedium(
                  text: 'Wake up to open skies and relaxed coastal living in this beautiful Goa retreat. Enjoy a private pool, thoughtful interiors, and easy access to the beach, restaurants, and local markets.',
                  height: 1.55,
                  color: AppColor.textSecondary,
                ),
                SizedBox(height: 8.h),
                CommonWidgets.showMoreLink(text: 'Show more'),
                CommonWidgets.divider(height: 40),
                AppTextWidget.headlineSmall(
                  text: 'Where you\'ll be',
                ),
                SizedBox(height: 5.h),
                AppTextWidget.bodyMedium(
                  text: 'North Goa, Goa, India',
                  color: AppColor.textSecondary,
                ),
                SizedBox(height: 14.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    height: 190.h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: const Color(0xffdce8e5)),
                        const CustomPaint(painter: _MapPainter()),
                        Center(
                          child: Icon(
                            Icons.location_on,
                            color: AppColor.primary,
                            size: 36.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CommonWidgets.divider(height: 40),
                AppTextWidget.headlineSmall(
                  text: 'Guest reviews',
                ),
                SizedBox(height: 14.h),
                CommonWidgets.reviewCard(
                  name: 'Rohan',
                  text: 'Beautiful home, thoughtful host, and the pool was perfect for a relaxing weekend.',
                ),
                CommonWidgets.reviewCard(
                  name: 'Maya',
                  text: 'Exactly as pictured. The location made it easy to explore North Goa.',
                ),
                CommonWidgets.showMoreLink(text: 'Show all 24 reviews'),
                CommonWidgets.divider(height: 40),
                AppTextWidget.headlineSmall(
                  text: 'Things to know',
                ),
                SizedBox(height: 14.h),
                CommonWidgets.infoRow(
                  icon: Icons.access_time,
                  title: 'Check-in after 2:00 pm',
                  subtitle: 'Checkout before 11:00 am',
                ),
                CommonWidgets.infoRow(
                  icon: Icons.pets_outlined,
                  title: 'Pets allowed',
                  subtitle: 'Please let your host know',
                ),
                CommonWidgets.infoRow(
                  icon: Icons.smoke_free,
                  title: 'No smoking',
                  subtitle: 'Smoking is not allowed indoors',
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CommonWidgets.bottomBar(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextWidget.titleLarge(
                    text: '₹18,500 night',
                  ),
                  AppTextWidget.labelMedium(
                    text: 'Add dates for prices',
                    color: AppColor.textSecondary,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 140.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => context.push(
                  RouteName.checkoutView.replaceFirst(
                    ':propertyId',
                    'modern-villa',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: AppTextWidget(
                  text: 'Reserve',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColor.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Image.network(
        PropertyDetailScreen.photos.first,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: AppColor.greyExtraLight),
      ),
      Positioned(
        top: MediaQuery.paddingOf(context).top + 8,
        left: 12.w,
        child: CommonWidgets.headerButton(
          icon: Icons.arrow_back,
          onTap: () => context.pop(),
        ),
      ),
      Positioned(
        top: MediaQuery.paddingOf(context).top + 8,
        right: 12.w,
        child: Row(
          children: [
            CommonWidgets.headerButton(icon: Icons.ios_share, onTap: () {}),
            SizedBox(width: 8.w),
            CommonWidgets.headerButton(icon: Icons.favorite_border, onTap: () {}),
          ],
        ),
      ),
      Positioned(
        bottom: 16.h,
        right: 16.w,
        child: CommonWidgets.imageCounterBadge(text: '1 / 8'),
      ),
    ],
  );
}

class _StaySummary extends StatelessWidget {
  const _StaySummary();
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: AppTextWidget.bodyMedium(
          text: '8 guests · 4 bedrooms · 5 beds · 3 baths',
          color: AppColor.textSecondary,
        ),
      ),
      Icon(Icons.verified_outlined, size: 20.sp),
    ],
  );
}

class _AmenityGrid extends StatelessWidget {
  const _AmenityGrid();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: _Amenity(icon: Icons.pool_outlined, text: 'Private pool'),
          ),
          Expanded(
            child: _Amenity(icon: Icons.wifi, text: 'Wifi'),
          ),
        ],
      ),
      SizedBox(height: 18.h),
      Row(
        children: [
          Expanded(
            child: _Amenity(icon: Icons.kitchen_outlined, text: 'Kitchen'),
          ),
          Expanded(
            child: _Amenity(
              icon: Icons.local_parking_outlined,
              text: 'Free parking',
            ),
          ),
        ],
      ),
    ],
  );
}

class _Amenity extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Amenity({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 21.sp),
      SizedBox(width: 12.w),
      AppTextWidget.bodyMedium(text: text),
    ],
  );
}

class _MapPainter extends CustomPainter {
  const _MapPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: .75)
      ..strokeWidth = 2;
    for (var i = 1; i < 6; i++)
      canvas.drawLine(
        Offset(size.width * i / 6, 0),
        Offset(size.width * i / 6, size.height),
        p,
      );
    for (var i = 1; i < 4; i++)
      canvas.drawLine(
        Offset(0, size.height * i / 4),
        Offset(size.width, size.height * i / 4),
        p,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
