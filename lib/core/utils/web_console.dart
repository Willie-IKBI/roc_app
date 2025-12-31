// Conditional export: web implementation on web, stub on non-web
export 'web_console_stub.dart' if (dart.library.html) 'web_console_web.dart';

