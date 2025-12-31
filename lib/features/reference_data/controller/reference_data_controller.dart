import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/reference_option.dart';
import '../../../data/repositories/reference_data_repository_supabase.dart';

part 'reference_data_controller.g.dart';

/// Provider for insurer options (id + name)
/// Returns AsyncValue&lt;List&lt;ReferenceOption&gt;&gt; for UI consumption.
/// Errors are surfaced as AsyncError (no silent failures).
@riverpod
Future<List<ReferenceOption>> insurerOptions(Ref ref) async {
  final repository = ref.watch(referenceDataRepositoryProvider);
  final result = await repository.fetchInsurerOptions();

  if (result.isErr) {
    // Surface error to UI - AsyncValue will be AsyncError
    throw result.error;
  }

  return result.data;
}

/// Provider for service provider options (id + company_name)
@riverpod
Future<List<ReferenceOption>> serviceProviderOptions(Ref ref) async {
  final repository = ref.watch(referenceDataRepositoryProvider);
  final result = await repository.fetchServiceProviderOptions();

  if (result.isErr) {
    throw result.error;
  }

  return result.data;
}

/// Provider for brand options (id + name)
@riverpod
Future<List<ReferenceOption>> brandOptions(Ref ref) async {
  final repository = ref.watch(referenceDataRepositoryProvider);
  final result = await repository.fetchBrandOptions();

  if (result.isErr) {
    throw result.error;
  }

  return result.data;
}

/// Provider for estate options (id + formatted label)
@riverpod
Future<List<ReferenceOption>> estateOptions(Ref ref) async {
  final repository = ref.watch(referenceDataRepositoryProvider);
  final result = await repository.fetchEstateOptions();

  if (result.isErr) {
    throw result.error;
  }

  return result.data;
}

