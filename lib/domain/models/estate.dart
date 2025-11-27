import 'package:freezed_annotation/freezed_annotation.dart';

part 'estate.freezed.dart';

@freezed
abstract class Estate with _$Estate {
  const factory Estate({
    required String id,
    required String tenantId,
    required String name,
    String? suburb,
    String? city,
    String? province,
    String? postalCode,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Estate;

  const Estate._();
}

@freezed
abstract class EstateInput with _$EstateInput {
  const factory EstateInput({
    required String name,
    String? suburb,
    String? city,
    String? province,
    String? postalCode,
  }) = _EstateInput;

  const EstateInput._();
}

