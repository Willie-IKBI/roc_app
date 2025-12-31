// Conditional export: web implementation on web, stub on non-web
export 'error_boundary_stub.dart' if (dart.library.html) 'error_boundary_web.dart';
