import 'dart:async';
import 'dart:js_util' as js_util;
import 'package:js/js.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';

@JS('rocPlaces.ensureLoaded')
external Object _rocEnsureLoaded(String apiKey);

@JS('rocPlaces.autocomplete')
external Object _rocAutocomplete(String query);

@JS('rocPlaces.placeDetails')
external Object _rocPlaceDetails(String placeId);

class PlacesWebService {
  PlacesWebService._();

  static Completer<void>? _loader;

  static Future<void> ensureLoaded(String apiKey) {
    if (!kIsWeb || apiKey.isEmpty) {
      return Future.value();
    }
    _loader ??= Completer<void>();
    if (!_loader!.isCompleted) {
      js_util.promiseToFuture<void>(_rocEnsureLoaded(apiKey)).then((_) {
        if (!_loader!.isCompleted) {
          _loader!.complete();
        }
      }).catchError((error) {
        if (!_loader!.isCompleted) {
          _loader!.completeError(error);
        }
      });
    }
    return _loader!.future;
  }

  static Future<List<Map<String, dynamic>>> autocomplete(String query) async {
    if (!kIsWeb || query.trim().isEmpty) {
      return const [];
    }
    await ensureLoaded(Env.googleMapsApiKey);
    try {
      final result = await js_util.promiseToFuture<Object?>(_rocAutocomplete(query));
      final dartified = js_util.dartify(result) as List<dynamic>? ?? const [];
      return dartified
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  static Future<Map<String, dynamic>?> placeDetails(String placeId) async {
    if (!kIsWeb || placeId.isEmpty) {
      return null;
    }
    await ensureLoaded(Env.googleMapsApiKey);
    try {
      final result = await js_util.promiseToFuture<Object?>(_rocPlaceDetails(placeId));
      if (result == null) return null;
      return Map<String, dynamic>.from(js_util.dartify(result) as Map);
    } catch (_) {
      return null;
    }
  }
}

