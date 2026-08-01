import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/widgets/app_text_widget.dart';

import '../../../../resources/constants/app_colors.dart';
import '../../../../resources/constants/constants.dart';
import '../../../../utilities/extensions/extensions.dart';
import '../../../../widgets/app_scaffold.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(const SplashStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashReadyState) {
            context.go(state.nextRoute);
          }
        },
        child: const _SplashView(),
      ),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isSafe: false,
      backgroundColor: AppColor.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _CoastalBackdrop(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.black.withValues(alpha: 0.06),
                  AppColor.black.withValues(alpha: 0.18),
                  AppColor.black.withValues(alpha: 0.58),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
              child: Column(
                children: [
                  const Spacer(flex: 4),
                  const _BrandMark(),
                  Gap(26.h),
                  AppTextWidget(
                    text: 'Your Goa. Your Stay.',
                    textAlign: TextAlign.center,
                    // style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColor.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  Gap(8.h),
                  AppTextWidget(
                    text: 'PREMIUM COASTAL LIVING',
                    textAlign: TextAlign.center,
                    // style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColor.white.withValues(alpha: 0.82),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    // ),
                  ),
                  const Spacer(flex: 5),
                  BlocBuilder<SplashBloc, SplashState>(
                    builder: (context, state) {
                      final message = state is SplashErrorState ? state.message : 'FETCHING PARADISE';

                      return Column(
                        children: [
                          AppTextWidget(
                            text: message,
                            // style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColor.white.withValues(alpha: 0.72),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                            // ),
                          ),
                          Gap(14.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              minHeight: 2.h,
                              backgroundColor: AppColor.white.withValues(alpha: 0.34),
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Gap(18.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104.h,
      width: 104.w,
      decoration: BoxDecoration(
        color: AppColor.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColor.white.withValues(alpha: 0.22)),
      ),
      child: Center(
        child: Container(
          height: 64.h,
          width: 64.w,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(2.r),
            boxShadow: [BoxShadow(color: AppColor.black.withValues(alpha: 0.12), blurRadius: 18, offset: const Offset(0, 10))],
          ),
          child: Center(
            child: Text(
              Constants.appName,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: const Color(0xFF174F3A), fontSize: 11.sp, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}

class _CoastalBackdrop extends StatelessWidget {
  const _CoastalBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6E8191), Color(0xFFD49E65), Color(0xFF7D523F), Color(0xFF2E2B2D)],
          stops: [0, 0.36, 0.64, 1],
        ),
      ),
      child: CustomPaint(painter: _CoastalBackdropPainter()),
    );
  }
}

class _CoastalBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sunPaint = Paint()..color = const Color(0xFFFFD49E).withValues(alpha: 0.34);
    canvas.drawCircle(Offset(size.width * 0.22, size.height * 0.34), size.width * 0.18, sunPaint);

    final waterPaint = Paint()..color = const Color(0xFF425F6A).withValues(alpha: 0.42);
    final waterPath = Path()
      ..moveTo(0, size.height * 0.58)
      ..cubicTo(size.width * 0.32, size.height * 0.52, size.width * 0.54, size.height * 0.66, size.width, size.height * 0.56)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    final shorePaint = Paint()..color = const Color(0xFFE5B47D).withValues(alpha: 0.28);
    final shorePath = Path()
      ..moveTo(size.width * 0.08, size.height)
      ..cubicTo(size.width * 0.22, size.height * 0.77, size.width * 0.44, size.height * 0.67, size.width * 0.82, size.height * 0.58)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(shorePath, shorePaint);

    final palmPaint = Paint()
      ..color = const Color(0xFF1C2A24).withValues(alpha: 0.48)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.78, size.height * 0.49), Offset(size.width * 0.86, size.height * 0.78), palmPaint);

    for (var i = 0; i < 5; i++) {
      final angle = -1.15 + (i * 0.45);
      final start = Offset(size.width * 0.78, size.height * 0.49);
      final end = Offset(start.dx + 70 * cos(angle), start.dy + 34 * sin(angle));
      canvas.drawLine(start, end, palmPaint..strokeWidth = 4);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
