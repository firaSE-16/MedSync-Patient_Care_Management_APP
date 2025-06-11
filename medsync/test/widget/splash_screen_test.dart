import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget rendering test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('Welcome'),
              ElevatedButton(
                onPressed: () {},
                child: Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
} 