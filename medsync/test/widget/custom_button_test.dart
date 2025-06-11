import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medsync/core/widgets/loading_indicator.dart';

void main() {
  testWidgets('CustomButton shows text when not loading', (WidgetTester tester) async {
    bool buttonPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            onPressed: () => buttonPressed = true,
            isLoading: false,
          ),
        ),
      ),
    );

    // Verify button text is displayed
    expect(find.text('Test Button'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Test button press
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(buttonPressed, true);
  });

  testWidgets('CustomButton shows loading indicator when loading', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ),
    );

    // Verify loading indicator is shown and text is hidden
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Test Button'), findsNothing);

    // Verify button is disabled when loading
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Button should not be tappable when loading
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
} 