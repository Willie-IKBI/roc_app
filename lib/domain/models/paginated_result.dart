import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_result.freezed.dart';

/// Generic paginated result wrapper
/// 
/// [T] - Item type
/// [items] - Current page items
/// [nextCursor] - Cursor for next page (null if no more data)
/// [hasMore] - Whether more data is available
@freezed
abstract class PaginatedResult<T> with _$PaginatedResult<T> {
  const factory PaginatedResult({
    required List<T> items,
    String? nextCursor,
    @Default(false) bool hasMore,
  }) = _PaginatedResult<T>;
}

