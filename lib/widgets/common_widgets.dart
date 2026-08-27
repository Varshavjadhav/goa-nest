import '../core.dart';
import '../resources/constants/app_colors.dart';
import '../utilities/extensions/extensions.dart';
import 'app_text_widget.dart';

class CommonWidgets {
  CommonWidgets._();

  // ───────────────────────────── Spacing ─────────────────────────────

  static Widget verticalSpace(double height) => SizedBox(height: height.h);
  static Widget horizontalSpace(double width) => SizedBox(width: width.w);

  // ───────────────────────────── AppBar ─────────────────────────────

  static PreferredSizeWidget appBar({
    required String title,
    VoidCallback? onBackTap,
    bool showBack = true,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? surfaceTintColor,
    double elevation = 0,
  }) {
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      elevation: elevation,
      leading: showBack
          ? IconButton(
              onPressed: onBackTap,
              icon: Icon(Icons.arrow_back, size: 20.sp),
            )
          : null,
      title: AppTextWidget.headlineSmall(text: title),
      actions: actions,
    );
  }

  // ───────────────────────────── Divider ─────────────────────────────

  static Widget divider({double height = 35, Color? color}) {
    return Divider(height: height.h, color: color);
  }

  static Widget dividerLabel({
    required String label,
    Color? labelColor,
    double? fontSize,
  }) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColor.divider)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: AppTextWidget.bodyMedium(
            text: label,
            color: labelColor ?? AppColor.textQuaternary,
          ),
        ),
        const Expanded(child: Divider(color: AppColor.divider)),
      ],
    );
  }

  // ──────────────────────────── Section ─────────────────────────────

  static Widget sectionTitle(String title) {
    return AppTextWidget.headlineSmall(text: title);
  }

  // ──────────────────────────── Price Row ───────────────────────────

  static Widget priceRow({
    required String label,
    required String value,
    bool bold = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(
            child: AppTextWidget(
              text: label,
              fontSize: 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          AppTextWidget(
            text: value,
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ],
      ),
    );
  }

  // ──────────────────────────── Info Row ────────────────────────────

  static Widget infoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Row(
        children: [
          Icon(icon, size: 22.sp),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.labelLarge(text: title),
                SizedBox(height: 3.h),
                AppTextWidget.bodySmall(
                  text: subtitle,
                  color: AppColor.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────── Trip Row ────────────────────────────

  static Widget tripRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Row(
        children: [
          Icon(icon, size: 22.sp),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.labelLarge(text: title),
              SizedBox(height: 3.h),
              AppTextWidget.bodySmall(
                text: value,
                color: AppColor.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────── Stay Card ───────────────────────────

  static Widget stayCard({
    required String imageUrl,
    required String title,
    required String subtitle,
    String? rating,
    double? imageWidth,
    double? imageHeight,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.p),
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(color: AppColor.divider),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7.r),
              child: Image.network(
                imageUrl,
                width: imageWidth ?? 92.w,
                height: imageHeight ?? 92.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: imageWidth ?? 92.w,
                  height: imageHeight ?? 92.w,
                  color: AppColor.greyExtraLight,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget.titleSmall(text: title),
                  SizedBox(height: 6.h),
                  AppTextWidget.bodySmall(
                    text: subtitle,
                    color: AppColor.textSecondary,
                  ),
                  if (rating != null) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14.sp),
                        SizedBox(width: 3.w),
                        AppTextWidget.bodySmall(text: rating),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────── Input Field ─────────────────────────

  static InputDecoration inputDecoration({
    required String hint,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    EdgeInsetsGeometry? contentPadding,
    double borderRadius = 10,
  }) {
    return InputDecoration(
      hintText: hint,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(
        fontSize: 13.sp,
        color: AppColor.textQuaternary,
      ),
      filled: true,
      fillColor: AppColor.white,
      contentPadding: contentPadding ??
          EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius.r),
        borderSide: const BorderSide(color: AppColor.borderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius.r),
        borderSide: const BorderSide(color: AppColor.borderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius.r),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius.r),
        borderSide: const BorderSide(color: AppColor.error),
      ),
    );
  }

  // ──────────────────────────── Primary Button ──────────────────────

  static Widget primaryButton({
    required String label,
    required VoidCallback onTap,
    double? height,
    double? width,
    double borderRadius = 10,
  }) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
        child: AppTextWidget.titleSmall(
          text: label,
          color: AppColor.white,
        ),
      ),
    );
  }

  // ─────────────────────────── Provider Button ──────────────────────

  static Widget providerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    double borderRadius = 10,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 18.sp, color: iconColor ?? AppColor.black),
          label: AppTextWidget.bodyMedium(
            text: label,
            color: AppColor.textPrimary,
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColor.borderGrey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────── App Card ────────────────────────────

  static Widget appCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    Color? borderColor,
    double borderRadius = 10,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(12.p),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.white,
        border: borderColor != null ? Border.all(color: borderColor) : null,
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }

  // ─────────────────────────── Bottom Bar ───────────────────────────

  static Widget bottomBar({
    required Widget child,
    Color backgroundColor = AppColor.white,
    List<BoxShadow>? boxShadow,
  }) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: boxShadow ??
              [
                const BoxShadow(
                  color: AppColor.shadow,
                  blurRadius: 12,
                  offset: Offset(0, -3),
                ),
              ],
        ),
        child: child,
      ),
    );
  }

  // ─────────────────────────── Price Detail ─────────────────────────

  static Widget priceDetailRow({
    required String label,
    required String value,
    bool bold = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(
            child: AppTextWidget(
              text: label,
              fontSize: 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          AppTextWidget(
            text: value,
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ],
      ),
    );
  }

  // ──────────────────────────── Subtitle ────────────────────────────

  static Widget subtitleText(String text) {
    return AppTextWidget.bodyMedium(
      text: text,
      color: AppColor.textSecondary,
    );
  }

  // ──────────────────────────── Header Button ───────────────────────

  static Widget headerButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColor.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 38.w,
          height: 38.w,
          child: Icon(icon, size: 19.sp, color: AppColor.textPrimary),
        ),
      ),
    );
  }

  // ──────────────────────────── Rating Pill ─────────────────────────

  static Widget ratingPill({
    required String rating,
    double? fontSize,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.p, vertical: 4.p),
      decoration: BoxDecoration(
        color: AppColor.greyLight,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: AppColor.primary, size: 12.sp),
          Gap(3.w),
          AppTextWidget.labelSmall(text: rating),
        ],
      ),
    );
  }

  // ──────────────────────────── Dot Indicator ───────────────────────

  static Widget dotIndicator({required bool active}) {
    return Container(
      width: active ? 26.w : 9.w,
      height: 9.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: active ? AppColor.primary : AppColor.grey,
        borderRadius: BorderRadius.circular(99.r),
      ),
    );
  }

  // ──────────────────────────── Image Counter Badge ─────────────────

  static Widget imageCounterBadge({
    required String text,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.black.withValues(alpha: .7),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
        child: AppTextWidget.labelMedium(
          text: text,
          color: textColor ?? AppColor.white,
        ),
      ),
    );
  }

  // ──────────────────────────── Star Row ────────────────────────────

  static Widget starRatingRow({
    required String rating,
    required String reviewCount,
    bool showUnderline = true,
  }) {
    return Row(
      children: [
        Icon(Icons.star, size: 16.sp),
        SizedBox(width: 4.w),
        AppTextWidget.labelLarge(text: rating),
        SizedBox(width: 5.w),
        AppTextWidget.bodyMedium(
          text: '· $reviewCount reviews',
          textDecoration: showUnderline ? TextDecoration.underline : null,
        ),
      ],
    );
  }

  // ─────────────────────────── Show More Link ───────────────────────

  static Widget showMoreLink({
    required String text,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AppTextWidget.labelLarge(
        text: text,
        textDecoration: TextDecoration.underline,
      ),
    );
  }

  // ─────────────────────────── Review Card ──────────────────────────

  static Widget reviewCard({
    required String name,
    required String text,
    String? initials,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColor.greyExtraLight,
            child: AppTextWidget.bodyMedium(
              text: initials ?? name.substring(0, 1),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.labelLarge(text: name),
                SizedBox(height: 4.h),
                AppTextWidget.labelSmall(text: '\u2605\u2605\u2605\u2605\u2605'),
                SizedBox(height: 4.h),
                AppTextWidget.bodySmall(
                  text: text,
                  height: 1.4,
                  color: AppColor.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────── Disclaimer ──────────────────────────

  static Widget disclaimerText(String text) {
    return AppTextWidget.labelMedium(
      text: text,
      color: AppColor.textSecondary,
      textAlign: TextAlign.center,
    );
  }
}
