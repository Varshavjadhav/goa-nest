import 'package:flutter/material.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({super.key});
  static const collections = [
    (
      'Summer Trip',
      '4 saved',
      'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=500',
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
    ),
    (
      'Dream Homes',
      '3 saved',
      'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=500',
      'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=500',
    ),
    (
      'Winter Getaway',
      '1 saved',
      'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=500',
      '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColor.surface,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: AppColor.surface,
            surfaceTintColor: Colors.transparent,
            pinned: true,
            elevation: 0,
            title: Text(
              'Wishlists',
              style: TextStyle(
                color: AppColor.textPrimary,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 100.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                for (final item in collections) _CollectionCard(item: item),
                SizedBox(height: 20.h),
                Text(
                  'Create new',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                _CreateCollection(onTap: () {}),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final (String, String, String, String) item;
  const _CollectionCard({required this.item});
  @override
  Widget build(BuildContext context) {
    final images = item.$4.isEmpty ? [item.$3] : [item.$3, item.$4];
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        // These are placeholder wishlist collections without backend IDs.
        onTap: null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                height: 148.h,
                child: Row(
                  children: [
                    Expanded(child: _CollectionImage(url: images[0])),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: images.length > 1
                          ? _CollectionImage(url: images[1])
                          : Container(
                              color: AppColor.greyExtraLight,
                              child: const Icon(Icons.home_outlined),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              item.$1,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 2.h),
            Text(
              item.$2,
              style: TextStyle(fontSize: 11.sp, color: AppColor.textQuaternary),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionImage extends StatelessWidget {
  final String url;
  const _CollectionImage({required this.url});
  @override
  Widget build(BuildContext context) => Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => Container(
      color: AppColor.greyExtraLight,
      child: const Icon(Icons.image_outlined, color: AppColor.greyMedium),
    ),
  );
}

class _CreateCollection extends StatelessWidget {
  final VoidCallback onTap;
  const _CreateCollection({required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Container(
      height: 112.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.divider),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: CircleAvatar(
          radius: 18.r,
          backgroundColor: AppColor.greyExtraLight,
          child: Icon(Icons.add, size: 18.sp, color: AppColor.greyDark),
        ),
      ),
    ),
  );
}
