import '../../core/utils/result.dart';
import '../models/insurer_row.dart';

abstract class InsurerAdminRemoteDataSource {
  Future<Result<List<InsurerRow>>> fetchInsurers();

  Future<Result<void>> createInsurer({
    required String name,
    String? contactPhone,
    String? contactEmail,
  });

  Future<Result<void>> updateInsurer({
    required String id,
    required String name,
    String? contactPhone,
    String? contactEmail,
  });

  Future<Result<void>> deleteInsurer(String id);
}

