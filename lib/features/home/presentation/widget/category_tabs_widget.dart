import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class CategoryTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CategoryTabs({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const _tabs = [
    ('All', Icons.diamond_rounded, Color(0xFFE3AF43)),
    ('Homes', Icons.home_rounded, Color(0xFFC7364A)),
    ('Experiences', Icons.camera_alt_outlined, Color(0xFFE86B26)),
    ('Services', Icons.build_rounded, Color(0xFF4A5767)),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.p),
        itemCount: _tabs.length,
        separatorBuilder: (_, _) => Gap(18.w),
        itemBuilder: (context, index) => _buildTab(context, index),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index) {
    final theme = context.themeExt;
    final isSelected = index == selectedIndex;
    final (label, icon, iconColor) = _tabs[index];

    return GestureDetector(
      onTap: () => onSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 18.p),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? theme.tabSelectedBackground : theme.tabBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected ? null : Border.all(color: theme.tabBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 15.sp),
            Gap(6.w),
            AppTextWidget(
              text: label,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? theme.tabSelectedForeground
                  : theme.tabForeground,
            ),
          ],
        ),
      ),
    );
  }
}
