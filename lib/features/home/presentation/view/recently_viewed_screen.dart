import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/screenshot_crop_widget.dart';

class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});

  static const _items = [
    _RecentlyItem(
      'Lonavala',
      'Favourite',
      '4.92',
      Rect.fromLTWH(33, 313, 130, 112),
    ),
    _RecentlyItem(
      'Commercial phot...',
      'Holiday Home™',
      null,
      Rect.fromLTWH(164, 340, 130, 112),
    ),
    _RecentlyItem(
      'Gurugram',
      '3 homes',
      null,
      Rect.fromLTWH(33, 581, 130, 112),
    ),
    _RecentlyItem(
      'Azure Bay Retreat',
      'Anjuna, North Goa',
      '4.9',
      Rect.fromLTWH(33, 313, 130, 112),
    ),
    _RecentlyItem(
      'Casa Verde Manor',
      'Assagao, Goa',
      '4.8',
      Rect.fromLTWH(164, 340, 130, 112),
    ),
    _RecentlyItem(
      'The Canopy Nest',
      'Agonda, South Goa',
      '5.0',
      Rect.fromLTWH(33, 847, 130, 112),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 22.sp,
            color: AppColor.textPrimary,
          ),
        ),
        title: AppTextWidget(
          text: 'Recently viewed',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColor.textPrimary,
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 18.h),
              child: AppTextWidget(
                text: 'Stays and places you recently explored',
                fontSize: 13,
                color: AppColor.textSecondary,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _RecentlyCard(item: _items[index]),
                childCount: _items.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 24.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentlyCard extends StatefulWidget {
  final _RecentlyItem item;

  const _RecentlyCard({required this.item});

  @override
  State<_RecentlyCard> createState() => _RecentlyCardState();
}

class _RecentlyCardState extends State<_RecentlyCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return GestureDetector(
      onTap: () => context.push(
        RouteName.propertyView.replaceFirst(':propertyId', 'recently-viewed'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 145.h,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ScreenshotCrop(crop: item.crop, borderRadius: 10.r),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () => setState(() => _liked = !_liked),
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: .92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _liked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 17.sp,
                        color: _liked ? AppColor.primary : AppColor.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: AppTextWidget(
                  text: item.title,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.rating != null) ...[
                Icon(Icons.star_rounded, size: 12.sp, color: AppColor.primary),
                SizedBox(width: 2.w),
                AppTextWidget(
                  text: item.rating!,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ],
            ],
          ),
          SizedBox(height: 3.h),
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
}

class _RecentlyItem {
  final String title;
  final String subtitle;
  final String? rating;
  final Rect crop;

  const _RecentlyItem(this.title, this.subtitle, this.rating, this.crop);
}
