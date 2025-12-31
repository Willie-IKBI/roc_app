// Conditional export: web implementation on web, stub on non-web
export 'logger_stub.dart' if (dart.library.html) 'logger_web.dart';
