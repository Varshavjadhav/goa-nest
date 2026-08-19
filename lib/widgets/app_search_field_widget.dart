import '../core.dart';
import '../resources/constants/app_colors.dart';
import '../utilities/extensions/extensions.dart';
import '../utilities/extensions/provide_theme_extension.dart';
import 'app_text_widget.dart';

class AppSearchField extends StatelessWidget {
  final String hintText;
  final bool showFilterButton;
  final VoidCallback? onFilterTap;
  final bool showIcon;
  final double? height;

  const AppSearchField({
    super.key,
    this.hintText = 'Where in Goa?',
    this.showFilterButton = false,
    this.onFilterTap,
    this.showIcon = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;
    final fieldHeight = height ?? 52.h;

    return Container(
      height: fieldHeight,
      padding: EdgeInsets.symmetric(horizontal: showIcon ? 17.p : 0),
      decoration: BoxDecoration(
        color: theme.inputFill,
        borderRadius: BorderRadius.circular(fieldHeight / 2),
        border: Border.all(color: theme.searchFieldBorder),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: showIcon || showFilterButton
          ? Row(
              children: [
                if (showIcon) ...[
                  Icon(Icons.search_rounded, color: theme.searchFieldIcon, size: 20.sp),
                  Gap(10.w),
                ],
                Expanded(
                  child: AppTextWidget(
                    text: hintText,
                    color: theme.searchFieldHint,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showFilterButton) ...[
                  Gap(8.w),
                  InkWell(
                    onTap: onFilterTap,
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: theme.brandPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: theme.brandPrimary,
                        size: 17.sp,
                      ),
                    ),
                  ),
                ],
              ],
            )
          : Center(
              child: AppTextWidget(
                text: hintText,
                color: theme.searchFieldHint,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}
