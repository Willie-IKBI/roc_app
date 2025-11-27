import '../../core/utils/result.dart';
import '../models/brand_row.dart';

abstract class BrandAdminRemoteDataSource {
  Future<Result<List<BrandRow>>> fetchBrands();

  Future<Result<String>> createBrand({required String name});

  Future<Result<void>> updateBrand({required String id, required String name});

  Future<Result<void>> deleteBrand(String id);
}
