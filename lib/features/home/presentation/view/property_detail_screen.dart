import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';

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
                Text(
                  'Modern villa with pool',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'Entire villa in North Goa, India',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColor.textSecondary,
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Icon(Icons.star, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      '· 24 reviews',
                      style: TextStyle(
                        fontSize: 13.sp,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                const _StaySummary(),
                Divider(height: 35.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 24.r,
                    backgroundImage: const NetworkImage(
                      'https://i.pravatar.cc/100?img=47',
                    ),
                  ),
                  title: Text(
                    'Hosted by Anika',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Superhost · 5 years hosting',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),
                Divider(height: 35.h),
                Text(
                  'What this place offers',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 14.h),
                const _AmenityGrid(),
                SizedBox(height: 14.h),
                Text(
                  'Show all 12 amenities',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Divider(height: 35.h),
                Text(
                  'About this place',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Wake up to open skies and relaxed coastal living in this beautiful Goa retreat. Enjoy a private pool, thoughtful interiors, and easy access to the beach, restaurants, and local markets.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.55,
                    color: AppColor.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Show more',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Divider(height: 40.h),
                Text(
                  'Where you\'ll be',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'North Goa, Goa, India',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColor.textSecondary,
                  ),
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
                Divider(height: 40.h),
                Text(
                  'Guest reviews',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 14.h),
                const _ReviewCard(
                  name: 'Rohan',
                  text:
                      'Beautiful home, thoughtful host, and the pool was perfect for a relaxing weekend.',
                ),
                const _ReviewCard(
                  name: 'Maya',
                  text:
                      'Exactly as pictured. The location made it easy to explore North Goa.',
                ),
                Text(
                  'Show all 24 reviews',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Divider(height: 40.h),
                Text(
                  'Things to know',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 14.h),
                const _InfoRow(
                  icon: Icons.access_time,
                  title: 'Check-in after 2:00 pm',
                  subtitle: 'Checkout before 11:00 am',
                ),
                const _InfoRow(
                  icon: Icons.pets_outlined,
                  title: 'Pets allowed',
                  subtitle: 'Please let your host know',
                ),
                const _InfoRow(
                  icon: Icons.smoke_free,
                  title: 'No smoking',
                  subtitle: 'Smoking is not allowed indoors',
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
          decoration: const BoxDecoration(
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.shadow,
                blurRadius: 12,
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
                    Text(
                      '₹18,500 night',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Add dates for prices',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColor.textSecondary,
                      ),
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
                  child: Text(
                    'Reserve',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        child: _HeaderButton(
          icon: Icons.arrow_back,
          onTap: () => context.pop(),
        ),
      ),
      Positioned(
        top: MediaQuery.paddingOf(context).top + 8,
        right: 12.w,
        child: Row(
          children: [
            _HeaderButton(icon: Icons.ios_share, onTap: () {}),
            SizedBox(width: 8.w),
            _HeaderButton(icon: Icons.favorite_border, onTap: () {}),
          ],
        ),
      ),
      Positioned(
        bottom: 16.h,
        right: 16.w,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColor.black.withValues(alpha: .7),
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 9.w,
              vertical: 5.h,
            ),
            child: Text(
              '1 / 8',
              style: TextStyle(
                color: AppColor.white,
                fontSize: 11.sp,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
    color: AppColor.white,
    shape: const CircleBorder(),
    elevation: 2,
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 38.w,
        height: 38.w,
        child: Icon(
          icon,
          size: 19.sp,
          color: AppColor.textPrimary,
        ),
      ),
    ),
  );
}

class _StaySummary extends StatelessWidget {
  const _StaySummary();
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          '8 guests · 4 bedrooms · 5 beds · 3 baths',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColor.textSecondary,
          ),
        ),
      ),
      Icon(Icons.verified_outlined, size: 20.sp),
    ],
  );
}

class _ReviewCard extends StatelessWidget {
  final String name, text;
  const _ReviewCard({required this.name, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 16.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColor.greyExtraLight,
          child: Text(name.substring(0, 1)),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '★★★★★',
                style: TextStyle(fontSize: 11.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.4,
                  color: AppColor.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 18.h),
    child: Row(
      children: [
        Icon(icon, size: 22.sp),
        SizedBox(width: 14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ],
    ),
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
      Text(
        text,
        style: TextStyle(fontSize: 13.sp),
      ),
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
