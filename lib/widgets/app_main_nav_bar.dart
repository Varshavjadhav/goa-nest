import '../core.dart';
import '../resources/constants/app_colors.dart';
import '../utilities/extensions/extensions.dart';
import '../utilities/extensions/provide_theme_extension.dart';
import 'app_text_widget.dart';

class AppMainNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AppMainNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class AppMainNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppMainNavItem> items;

  const AppMainNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      height: 76.h,
      padding: EdgeInsets.fromLTRB(8.p, 7.p, 8.p, 8.p),
      decoration: BoxDecoration(
        color: theme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          final color =
              isSelected ? theme.brandPrimary : theme.textSecondary;

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8.r),
              onTap: () => onTap(index),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.p),
                child: SizedBox(
                  height: 58.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: color,
                        size: 19.sp,
                      ),
                      Gap(5.h),
                      AppTextWidget(
                        text: item.label,
                        color: color,
                        fontSize: 9.sp,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w500,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
