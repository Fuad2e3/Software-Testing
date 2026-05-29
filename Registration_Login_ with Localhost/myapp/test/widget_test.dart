import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('App loads login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login screen is shown.
    expect(find.text('Login'), findsWidgets); // App bar and button text
    expect(find.byType(TextField), findsNWidgets(2)); // Email and Password fields
  });
}
