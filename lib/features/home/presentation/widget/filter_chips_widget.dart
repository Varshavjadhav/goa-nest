import 'package:goanest/core.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: const [
          _FilterChip(label: 'All', selected: true),
          _FilterChip(label: 'Beach'),
          _FilterChip(label: 'Pool'),
          _FilterChip(label: 'Budget'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Container(
      height: 40.h,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(horizontal: selected ? 19.p : 21.p),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? theme.brandPrimary : AppColor.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: selected ? theme.brandPrimary : theme.divider,
        ),
      ),
      child: AppTextWidget(
        text: label,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: selected ? AppColor.white : theme.textSecondary,
      ),
    );
  }
}
