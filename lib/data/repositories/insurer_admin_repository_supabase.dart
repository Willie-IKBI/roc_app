import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../domain/models/insurer.dart';
import '../../domain/repositories/insurer_admin_repository.dart';
import '../datasources/insurer_admin_remote_data_source.dart';
import '../datasources/supabase_insurer_admin_remote_data_source.dart';

final insurerAdminRepositoryProvider = Provider<InsurerAdminRepository>((ref) {
  final remote = ref.watch(insurerAdminRemoteDataSourceProvider);
  return InsurerAdminRepositorySupabase(remote);
});

class InsurerAdminRepositorySupabase implements InsurerAdminRepository {
  InsurerAdminRepositorySupabase(this._remote);

  final InsurerAdminRemoteDataSource _remote;

  @override
  Future<Result<List<Insurer>>> fetchInsurers() async {
    final response = await _remote.fetchInsurers();
    if (response.isErr) {
      return Result.err(response.error);
    }
    return Result.ok(response.data.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Result<void>> createInsurer({
    required String name,
    String? contactPhone,
    String? contactEmail,
  }) {
    return _remote.createInsurer(
      name: name,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
    );
  }

  @override
  Future<Result<void>> updateInsurer({
    required String id,
    required String name,
    String? contactPhone,
    String? contactEmail,
  }) {
    return _remote.updateInsurer(
      id: id,
      name: name,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
    );
  }

  @override
  Future<Result<void>> deleteInsurer(String id) {
    return _remote.deleteInsurer(id);
  }
}

