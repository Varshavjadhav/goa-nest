// import '../../../../core.dart';
// import 'fatal_error_provider.dart';
//
// class GlobalErrorListener extends ConsumerWidget {
//   final Widget child;
//
//   const GlobalErrorListener({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.listen<AppException?>(fatalErrorProvider, (prev, next) {
//       debugPrint("*******************Global listener Initialized*******************");
//       if (next == null) return;
//
//       final navContext = Global.navigatorKey.currentContext;
//       if (navContext == null) return;
//
//       GoRouter.of(navContext).go(RouteName.appError, extra: next);
//
//       ref.read(fatalErrorProvider.notifier).state = null;
//     });
//
//     return child;
//   }
// }
