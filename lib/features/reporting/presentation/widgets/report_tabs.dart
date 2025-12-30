import 'package:flutter/material.dart';

enum ReportTab {
  overview,
  agentPerformance,
  statusDistribution,
  damageCause,
  geographic,
  insurerPerformance,
}

extension ReportTabExtension on ReportTab {
  String get label {
    switch (this) {
      case ReportTab.overview:
        return 'Overview';
      case ReportTab.agentPerformance:
        return 'Agent Performance';
      case ReportTab.statusDistribution:
        return 'Status Distribution';
      case ReportTab.damageCause:
        return 'Damage Cause';
      case ReportTab.geographic:
        return 'Geographic';
      case ReportTab.insurerPerformance:
        return 'Insurer Performance';
    }
  }

  IconData get icon {
    switch (this) {
      case ReportTab.overview:
        return Icons.dashboard_outlined;
      case ReportTab.agentPerformance:
        return Icons.people_outlined;
      case ReportTab.statusDistribution:
        return Icons.timeline_outlined;
      case ReportTab.damageCause:
        return Icons.build_outlined;
      case ReportTab.geographic:
        return Icons.map_outlined;
      case ReportTab.insurerPerformance:
        return Icons.business_outlined;
    }
  }
}

