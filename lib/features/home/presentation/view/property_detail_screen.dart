import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

import '../../data/model/home_model.dart';
import '../../data/model/property_detail_model.dart';
import '../bloc/property_detail_bloc.dart';
import '../bloc/property_detail_event.dart';
import '../bloc/property_detail_state.dart';

class PropertyDetailScreen extends StatelessWidget {
  final String propertyId;

  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyDetailBloc, PropertyDetailState>(
      builder: (context, state) {
        if (state is PropertyDetailLoading || state is PropertyDetailInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is PropertyDetailError) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: _ErrorView(
              message: state.message,
              onRetry: () => context.read<PropertyDetailBloc>().add(
                LoadPropertyDetail(propertyId),
              ),
            ),
          );
        }
        return _PropertyDetailContent(
          detail: (state as PropertyDetailLoaded).property,
        );
      },
    );
  }
}

class _PropertyDetailContent extends StatelessWidget {
  final PropertyDetailModel detail;

  const _PropertyDetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    final property = detail.property;
    final image = property.images.isEmpty ? null : property.images.first;
    final location = [
      property.city,
      property.state,
      property.country,
    ].where((value) => value.isNotEmpty).join(', ');
    final price = property.pricePerNight.isEmpty
        ? 'Price unavailable'
        : '₹${property.pricePerNight} night';

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
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroImage(
                image: image,
                imageCount: property.images.length,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 105.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AppTextWidget.headlineLarge(text: property.title),
                SizedBox(height: 7.h),
                AppTextWidget.bodyMedium(
                  text: location.isEmpty ? property.location : location,
                  color: AppColor.textSecondary,
                ),
                SizedBox(height: 14.h),
                CommonWidgets.starRatingRow(
                  rating: property.rating.toStringAsFixed(2),
                  reviewCount: property.totalReviews.toString(),
                ),
                SizedBox(height: 18.h),
                _StaySummary(property: property),
                CommonWidgets.divider(),
                _HostInfo(property: property),
                CommonWidgets.divider(),
                AppTextWidget.headlineSmall(text: 'What this place offers'),
                SizedBox(height: 14.h),
                _AmenityGrid(amenities: property.amenities),
                if (property.amenities.length > 4) ...[
                  SizedBox(height: 14.h),
                  CommonWidgets.showMoreLink(
                    text: 'Show all ${property.amenities.length} amenities',
                  ),
                ],
                CommonWidgets.divider(),
                AppTextWidget.headlineSmall(text: 'About this place'),
                SizedBox(height: 10.h),
                AppTextWidget.bodyMedium(
                  text: property.description.isEmpty
                      ? 'No description available.'
                      : property.description,
                  height: 1.55,
                  color: AppColor.textSecondary,
                ),
                CommonWidgets.divider(height: 40),
                AppTextWidget.headlineSmall(text: 'Where you\'ll be'),
                SizedBox(height: 5.h),
                AppTextWidget.bodyMedium(
                  text: property.location.isEmpty
                      ? location
                      : property.location,
                  color: AppColor.textSecondary,
                ),
                SizedBox(height: 14.h),
                _MapPlaceholder(),
                CommonWidgets.divider(height: 40),
                AppTextWidget.headlineSmall(text: 'Guest reviews'),
                SizedBox(height: 14.h),
                AppTextWidget.bodyMedium(
                  text: property.totalReviews == 0
                      ? 'No reviews yet.'
                      : '${property.rating.toStringAsFixed(2)} average rating from ${property.totalReviews} reviews.',
                  color: AppColor.textSecondary,
                ),
                CommonWidgets.divider(height: 40),
                AppTextWidget.headlineSmall(text: 'Things to know'),
                SizedBox(height: 14.h),
                CommonWidgets.infoRow(
                  icon: Icons.access_time,
                  title: detail.checkInTime.isEmpty
                      ? 'Check-in time unavailable'
                      : 'Check-in after ${detail.checkInTime}',
                  subtitle: detail.checkOutTime.isEmpty
                      ? 'Checkout time unavailable'
                      : 'Checkout before ${detail.checkOutTime}',
                ),
                CommonWidgets.infoRow(
                  icon: Icons.nightlight_outlined,
                  title: '${detail.minimumNights} night minimum',
                  subtitle: '${detail.maximumNights} night maximum',
                ),
                if (detail.houseRules.isNotEmpty)
                  CommonWidgets.infoRow(
                    icon: Icons.rule,
                    title: 'House rules',
                    subtitle: detail.houseRules,
                  ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CommonWidgets.bottomBar(
        child: Row(
          children: [
            Expanded(child: AppTextWidget.titleLarge(text: price)),
            SizedBox(
              width: 140.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => context.push(
                  RouteName.checkoutView.replaceFirst(
                    ':propertyId',
                    property.id,
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
  final String? image;
  final int imageCount;

  const _HeroImage({required this.image, required this.imageCount});

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      if (image == null)
        Container(color: AppColor.greyExtraLight)
      else
        Image.network(
          image!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColor.greyExtraLight,
            child: const Icon(Icons.image_not_supported_outlined),
          ),
        ),
      Positioned(
        top: MediaQuery.paddingOf(context).top + 8,
        left: 12.w,
        child: CommonWidgets.headerButton(
          icon: Icons.arrow_back,
          onTap: context.pop,
        ),
      ),
      Positioned(
        top: MediaQuery.paddingOf(context).top + 8,
        right: 12.w,
        child: Row(
          children: [
            CommonWidgets.headerButton(icon: Icons.ios_share, onTap: () {}),
            SizedBox(width: 8.w),
            CommonWidgets.headerButton(
              icon: Icons.favorite_border,
              onTap: () {},
            ),
          ],
        ),
      ),
      if (imageCount > 0)
        Positioned(
          bottom: 16.h,
          right: 16.w,
          child: CommonWidgets.imageCounterBadge(text: '1 / $imageCount'),
        ),
    ],
  );
}

class _StaySummary extends StatelessWidget {
  final PropertyModel property;

  const _StaySummary({required this.property});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: AppTextWidget.bodyMedium(
          text:
              '${property.maxGuests} guests · ${property.bedrooms} bedrooms · ${property.beds} beds · ${property.bathrooms} baths',
          color: AppColor.textSecondary,
        ),
      ),
      Icon(Icons.verified_outlined, size: 20.sp),
    ],
  );
}

class _HostInfo extends StatelessWidget {
  final PropertyModel property;

  const _HostInfo({required this.property});

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      radius: 24.r,
      backgroundImage: property.hostAvatar.isEmpty
          ? null
          : NetworkImage(property.hostAvatar),
      child: property.hostAvatar.isEmpty
          ? const Icon(Icons.person_outline)
          : null,
    ),
    title: AppTextWidget(
      text: property.hostName.isEmpty
          ? 'Hosted by your host'
          : property.hostName,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    subtitle: AppTextWidget.bodySmall(
      text: property.hostBio.isEmpty ? 'Your host' : property.hostBio,
      color: AppColor.textSecondary,
    ),
  );
}

class _AmenityGrid extends StatelessWidget {
  final List<String> amenities;

  const _AmenityGrid({required this.amenities});

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) {
      return AppTextWidget.bodyMedium(
        text: 'No amenities listed.',
        color: AppColor.textSecondary,
      );
    }
    return Wrap(
      spacing: 20.w,
      runSpacing: 18.h,
      children: amenities
          .take(4)
          .map(
            (amenity) => SizedBox(
              width: 150.w,
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 21.sp),
                  SizedBox(width: 12.w),
                  Expanded(child: AppTextWidget.bodyMedium(text: amenity)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12.r),
    child: SizedBox(
      height: 190.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color(0xffdce8e5)),
          const Center(
            child: Icon(Icons.location_on, color: AppColor.primary, size: 36),
          ),
        ],
      ),
    ),
  );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextWidget.bodyMedium(
            text: message.isEmpty ? 'Unable to load this property.' : message,
            color: AppColor.textSecondary,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}
