import 'package:freezed_annotation/freezed_annotation.dart';

part 'insurer.freezed.dart';

@freezed
abstract class Insurer with _$Insurer {
  const factory Insurer({
    required String id,
    required String tenantId,
    required String name,
    String? contactPhone,
    String? contactEmail,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Insurer;
}

