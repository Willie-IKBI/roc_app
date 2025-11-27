import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../domain/models/service_provider.dart';
import '../../domain/repositories/service_provider_admin_repository.dart';
import '../datasources/service_provider_admin_remote_data_source.dart';
import '../datasources/supabase_service_provider_admin_remote_data_source.dart';

final serviceProviderAdminRepositoryProvider =
    Provider<ServiceProviderAdminRepository>((ref) {
  final remote =
      ref.watch(serviceProviderAdminRemoteDataSourceProvider);
  return ServiceProviderAdminRepositorySupabase(remote);
});

class ServiceProviderAdminRepositorySupabase
    implements ServiceProviderAdminRepository {
  ServiceProviderAdminRepositorySupabase(this._remote);

  final ServiceProviderAdminRemoteDataSource _remote;

  @override
  Future<Result<List<ServiceProvider>>> fetchProviders() async {
    final response = await _remote.fetchProviders();
    if (response.isErr) {
      return Result.err(response.error);
    }
    return Result.ok(
      response.data.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Result<String>> createProvider({
    required String companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? referenceNumberFormat,
  }) {
    return _remote.createProvider(
      companyName: companyName,
      contactName: contactName,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      referenceNumberFormat: referenceNumberFormat,
    );
  }

  @override
  Future<Result<void>> updateProvider({
    required String id,
    required String companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? referenceNumberFormat,
  }) {
    return _remote.updateProvider(
      id: id,
      companyName: companyName,
      contactName: contactName,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      referenceNumberFormat: referenceNumberFormat,
    );
  }

  @override
  Future<Result<void>> deleteProvider(String id) {
    return _remote.deleteProvider(id);
  }
}


