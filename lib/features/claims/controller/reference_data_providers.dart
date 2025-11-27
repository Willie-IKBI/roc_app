import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/current_user_provider.dart';
import '../../../data/clients/supabase_client.dart';
import '../../../data/repositories/estate_repository.dart';

@immutable
class EstateOption {
  const EstateOption({
    required this.id,
    required this.name,
    this.suburb,
    this.city,
    this.province,
    this.postalCode,
  });

  final String id;
  final String name;
  final String? suburb;
  final String? city;
  final String? province;
  final String? postalCode;

  String get label {
    final parts = <String>[
      name,
      if (suburb != null && suburb!.trim().isNotEmpty) suburb!.trim(),
      if (city != null && city!.trim().isNotEmpty) city!.trim(),
    ];
    return parts.where((p) => p.trim().isNotEmpty).join(', ');
  }
}

@immutable
class ReferenceOption {
  const ReferenceOption({required this.id, required this.label});

  final String id;
  final String label;
}

final insurersOptionsProvider =
    FutureProvider.autoDispose<List<ReferenceOption>>((ref) async {
      final client = ref.read(supabaseClientProvider);
      final rows =
          await client.from('insurers').select('id, name').order('name')
              as List<dynamic>;

      return rows
          .cast<Map<String, dynamic>>()
          .map(
            (row) => ReferenceOption(
              id: row['id'] as String,
              label: row['name'] as String,
            ),
          )
          .toList(growable: false);
    });

@immutable
class BrandOption {
  const BrandOption({required this.id, required this.name});

  final String id;
  final String name;
}

final brandsOptionsProvider = FutureProvider.autoDispose<List<BrandOption>>((
  ref,
) async {
  final client = ref.read(supabaseClientProvider);
  final rows =
      await client.from('brands').select('id, name').order('name')
          as List<dynamic>;

  return rows
      .cast<Map<String, dynamic>>()
      .map(
        (row) =>
            BrandOption(id: row['id'] as String, name: row['name'] as String),
      )
      .toList(growable: false);
});

final estatesOptionsProvider = FutureProvider.autoDispose<List<EstateOption>>((
  ref,
) async {
  final profile = ref.watch(currentUserProvider).asData?.value;
  if (profile == null) return const [];
  final repository = ref.watch(estateRepositoryProvider);
  final result = await repository.fetchEstates(tenantId: profile.tenantId);
  if (result.isErr) throw result.error;
  return result.data
      .map(
        (estate) => EstateOption(
          id: estate.id,
          name: estate.name,
          suburb: estate.suburb,
          city: estate.city,
          province: estate.province,
          postalCode: estate.postalCode,
        ),
      )
      .toList(growable: false);
});
