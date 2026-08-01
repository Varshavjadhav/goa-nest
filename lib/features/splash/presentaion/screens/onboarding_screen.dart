import 'package:goanest/widgets/app_text_widget.dart';

import '../../../../core.dart';
import '../../../../utilities/extensions/extensions.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 360,
            child: Image.asset('assets/images/onboarding_pool.png', fit: BoxFit.cover, alignment: Alignment.topCenter),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 18, right: 22),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: .35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text('Skip', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 360,
              padding: const EdgeInsets.fromLTRB(28, 54, 28, 26),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
              ),
              child: Column(
                children: [
                  AppTextWidget(
                    text: "Discover Goa's Best\nStays",
                    color: Color(0xFF17191C),
                    fontSize: 28,
                    height: 1.22,
                    fontWeight: FontWeight.w800,
                    textAlign: TextAlign.center,
                  ),
                  Gap(22.h),
                  AppTextWidget(
                    text: '300+ verified hotels, villas, resorts\nand homestays across Goa',
                    textAlign: TextAlign.center,
                    color: Color(0xFF64676D),
                    fontSize: 15,
                    height: 1.6,
                  ),
                  const Spacer(),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: const [_Dot(active: true), _Dot(), _Dot()]),
                  Gap(34.h),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF064E36),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppTextWidget(text: 'Next', fontSize: 21, fontWeight: FontWeight.w800),
                          Gap(12.w),
                          Icon(Icons.arrow_forward, size: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 26 : 9,
      height: 9,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: active ? const Color(0xFF064E36) : const Color(0xFFD8D8D8), borderRadius: BorderRadius.circular(99)),
    );
  }
}
