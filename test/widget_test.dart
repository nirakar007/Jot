import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jot_notes/main.dart'; // Update with your app's main file
import 'package:jot_notes/screens/edit.dart'; // Update with the correct path

void main() {
  testWidgets('App UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp()); // Replace MyApp() with your app's main widget

    // Wait for the main screen to load
    await tester.pumpAndSettle();

    // Find a widget on the main screen and verify it exists
    expect(find.byKey(Key('mainScreenTitle')), findsOneWidget);

    // Tap on a button to navigate to the edit screen
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Find widgets on the edit screen and verify they exist
    expect(find.byKey(Key('editScreenTitle')), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);

    // Enter text into a TextField
    await tester.enterText(find.byType(TextField).first, 'Test Title');
    await tester.enterText(find.byType(TextField).last, 'Test Content');

    // Tap on the save button
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Verify that the note is saved successfully
    expect(find.text('Note saved successfully.'), findsOneWidget);

    // Verify that the saved note is displayed on the main screen
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
  });
}
