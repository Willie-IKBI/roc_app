/// Test helpers and mocks for widget tests
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../lib/core/theme/roc_color_scheme.dart';

/// Creates a test app with ProviderScope and theme
Widget createTestApp({required Widget child}) {
  return ProviderScope(
    child: MaterialApp(
      theme: rocTheme,
      home: Scaffold(body: child),
    ),
  );
}

