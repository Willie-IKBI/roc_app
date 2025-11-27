import 'package:freezed_annotation/freezed_annotation.dart';

part 'sla_rule.freezed.dart';

@freezed
abstract class SlaRule with _$SlaRule {
  const factory SlaRule({
    required String id,
    required String tenantId,
    required int timeToFirstContactMinutes,
    required bool breachHighlight,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SlaRule;
}

