import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/result.dart';
import '../../../domain/models/service_provider.dart';
import '../../../data/repositories/service_provider_admin_repository_supabase.dart';

part 'service_providers_controller.g.dart';

@riverpod
class ServiceProvidersController extends _$ServiceProvidersController {
  @override
  Future<List<ServiceProvider>> build() async {
    return _load();
  }

  Future<List<ServiceProvider>> _load() async {
    final repository = ref.read(serviceProviderAdminRepositoryProvider);
    final response = await repository.fetchProviders();
    if (response.isErr) {
      throw response.error;
    }
    return response.data;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<Result<String>> create({
    required String companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? referenceNumber,
  }) async {
    final repository = ref.read(serviceProviderAdminRepositoryProvider);
    final result = await repository.createProvider(
      companyName: companyName,
      contactName: contactName,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      referenceNumberFormat: referenceNumber,
    );
    if (result.isOk) {
      await refresh();
    }
    return result;
  }

  Future<Result<void>> updateProvider({
    required String id,
    required String companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? referenceNumber,
  }) async {
    final repository = ref.read(serviceProviderAdminRepositoryProvider);
    final result = await repository.updateProvider(
      id: id,
      companyName: companyName,
      contactName: contactName,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      referenceNumberFormat: referenceNumber,
    );
    if (result.isOk) {
      await refresh();
    }
    return result;
  }

  Future<Result<void>> remove(String id) async {
    final repository = ref.read(serviceProviderAdminRepositoryProvider);
    final result = await repository.deleteProvider(id);
    if (result.isOk) {
      await refresh();
    }
    return result;
  }
}


