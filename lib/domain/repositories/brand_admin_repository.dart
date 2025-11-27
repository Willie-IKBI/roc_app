import '../../core/utils/result.dart';
import '../models/brand.dart';

abstract class BrandAdminRepository {
  Future<Result<List<Brand>>> fetchBrands();

  Future<Result<String>> createBrand({required String name});

  Future<Result<void>> updateBrand({
    required String id,
    required String name,
  });

  Future<Result<void>> deleteBrand(String id);
}


