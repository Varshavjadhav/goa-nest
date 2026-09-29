import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:goanest/core.dart';
import 'package:goanest/core/data/error/app_exception.dart';
import 'package:goanest/core/di/injector.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/utils.dart';
import 'package:goanest/widgets/app_text_widget.dart';

import '../../data/model/home_model.dart';
import '../../data/model/wishlist_model.dart';
import '../../data/model/search_model.dart';
import '../../domain/usecase/search_properties.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({super.key});
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColor.surface,
    child: BlocListener<WishlistBloc, WishlistState>(
      listenWhen: (_, state) =>
          state is WishlistActionError ||
          (state is WishlistLoaded && state.message.isNotEmpty),
      listener: (context, state) {
        if (state is WishlistActionError) {
          Utils.showSnackBar(state.message, result: Result.error);
        } else if (state is WishlistLoaded && state.message.isNotEmpty) {
          Utils.showSnackBar(state.message, result: Result.success);
        }
      },
      child: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading || state is WishlistInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WishlistError) {
            return _MessageView(
              message: state.message,
              action: () => context.read<WishlistBloc>().add(LoadWishlists()),
            );
          }
          final wishlists = state is WishlistLoaded
              ? state.wishlists
              : state is WishlistActionError
              ? state.wishlists
              : state is FavoriteUpdated
              ? state.wishlists
              : state is FavoriteError
              ? state.wishlists
              : const <WishlistModel>[];
          return _Content(wishlists: wishlists);
        },
      ),
    ),
  );
}

class _Content extends StatelessWidget {
  final List<WishlistModel> wishlists;
  const _Content({required this.wishlists});
  @override
  Widget build(BuildContext context) => CustomScrollView(
    physics: const BouncingScrollPhysics(),
    slivers: [
      SliverAppBar(
        backgroundColor: AppColor.surface,
        surfaceTintColor: Colors.transparent,
        pinned: true,
        elevation: 0,
        title: AppTextWidget.legacy(
          'Wishlists',
          style: TextStyle(
            color: AppColor.textPrimary,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _showCreateDialog(context),
            child: AppTextWidget.legacy(
              'Create',
              style: TextStyle(color: AppColor.textPrimary, fontSize: 12.sp),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      SliverPadding(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 100.h),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            if (wishlists.isEmpty) const _EmptyWishlists(),
            for (final wishlist in wishlists)
              _CollectionCard(
                wishlist: wishlist,
                onTap: () => _showWishlistDetails(context, wishlist),
                onAdd: () => _showAddPropertyDialog(context, wishlist),
              ),
            SizedBox(height: 4.h),
            AppTextWidget.legacy(
              'Create new',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10.h),
            _CreateCollection(onTap: () => _showCreateDialog(context)),
          ]),
        ),
      ),
    ],
  );
}

