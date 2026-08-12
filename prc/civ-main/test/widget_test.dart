import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:civilwatch/app.dart';

void main() {
  testWidgets('CivilWatch app smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const CivilWatchApp());

    // Verify the app renders a MaterialApp without crashing.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
