import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roc_app/core/theme/roc_color_scheme.dart';
import 'package:roc_app/domain/models/claim_summary.dart';
import 'package:roc_app/domain/value_objects/claim_enums.dart';
import 'package:roc_app/features/dashboard/controller/dashboard_controller.dart';
import 'package:roc_app/features/dashboard/domain/dashboard_state.dart';
import 'package:roc_app/features/dashboard/presentation/dashboard_screen.dart';

class _FakeDashboardController extends DashboardController {
  _FakeDashboardController(this._state);

  final DashboardState _state;

  @override
  Future<DashboardState> build() async => _state;
}

void main() {
  ClaimSummary buildSummary({
    required String id,
    ClaimStatus status = ClaimStatus.inContact,
    PriorityLevel priority = PriorityLevel.high,
    Duration elapsed = const Duration(hours: 5),
    DateTime? latestContact,
  }) {
    final nextRetry = latestContact?.add(const Duration(minutes: 120));
    return ClaimSummary(
      claimId: id,
      claimNumber: 'ROC-$id',
      clientFullName: 'Client $id',
      primaryPhone: '+271234567$id',
      insurerName: 'InsureCo',
      status: status,
      priority: priority,
      slaStartedAt: DateTime.utc(2025, 11, 7, 8).add(Duration(minutes: int.parse(id))),
      elapsed: elapsed,
      latestContactAt: latestContact,
      latestContactOutcome: latestContact == null ? null : 'answered',
      slaTarget: const Duration(minutes: 240),
      attemptCount: 1,
      retryInterval: const Duration(minutes: 120),
      nextRetryAt: nextRetry,
      readyForRetry: latestContact == null,
      addressShort: '123 Main St, City',
    );
  }

  testWidgets('DashboardScreen shows metrics and sections', (tester) async {
    final claims = [
      buildSummary(id: '1', priority: PriorityLevel.urgent, elapsed: const Duration(hours: 6)),
      buildSummary(
        id: '2',
        status: ClaimStatus.awaitingClient,
        priority: PriorityLevel.normal,
        elapsed: const Duration(hours: 2),
        latestContact: DateTime.utc(2025, 11, 7, 4),
      ),
    ];

    final state = DashboardState.fromClaims(claims, now: DateTime.utc(2025, 11, 7, 12));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardControllerProvider.overrideWith(
            () => _FakeDashboardController(state),
          ),
        ],
        child: MaterialApp(
          theme: rocTheme,
          home: const DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Claims Ops Command Center'), findsOneWidget);
    expect(find.text('Active claims'), findsOneWidget);
    expect(find.text('Capture claim'), findsOneWidget);
  });
}

