import '../../core/utils/result.dart';
import '../models/insurer.dart';

abstract class InsurerAdminRepository {
  Future<Result<List<Insurer>>> fetchInsurers();

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

