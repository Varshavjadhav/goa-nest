import 'package:flutter_test/flutter_test.dart';
import 'package:goanest/app/view/app.dart';

void main() {
  testWidgets('App renders splash screen', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.text('Your Goa. Your Stay.'), findsOneWidget);
  });
}
