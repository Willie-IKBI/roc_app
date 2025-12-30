import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roc_app/core/theme/roc_color_scheme.dart';
import 'package:roc_app/features/auth/presentation/login_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('renders login form with email and password fields', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: rocTheme,
            home: const LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Sign in'), findsWidgets);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('password field is obscured', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: rocTheme,
            home: const LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final passwordFields = find.byType(TextField);
      expect(passwordFields, findsNWidgets(2));
      
      // Password field should be the second TextField
      final passwordField = tester.widget<TextField>(passwordFields.at(1));
      expect(passwordField.obscureText, isTrue);
    });
  });
}

