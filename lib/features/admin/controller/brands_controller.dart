import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/result.dart';
import '../../../domain/models/brand.dart';
import '../../../data/repositories/brand_admin_repository_supabase.dart';

part 'brands_controller.g.dart';

@riverpod
class BrandsController extends _$BrandsController {
  @override
  Future<List<Brand>> build() async {
    return _load();
  }

  Future<List<Brand>> _load() async {
    final repository = ref.read(brandAdminRepositoryProvider);
    final response = await repository.fetchBrands();
    if (response.isErr) {
      throw response.error;
    }
    return response.data;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<Result<String>> create(String name) async {
    final repository = ref.read(brandAdminRepositoryProvider);
    final result = await repository.createBrand(name: name);
    if (result.isOk) {
      await refresh();
    }
    return result;
  }

  Future<Result<void>> updateBrand({
    required String id,
    required String name,
  }) async {
    final repository = ref.read(brandAdminRepositoryProvider);
    final result = await repository.updateBrand(id: id, name: name);
    if (result.isOk) {
      await refresh();
    }
    return result;
  }

  Future<Result<void>> deleteBrand(String id) async {
    final repository = ref.read(brandAdminRepositoryProvider);
    final result = await repository.deleteBrand(id);
    if (result.isOk) {
      await refresh();
    }
    return result;
  }
}
