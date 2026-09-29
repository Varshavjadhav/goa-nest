import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/utils.dart';
import 'package:goanest/widgets/app_text_widget.dart';
import 'package:goanest/widgets/common_widgets.dart';

import '../../data/model/home_model.dart';
import '../../data/model/property_detail_model.dart';
import '../bloc/property_detail_bloc.dart';
import '../bloc/property_detail_event.dart';
import '../bloc/property_detail_state.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';

class PropertyDetailScreen extends StatelessWidget {
  final String propertyId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? guests;

  const PropertyDetailScreen({
    super.key,
    required this.propertyId,
    this.checkIn,
    this.checkOut,
    this.guests,
  });

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
                  LoadPropertyDetail(
                    propertyId,
                    checkIn: checkIn == null ? null : _formatIsoDate(checkIn!),
                    checkOut: checkOut == null ? null : _formatIsoDate(checkOut!),
                  ),
                ),
            ),
          );
        }
        return _PropertyDetailContent(
          detail: (state as PropertyDetailLoaded).property,
          checkIn: checkIn,
          checkOut: checkOut,
          guests: guests,
        );
      },
    );
  }
}

class _PropertyDetailContent extends StatelessWidget {
  final PropertyDetailModel detail;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? guests;

  const _PropertyDetailContent({
    required this.detail,
    this.checkIn,
    this.checkOut,
    this.guests,
  });

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
    final canBook = detail.isAvailable && property.isAvailable;
    final actionLabel = !canBook
        ? 'Not available'
        : checkIn == null || checkOut == null
        ? 'Check availability'
        : property.requiresApproval
        ? 'Request to book'
        : 'Reserve';

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
                propertyId: property.id,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(48.r)),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: .08),
                    blurRadius: 22,
                    spreadRadius: -8,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 105.h),
              child: Column(
                children: [
                  if (!canBook)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEEE),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFF3B6B6)),
                      ),
                      child: AppTextWidget.bodyMedium(
                        text: checkIn != null && checkOut != null
                            ? 'Not available for ${_shortDate(checkIn!)} – ${_shortDate(checkOut!)}. Choose different dates to continue.'
                            : 'This property is currently not available to book.',
                        color: const Color(0xFFB42318),
                      ),
                    ),
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
                  if (detail.reviews.isEmpty)
                    AppTextWidget.bodyMedium(
                      text: property.totalReviews == 0
                          ? 'No reviews yet.'
                          : '${property.rating.toStringAsFixed(2)} average rating from ${property.totalReviews} reviews.',
                      color: AppColor.textSecondary,
                    )
                  else
                    for (final review in detail.reviews)
                      Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: AppColor.scaffoldBackground,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextWidget.titleSmall(
                                      text: review.guestName,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    size: 16.sp,
                                    color: AppColor.goldPlan,
                                  ),
                                  AppTextWidget.bodySmall(
                                    text: review.rating.toStringAsFixed(1),
                                  ),
                                ],
                              ),
                              if (review.comment.isNotEmpty) ...[
                                SizedBox(height: 6.h),
                                AppTextWidget.bodyMedium(
                                  text: review.comment,
                                  color: AppColor.textSecondary,
                                ),
                              ],
                            ],
                          ),
                        ),
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
                ],
              ),
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
                onPressed: canBook
                    ? () => context.pushNamed(
                        'booking-flow',
                        pathParameters: {'propertyId': property.id},
                        queryParameters: {
                          'title': property.title,
                          'nightlyPrice': property.pricePerNight,
                          if (image != null) 'image': image,
                          'rating': property.rating.toString(),
                          'reviewCount': property.totalReviews.toString(),
                          'location': location,
                          if (checkIn != null) 'checkIn': _isoDate(checkIn!),
                          if (checkOut != null) 'checkOut': _isoDate(checkOut!),
                          if (guests != null) 'guests': guests.toString(),
                        },
                      )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canBook
                      ? AppColor.primary
                      : AppColor.greyMedium,
                  foregroundColor: AppColor.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AppTextWidget(
                    text: actionLabel,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.white,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _isoDate(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}

String _shortDate(DateTime value) =>
    '${value.day}/${value.month}/${value.year}';

String _formatIsoDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

class _HeroImage extends StatelessWidget {
  final String? image;
  final int imageCount;
  final String propertyId;

  const _HeroImage({
    required this.image,
    required this.imageCount,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context) => BlocListener<WishlistBloc, WishlistState>(
    listenWhen: (_, state) =>
        (state is FavoriteUpdated && state.propertyId == propertyId) ||
        (state is FavoriteError && state.propertyId == propertyId),
    listener: (context, state) {
      if (state is FavoriteUpdated) {
        Utils.showSnackBar(
          state.message.isNotEmpty
              ? state.message
              : state.isLiked
              ? 'Added to your wishlist.'
              : 'Removed from your wishlist.',
          result: Result.success,
        );
      } else if (state is FavoriteError) {
        Utils.showSnackBar(state.message, result: Result.error);
      }
    },
    child: Stack(
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
            BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, state) {
                final lists = switch (state) {
                  WishlistLoaded value => value.wishlists,
                  FavoriteUpdated value => value.wishlists,
                  FavoriteError value => value.wishlists,
                  WishlistActionError value => value.wishlists,
                  _ => const [],
                };
                final liked =
                    state is FavoriteUpdated && state.propertyId == propertyId
                    ? state.isLiked
                    : lists.any(
                        (list) => list.properties.any(
                          (item) => item.property?.id == propertyId,
                        ),
                      );
                return CommonWidgets.headerButton(
                  icon: liked ? Icons.favorite : Icons.favorite_border,
                  onTap: () => context.read<WishlistBloc>().add(
                    ToggleFavorite(propertyId, isLiked: liked),
                  ),
                );
              },
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
    ),
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
          ElevatedButton(
            onPressed: onRetry,
            child: const AppTextWidget.legacy('Retry'),
          ),
        ],
      ),
    ),
  );
}
