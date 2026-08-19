import '../core.dart';
import '../utilities/extensions/extensions.dart';
import '../utilities/extensions/provide_theme_extension.dart';
import 'app_text_widget.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final double? fontSize;
  final Color? color;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.fontSize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeExt;

    return Row(
      children: [
        Expanded(
          child: AppTextWidget(
            text: title,
            fontSize: fontSize ?? 17.sp,
            fontWeight: FontWeight.w900,
            color: color ?? theme.textPrimary,
          ),
        ),
        if (action != null)
          AppTextWidget(
            text: action!,
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: theme.brandPrimary,
          ),
      ],
    );
  }
}
