import 'package:flutter_test/flutter_test.dart';

import 'package:howth_golf_live/constants/strings.dart';
import 'package:howth_golf_live/my_app.dart';

void main() {
  testWidgets('Init test', (WidgetTester tester) async {
    var app = MyApp.providedApp;

    // Build the app and trigger a frame.
    await tester.pumpWidget(app);

    // intro text.
    final introTextFinder = find.text(Strings.tapMe);
    expect(introTextFinder, findsOneWidget);
  });
}
