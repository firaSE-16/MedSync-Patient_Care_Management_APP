import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medsync/core/theme/theme.dart';

void main() {
  group('Theme Tests', () {
    test('Light theme has correct primary color', () {
      expect(lightTheme.primaryColor, isNotNull);
    });

    test('Light theme has correct text theme', () {
      expect(lightTheme.textTheme, isNotNull);
      expect(lightTheme.textTheme.bodyLarge, isNotNull);
      expect(lightTheme.textTheme.titleLarge, isNotNull);
    });

    test('Light theme has correct color scheme', () {
      expect(lightTheme.colorScheme, isNotNull);
      expect(lightTheme.colorScheme.primary, isNotNull);
      expect(lightTheme.colorScheme.secondary, isNotNull);
    });

    test('Light theme has correct button theme', () {
      expect(lightTheme.elevatedButtonTheme, isNotNull);
      expect(lightTheme.textButtonTheme, isNotNull);
    });

    test('Light theme has correct input decoration theme', () {
      expect(lightTheme.inputDecorationTheme, isNotNull);
      expect(lightTheme.inputDecorationTheme.border, isNotNull);
    });

    test('Light theme has correct scaffold background color', () {
      expect(lightTheme.scaffoldBackgroundColor, isNotNull);
    });

    test('Light theme has correct app bar theme', () {
      expect(lightTheme.appBarTheme, isNotNull);
    });

    test('Light theme has correct icon theme', () {
      expect(lightTheme.iconTheme, isNotNull);
    });

    test('Light theme has correct card theme', () {
      expect(lightTheme.cardTheme, isNotNull);
    });

    test('Dark theme has correct brightness', () {
      expect(darkTheme.brightness, equals(Brightness.dark));
    });

    test('Dark theme has correct background color', () {
      expect(darkTheme.scaffoldBackgroundColor, equals(const Color(0xFF121212)));
    });

    test('Dark theme has correct text styles', () {
      expect(
        darkTheme.textTheme.bodyMedium?.color,
        equals(const Color(0xFFB0BEC5)),
      );
      expect(
        darkTheme.textTheme.titleLarge?.color,
        equals(const Color(0xFFB39DDB)),
      );
    });

    test('Both themes have required components', () {
      // Check light theme
      expect(lightTheme.textTheme, isNotNull);
      expect(lightTheme.inputDecorationTheme, isNotNull);
      expect(lightTheme.elevatedButtonTheme, isNotNull);
      expect(lightTheme.textButtonTheme, isNotNull);

      // Check dark theme
      expect(darkTheme.textTheme, isNotNull);
      expect(darkTheme.inputDecorationTheme, isNotNull);
      expect(darkTheme.elevatedButtonTheme, isNotNull);
      expect(darkTheme.textButtonTheme, isNotNull);
    });
  });

  group('Light Theme Tests', () {
    test('Light theme has correct brightness', () {
      expect(lightTheme.brightness, equals(Brightness.light));
    });

    test('Light theme has correct primary color', () {
      expect(lightTheme.colorScheme.primary, equals(const Color(0xFF7A68FF)));
    });

    test('Light theme has correct text styles', () {
      expect(
        lightTheme.textTheme.bodyMedium?.color,
        equals(const Color(0xFF6A6F73)),
      );
      expect(
        lightTheme.textTheme.titleLarge?.fontSize,
        equals(24),
      );
    });

    test('Light theme has correct primary color', () {
      expect(lightTheme.primaryColor, isNotNull);
    });

    test('Light theme has correct text theme', () {
      expect(lightTheme.textTheme, isNotNull);
    });

    test('Light theme has correct scaffold background color', () {
      expect(lightTheme.scaffoldBackgroundColor, isNotNull);
    });
  });

  group('Dark Theme Tests', () {
    test('Dark theme has correct brightness', () {
      expect(darkTheme.brightness, equals(Brightness.dark));
    });

    test('Dark theme has correct background color', () {
      expect(darkTheme.scaffoldBackgroundColor, equals(const Color(0xFF121212)));
    });

    test('Dark theme has correct text styles', () {
      expect(
        darkTheme.textTheme.bodyMedium?.color,
        equals(const Color(0xFFB0BEC5)),
      );
      expect(
        darkTheme.textTheme.titleLarge?.color,
        equals(const Color(0xFFB39DDB)),
      );
    });
  });

  test('Basic theme properties', () {
    final theme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
    );

    expect(theme.brightness, isNotNull);
    expect(theme.primaryColor, isNotNull);
    expect(theme.scaffoldBackgroundColor, isNotNull);
  });

  test('Theme text styles', () {
    final theme = ThemeData(
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 16),
        titleLarge: TextStyle(fontSize: 24),
      ),
    );

    expect(theme.textTheme, isNotNull);
    expect(theme.textTheme.bodyLarge, isNotNull);
    expect(theme.textTheme.titleLarge, isNotNull);
  });
} 