class _CollectionCard extends StatelessWidget {
  final WishlistModel wishlist;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  const _CollectionCard({
    required this.wishlist,
    required this.onTap,
    required this.onAdd,
  });
  @override
  Widget build(BuildContext context) {
    final images = wishlist.properties
        .map((item) => item.property?.images.firstOrNull ?? '')
        .where((url) => url.isNotEmpty)
        .take(2)
        .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                height: 148.h,
                child: Row(
                  children: [
                    Expanded(
                      child: _CollectionImage(url: images.firstOrNull ?? ''),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _CollectionImage(
                        url: images.length > 1 ? images[1] : '',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            AppTextWidget.legacy(
              wishlist.name,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: AppTextWidget.legacy(
                    '${wishlist.properties.where((item) => item.property != null).length} saved',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColor.textQuaternary,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: Icon(Icons.add_rounded, size: 16.sp),
                  label: AppTextWidget.legacy(
                    'Add stays',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    minimumSize: Size(0, 32.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
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
  Widget build(BuildContext context) => url.isEmpty
      ? Container(
          color: AppColor.greyExtraLight,
          child: const Icon(Icons.home_outlined, color: AppColor.greyMedium),
        )
      : Image.network(
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

class _EmptyWishlists extends StatelessWidget {
  const _EmptyWishlists();
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 44.h),
    child: Column(
      children: [
        Icon(
          Icons.favorite_border_rounded,
          size: 48.sp,
          color: AppColor.greyMedium,
        ),
        SizedBox(height: 12.h),
        AppTextWidget.legacy(
          'No wishlists yet',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 5.h),
        AppTextWidget.legacy(
          'Create one to save your favourite stays.',
          style: TextStyle(fontSize: 12.sp, color: AppColor.textSecondary),
        ),
      ],
    ),
  );
}

class _MessageView extends StatelessWidget {
  final String message;
  final VoidCallback action;
  const _MessageView({required this.message, required this.action});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget.legacy(message, textAlign: TextAlign.center),
        SizedBox(height: 12.h),
        TextButton(
          onPressed: action,
          child: const AppTextWidget.legacy('Retry'),
        ),
      ],
    ),
  );
}

Future<void> _showCreateDialog(BuildContext context) async {
  final name = await showDialog<String>(
    context: context,
    builder: (_) => const _CreateWishlistDialog(),
  );
  if (name != null && context.mounted)
    context.read<WishlistBloc>().add(CreateWishlist(name));
}

class _CreateWishlistDialog extends StatefulWidget {
  const _CreateWishlistDialog();

  @override
  State<_CreateWishlistDialog> createState() => _CreateWishlistDialogState();
}

class _CreateWishlistDialogState extends State<_CreateWishlistDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const AppTextWidget.legacy('Create wishlist'),
    content: TextField(
      controller: _controller,
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(hintText: 'Wishlist name'),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const AppTextWidget.legacy('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          final value = _controller.text.trim();
          if (value.isNotEmpty) Navigator.pop(context, value);
        },
        child: const AppTextWidget.legacy('Create'),
      ),
    ],
  );
}

Future<void> _showWishlistDetails(
  BuildContext context,
  WishlistModel wishlist,
) {
  final wishlistBloc = context.read<WishlistBloc>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.surface,
    builder: (_) => BlocProvider.value(
      value: wishlistBloc,
      child: _WishlistDetails(wishlist: wishlist),
    ),
  );
}

class _WishlistDetails extends StatelessWidget {
  final WishlistModel wishlist;
  const _WishlistDetails({required this.wishlist});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 12.h),
      child: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          final current = state is WishlistLoaded
              ? state.wishlists.firstWhere(
                  (item) => item.id == wishlist.id,
                  orElse: () => wishlist,
                )
              : wishlist;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.legacy(
                current.name,
                style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4.h),
              AppTextWidget.legacy(
                '${current.properties.length} saved properties',
                style: TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 16.h),
              if (current.properties.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: AppTextWidget.legacy('No properties saved yet.'),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: current.properties.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, index) {
                      final saved = current.properties[index];
                      final property = saved.property;
                      if (property == null) return const SizedBox.shrink();
                      return _PropertyRow(
                        property: property,
                        onRemove: () => context.read<WishlistBloc>().add(
                          RemovePropertyFromWishlist(current.id, property.id),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 14.h),
              OutlinedButton.icon(
                onPressed: () => _showAddPropertyDialog(context, current),
                icon: const Icon(Icons.add),
                label: const AppTextWidget.legacy('Add property'),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class _PropertyRow extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback onRemove;
  const _PropertyRow({required this.property, required this.onRemove});
  @override
  Widget build(BuildContext context) {
    final image = property.images.firstOrNull;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: SizedBox(
            width: 66.w,
            height: 58.h,
            child: image == null
                ? const _CollectionImage(url: '')
                : Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const _CollectionImage(url: ''),
                  ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.legacy(
                property.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 3.h),
              AppTextWidget.legacy(
                property.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColor.textSecondary,
                ),
              ),
              SizedBox(height: 3.h),
              AppTextWidget.legacy(
                '₹${property.pricePerNight} / night',
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.delete_outline_rounded),
        ),
      ],
    );
  }
}

Future<void> _showAddPropertyDialog(
  BuildContext context,
  WishlistModel wishlist,
) async {
  final propertyId = await showDialog<String>(
    context: context,
    builder: (_) => const _AddPropertyDialog(),
  );
  if (propertyId != null && context.mounted)
    context.read<WishlistBloc>().add(
      AddPropertyToWishlist(wishlist.id, propertyId),
    );
}

class _AddPropertyDialog extends StatefulWidget {
  const _AddPropertyDialog();

  @override
  State<_AddPropertyDialog> createState() => _AddPropertyDialogState();
}

class _AddPropertyDialogState extends State<_AddPropertyDialog> {
  late Future<Either<AppException, SearchResultsModel>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  void _loadProperties() {
    _propertiesFuture = sl<SearchPropertiesUseCase>()(
      const SearchQuery(limit: 50),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const AppTextWidget.legacy('Add property'),
    content: SizedBox(
      width: 420.w,
      height: 390.h,
      child: FutureBuilder<Either<AppException, SearchResultsModel>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final result = snapshot.data;
          if (snapshot.hasError || result == null) {
            return _PropertyPickerError(onRetry: () => setState(_loadProperties));
          }
          return result.fold(
            (error) => _PropertyPickerError(
              message: error.message,
              onRetry: () => setState(_loadProperties),
            ),
            (results) => results.items.isEmpty
                ? const Center(child: AppTextWidget.legacy('No stays available.'))
                : ListView.separated(
                    itemCount: results.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final property = results.items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: SizedBox(
                            width: 54.w,
                            height: 54.w,
                            child: property.imageUrl.isEmpty
                                ? const _CollectionImage(url: '')
                                : Image.network(
                                    property.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const _CollectionImage(url: ''),
                                  ),
                          ),
                        ),
                        title: AppTextWidget.legacy(
                          property.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: AppTextWidget.legacy(
                          '${property.location} · ₹${property.pricePerNight.toStringAsFixed(0)} / night',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColor.textSecondary,
                          ),
                        ),
                        onTap: () => Navigator.pop(context, property.id),
                      );
                    },
                  ),
          );
        },
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const AppTextWidget.legacy('Cancel'),
      ),
    ],
  );
}

class _PropertyPickerError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PropertyPickerError({
    this.message = 'Could not load stays.',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget.legacy(message, textAlign: TextAlign.center),
        SizedBox(height: 8.h),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    ),
  );
}
