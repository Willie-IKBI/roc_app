// Conditional export: web implementation on web, stub on non-web
export 'interactive_map_widget_stub.dart' if (dart.library.html) 'interactive_map_widget_web.dart';
