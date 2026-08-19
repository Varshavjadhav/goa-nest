import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/core.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/utilities/extensions/provide_theme_extension.dart';
import 'package:goanest/widgets/goa_logo_widget.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const GoaLogo(),
        const Spacer(),
        _IconButton(icon: Icons.notifications_none_rounded, onTap: () {}),
        Gap(14.w),
        _IconButton(
          icon: Icons.tune_rounded,
          onTap: () => context.push(RouteName.filterView),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: SizedBox(
        width: 28.w,
        height: 28.w,
        child: Icon(icon, color: context.themeExt.textPrimary, size: 18.sp),
      ),
    );
  }
}
