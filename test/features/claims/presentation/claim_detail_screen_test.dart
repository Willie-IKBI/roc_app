import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roc_app/core/theme/roc_color_scheme.dart';
import 'package:roc_app/features/claims/presentation/claim_detail_screen.dart';

void main() {
  group('ClaimDetailScreen', () {
    testWidgets('renders claim detail screen with claim ID', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: rocTheme,
            home: const Scaffold(
              body: ClaimDetailScreen(claimId: 'test-claim-id'),
            ),
          ),
        ),
      );

      await tester.pump();

      // Screen should render
      expect(find.byType(ClaimDetailScreen), findsOneWidget);
    });
  });
}

