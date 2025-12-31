import '../models/reference_option.dart';
import '../../core/utils/result.dart';

/// Repository for read-only reference data (lookups, dropdowns, etc.)
/// All methods return lightweight ReferenceOption models for UI consumption.
abstract class ReferenceDataRepository {
  /// Fetch all insurers as reference options (id + name)
  /// Returns empty list if no insurers found (not an error).
  Future<Result<List<ReferenceOption>>> fetchInsurerOptions();

  /// Fetch all service providers as reference options (id + company_name)
  /// Returns empty list if no providers found (not an error).
  Future<Result<List<ReferenceOption>>> fetchServiceProviderOptions();

  /// Fetch all brands as reference options (id + name)
  /// Returns empty list if no brands found (not an error).
  Future<Result<List<ReferenceOption>>> fetchBrandOptions();

  /// Fetch all estates as reference options (id + formatted label)
  /// Returns empty list if no estates found (not an error).
  /// Note: Estate labels include suburb/city for disambiguation.
  Future<Result<List<ReferenceOption>>> fetchEstateOptions();
}

