// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/widgets.dart';
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

    // loading text.
    // await tester.tap(find.byType(Text));
    // await tester.pump();
    // final loadingTextFinder = find.text(Strings.loading);
    // expect(loadingTextFinder, findsOneWidget);
  });
}
