import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/env.dart';
import 'core/routing/app_router.dart';
import 'core/theme/theme_mode_provider.dart';
import 'core/theme/theme_preference_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate environment variables before initializing Supabase
  Env.validate();

  final supabaseUrl = Env.supabaseUrl;
  final supabaseAnonKey = Env.supabaseAnonKey;

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    debug: true,
    authOptions: const FlutterAuthClientOptions(
      // Enable automatic token refresh
      autoRefreshToken: true,
    ),
  );

  runApp(const ProviderScope(child: RocApp()));
}

class RocApp extends ConsumerWidget {
  const RocApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themePreference = ref.watch(themePreferenceProvider);
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);

    return MaterialApp.router(
      title: 'Repair on Call',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themePreference.when(
        data: (mode) => mode,
        loading: () => ThemeMode.dark,
        error: (_, __) => ThemeMode.dark,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
