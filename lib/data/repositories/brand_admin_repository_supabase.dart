import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../domain/models/brand.dart';
import '../../domain/repositories/brand_admin_repository.dart';
import '../datasources/brand_admin_remote_data_source.dart';
import '../datasources/supabase_brand_admin_remote_data_source.dart';

final brandAdminRepositoryProvider = Provider<BrandAdminRepository>((ref) {
  final remote = ref.watch(brandAdminRemoteDataSourceProvider);
  return BrandAdminRepositorySupabase(remote);
});

class BrandAdminRepositorySupabase implements BrandAdminRepository {
  BrandAdminRepositorySupabase(this._remote);

  final BrandAdminRemoteDataSource _remote;

  @override
  Future<Result<List<Brand>>> fetchBrands() async {
    final response = await _remote.fetchBrands();
    if (response.isErr) {
      return Result.err(response.error);
    }
    return Result.ok(
      response.data.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Result<String>> createBrand({required String name}) {
    return _remote.createBrand(name: name);
  }

  @override
  Future<Result<void>> updateBrand({required String id, required String name}) {
    return _remote.updateBrand(id: id, name: name);
  }

  @override
  Future<Result<void>> deleteBrand(String id) {
    return _remote.deleteBrand(id);
  }
}
