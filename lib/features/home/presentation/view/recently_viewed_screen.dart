import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goanest/core.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';

import '../../data/model/home_model.dart';
import '../bloc/recently_viewed_bloc.dart';
import '../bloc/recently_viewed_event.dart';
import '../bloc/recently_viewed_state.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';

class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
    body: BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
      builder: (context, state) {
        if (state is RecentlyViewedLoading || state is RecentlyViewedInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RecentlyViewedError) {
          return _MessageView(
            message: state.message,
            action: () =>
                context.read<RecentlyViewedBloc>().add(LoadRecentlyViewed()),
          );
        }
        final result = (state as RecentlyViewedLoaded).result;
        if (result.properties.isEmpty) {
          return const _MessageView(
            message: 'You have not viewed any stays yet.',
          );
        }
        return CustomScrollView(
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
                  (_, index) =>
                      _RecentlyCard(property: result.properties[index]),
                  childCount: result.properties.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .68,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 24.h,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _RecentlyCard extends StatefulWidget {
  final PropertyModel property;
  const _RecentlyCard({required this.property});

  @override
  State<_RecentlyCard> createState() => _RecentlyCardState();
}

class _RecentlyCardState extends State<_RecentlyCard> {
  late bool liked = widget.property.isLiked;

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final image = property.images.isEmpty ? '' : property.images.first;
    return GestureDetector(
      onTap: property.id.isEmpty
          ? null
          : () => context.push(
              RouteName.propertyView.replaceFirst(':propertyId', property.id),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: image.isEmpty
                        ? _placeholder()
                        : Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          ),
                  ),
                ),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: BlocListener<WishlistBloc, WishlistState>(
                listenWhen: (_, state) => state is FavoriteUpdated || state is FavoriteError,
                listener: (_, state) {
                  if (state is FavoriteUpdated && state.propertyId == property.id) {
                    setState(() => liked = state.isLiked);
                  } else if (state is FavoriteError && state.propertyId == property.id) {
                    setState(() => liked = state.previousIsLiked);
                  }
                },
                child: GestureDetector(
                    onTap: property.id.isEmpty
                        ? null
                        : () {
                            final wasLiked = liked;
                            setState(() => liked = !liked);
                            context.read<WishlistBloc>().add(
                              ToggleFavorite(property.id, isLiked: wasLiked),
                            );
                          },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: .92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        liked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 17.sp,
                        color: liked ? AppColor.primary : AppColor.textPrimary,
                      ),
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
                  text: property.title,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.star_rounded, size: 12.sp, color: AppColor.primary),
              SizedBox(width: 2.w),
              AppTextWidget(
                text: property.rating.toStringAsFixed(2),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          AppTextWidget(
            text: property.location,
            fontSize: 11,
            color: AppColor.textSecondary,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          AppTextWidget(
            text: '${property.pricePerNight} / night',
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    color: AppColor.greyExtraLight,
    alignment: Alignment.center,
    child: Icon(Icons.home_outlined, size: 34.sp, color: AppColor.grey),
  );
}

class _MessageView extends StatelessWidget {
  final String message;
  final VoidCallback? action;
  const _MessageView({required this.message, this.action});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextWidget(
            text: message,
            fontSize: 14,
            color: AppColor.textSecondary,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            SizedBox(height: 14.h),
            ElevatedButton(onPressed: action, child: const Text('Try again')),
          ],
        ],
      ),
    ),
  );
}
