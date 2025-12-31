// Conditional export: web implementation on web, stub on non-web
export 'performance_utils_stub.dart' if (dart.library.html) 'performance_utils_web.dart';
