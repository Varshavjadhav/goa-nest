import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goanest/features/home/presentation/widget/category_tabs_widget.dart';
import 'package:goanest/features/home/presentation/widget/home_widget.dart';
import 'package:goanest/features/home/presentation/widget/popular_homes_grid_widget.dart';
import 'package:goanest/features/home/presentation/widget/recently_viewed_strip_widget.dart';
import 'package:goanest/features/home/presentation/widget/weekend_banner_widget.dart';
import 'package:goanest/resources/theme/theme.dart';
import 'package:goanest/utilities/ui_config/app_size_config.dart';

Widget harness(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('CategoryTabs no overflow', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SizeConfig.init(const BoxConstraints(maxWidth: 360, maxHeight: 800), Orientation.portrait);
    await tester.pumpWidget(
      harness(const CategoryTabs(selectedIndex: 0, onSelected: _noop)),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('RecentlyViewedStrip no overflow', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SizeConfig.init(const BoxConstraints(maxWidth: 360, maxHeight: 800), Orientation.portrait);
    await tester.pumpWidget(harness(const RecentlyViewedStrip()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('PopularHomesGrid no overflow', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SizeConfig.init(const BoxConstraints(maxWidth: 360, maxHeight: 800), Orientation.portrait);
    await tester.pumpWidget(harness(const PopularHomesGrid()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('WeekendBanner no overflow', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SizeConfig.init(const BoxConstraints(maxWidth: 360, maxHeight: 800), Orientation.portrait);
    await tester.pumpWidget(harness(const WeekendBanner()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('HomeWidget no overflow', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SizeConfig.init(const BoxConstraints(maxWidth: 360, maxHeight: 800), Orientation.portrait);
    await tester.pumpWidget(
      harness(const SizedBox(height: 800, width: 360, child: HomeWidget())),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}

void _noop(int _) {}
