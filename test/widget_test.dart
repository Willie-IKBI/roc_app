// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:roc_app/core/theme/roc_color_scheme.dart';
import 'package:roc_app/features/auth/controller/auth_controller.dart';
import 'package:roc_app/features/auth/presentation/login_screen.dart';

class _FakeSignInController extends SignInController {
  @override
  FutureOr<void> build() {}

  @override
  Future<void> submit({required String email, required String password}) async {
    state = const AsyncData(null);
  }
}

void main() {
  testWidgets('Login screen renders correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signInControllerProvider.overrideWith(() => _FakeSignInController()),
        ],
        child: MaterialApp(
          theme: rocTheme,
          home: const LoginScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  });
}
