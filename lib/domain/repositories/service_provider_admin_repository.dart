import '../../core/utils/result.dart';
import '../models/service_provider.dart';

abstract class ServiceProviderAdminRepository {
  Future<Result<List<ServiceProvider>>> fetchProviders();

  Future<Result<String>> createProvider({
    required String companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? referenceNumberFormat,
  });

  Future<Result<void>> updateProvider({
    required String id,
    required String companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? referenceNumberFormat,
  });

  Future<Result<void>> deleteProvider(String id);
}


