// Conditional export: web implementation on web, stub on non-web
export 'env_stub.dart' if (dart.library.html) 'env_web.dart';
