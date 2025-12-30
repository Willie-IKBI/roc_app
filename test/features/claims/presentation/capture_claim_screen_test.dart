import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roc_app/core/theme/roc_color_scheme.dart';
import 'package:roc_app/features/claims/presentation/capture_claim_screen.dart';

void main() {
  group('CaptureClaimScreen', () {
    testWidgets('renders capture claim screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: rocTheme,
            home: const Scaffold(
              body: CaptureClaimScreen(),
            ),
          ),
        ),
      );

      // Wait for initial build
      await tester.pump();

      // Screen should render
      expect(find.byType(CaptureClaimScreen), findsOneWidget);
    });
  });
}

