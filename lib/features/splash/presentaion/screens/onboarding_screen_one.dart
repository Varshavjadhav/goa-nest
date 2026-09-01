import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/resources/constants/app_colors.dart';
import 'package:goanest/utilities/extensions/extensions.dart';
import 'package:goanest/widgets/app_text_widget.dart';

class OnboardingScreenOne extends StatefulWidget {
  const OnboardingScreenOne({super.key});

  @override
  State<OnboardingScreenOne> createState() => _OnboardingScreenOneState();
}

class _OnboardingScreenOneState extends State<OnboardingScreenOne>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _necessaryCookies = true;
  bool _functionalCookies = true;
  bool _analyticsCookies = true;
  bool _advertisementCookies = false;
  bool _othersCookies = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColor.textPrimary, size: 24.sp),
          onPressed: () => context.go(RouteName.loginView),
        ),
        title: AppTextWidget(
          text: 'Privacy Preference Center',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColor.textPrimary,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              border: Border(
                bottom: BorderSide(color: AppColor.homeDivider, width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColor.textPrimary,
              unselectedLabelColor: AppColor.textSecondary,
              indicatorColor: AppColor.textPrimary,
              indicatorWeight: 3,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Suggested'),
                Tab(text: 'View Preferences'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSuggestedTab(),
                _buildViewPreferencesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColor.greyExtraLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget(
                  text: 'Cookie Declaration',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
                SizedBox(height: 8.h),
                AppTextWidget(
                  text: 'https://www.goanest.com',
                  fontSize: 13,
                  color: AppColor.primary,
                ),
                SizedBox(height: 4.h),
                AppTextWidget(
                  text: 'Updated on 27 Aug 2026',
                  fontSize: 12,
                  color: AppColor.textSecondary,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _acceptAll();
                    context.go(RouteName.homeView);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: AppTextWidget(
                    text: 'Accept All',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.white,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _declineAll();
                    context.go(RouteName.homeView);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.textPrimary,
                    side: BorderSide(color: AppColor.homeDivider),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: AppTextWidget(
                    text: 'Decline',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                _savePreferences();
                context.go(RouteName.homeView);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: AppTextWidget(
                text: 'Save Preferences',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewPreferencesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCookieCategory(
            title: 'Necessary',
            subtitle: 'These cookies are necessary for the website to function properly. They enable core functionalities such as security, network management, and account access.',
            value: _necessaryCookies,
            onChanged: (value) {
              setState(() => _necessaryCookies = value);
            },
            isRequired: true,
          ),
          _buildDivider(),
          _buildCookieCategory(
            title: 'Functional',
            subtitle: 'Functional cookies help perform certain functionalities like sharing the content of the website on social media platforms, collecting feedback, and other third-party features.',
            value: _functionalCookies,
            onChanged: (value) {
              setState(() => _functionalCookies = value);
            },
          ),
          _buildDivider(),
          _buildCookieCategory(
            title: 'Analytics',
            subtitle: 'Analytical cookies are used to understand how visitors interact with the website. These cookies help provide information on metrics such as number of visitors, bounce rate, traffic source, etc.',
            value: _analyticsCookies,
            onChanged: (value) {
              setState(() => _analyticsCookies = value);
            },
          ),
          _buildDivider(),
          _buildCookieCategory(
            title: 'Advertisement',
            subtitle: 'Advertisement cookies are used to provide visitors with customized advertisements based on the pages you have visited before and to analyze the effectiveness of the ad campaigns.',
            value: _advertisementCookies,
            onChanged: (value) {
              setState(() => _advertisementCookies = value);
            },
          ),
          _buildDivider(),
          _buildCookieCategory(
            title: 'Others',
            subtitle: 'Other uncategorized cookies are those that are being analyzed and have not been classified into a category as yet.',
            value: _othersCookies,
            onChanged: (value) {
              setState(() => _othersCookies = value);
            },
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _savePreferences();
                context.go(RouteName.homeView);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: AppTextWidget(
                text: 'Save Preferences',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCookieCategory({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isRequired = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppTextWidget(
                      text: title,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                    if (isRequired) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColor.greyExtraLight,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: AppTextWidget(
                          text: 'Always Active',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 6.h),
                AppTextWidget(
                  text: subtitle,
                  fontSize: 12,
                  color: AppColor.textSecondary,
                  height: 1.4,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Switch(
            value: value,
            onChanged: isRequired ? null : onChanged,
            activeThumbColor: AppColor.primary,
            inactiveTrackColor: AppColor.greyExtraLight,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColor.homeDivider,
    );
  }

  void _acceptAll() {
    setState(() {
      _necessaryCookies = true;
      _functionalCookies = true;
      _analyticsCookies = true;
      _advertisementCookies = true;
      _othersCookies = true;
    });
  }

  void _declineAll() {
    setState(() {
      _necessaryCookies = true; // Always required
      _functionalCookies = false;
      _analyticsCookies = false;
      _advertisementCookies = false;
      _othersCookies = false;
    });
  }

  void _savePreferences() {
    // Save preferences logic here
    debugPrint('''
      Cookie Preferences:
      - Necessary: $_necessaryCookies
      - Functional: $_functionalCookies
      - Analytics: $_analyticsCookies
      - Advertisement: $_advertisementCookies
      - Others: $_othersCookies
    ''');
  }
}
