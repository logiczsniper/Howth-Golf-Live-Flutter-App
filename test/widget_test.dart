// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:howth_golf_live/main.dart';

void main() {
  testWidgets('Init test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Find the intro text.
    final introTextFinder = find.text("Tap anywhere to begin!");

    // Test!
    expect(introTextFinder, findsOneWidget);
  });
}
