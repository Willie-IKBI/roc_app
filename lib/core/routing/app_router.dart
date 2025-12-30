import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/claims/presentation/capture_claim_screen.dart';
import '../../features/claims/presentation/claim_detail_screen.dart';
import '../../features/claims/presentation/claims_queue_screen.dart';
import '../../features/claims/presentation/map_view_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/reporting/presentation/reporting_screen.dart';
import '../../features/scheduling/presentation/scheduling_screen.dart';
import '../../features/assignments/presentation/assignment_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../../features/shell/presentation/inactive_shell.dart';
import '../../features/shell/presentation/unauth_shell.dart';
import '../../features/admin/presentation/admin_brands_screen.dart';
import '../../features/admin/presentation/admin_insurers_screen.dart';
import '../../features/admin/presentation/admin_settings_screen.dart';
import '../../features/admin/presentation/admin_service_providers_screen.dart';
import '../../features/admin/presentation/admin_users_screen.dart';
import '../../domain/value_objects/claim_enums.dart';
import '../logging/logger.dart';
import '../providers/current_user_provider.dart';
import '../strings/app_strings.dart';
import '../../data/clients/supabase_client.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final auth = ref.watch(currentUserProvider);
  final client = ref.watch(supabaseClientProvider);
  final sessionExpirationReason = ref.watch(sessionExpirationReasonProvider.notifier);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(supabaseClientProvider).auth.onAuthStateChange,
      onAuthStateChange: (authState) {
        // Log auth state changes for debugging
        AppLogger.debug(
          'Auth state change: ${authState.event.name}',
          name: 'AppRouter',
        );
        
        // Handle token expiration vs manual logout
        if (authState.event == AuthChangeEvent.signedOut) {
          final hadSession = authState.session != null;
          // If we had a session but now we're signed out, it's likely token expiration
          // Manual logout would have cleared the session first
          sessionExpirationReason.setExpired(hadSession);
          AppLogger.debug(
            'User signed out. Session expired: $hadSession',
            name: 'AppRouter',
          );
        } else if (authState.event == AuthChangeEvent.tokenRefreshed) {
          // Token was refreshed successfully, clear expiration flag
          sessionExpirationReason.setExpired(false);
          AppLogger.debug(
            'Token refreshed successfully',
            name: 'AppRouter',
          );
        } else if (authState.event == AuthChangeEvent.signedIn) {
          AppLogger.debug(
            'User signed in: ${authState.session?.user.id}',
            name: 'AppRouter',
          );
        }
      },
    ),
    redirect: (context, state) async {
      try {
        // Wait for auth to finish loading before making redirect decisions
        if (auth.isLoading) {
          return null;
        }

        // Handle error state from auth provider
        if (auth.hasError) {
          // If auth provider has an error, log it and redirect to login
          // This prevents white screen crashes
          AppLogger.error(
            'Auth provider error: ${auth.error}',
            name: 'AppRouter',
            error: auth.error,
          );
          // Don't redirect if already on login/signup/reset pages
          final isAuthPage = state.matchedLocation == '/login' ||
              state.matchedLocation == '/signup' ||
              state.matchedLocation.startsWith('/forgot-password') ||
              state.matchedLocation.startsWith('/reset-password');
          if (!isAuthPage) {
            return '/login';
          }
          return null;
        }

        final user = auth.asData?.value;
        final isAuthenticated = user != null;
        final loggingIn =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup';
        final isResetFlow =
            state.matchedLocation.startsWith('/forgot-password') ||
            state.matchedLocation.startsWith('/reset-password');
        final wantsAdmin = state.matchedLocation.startsWith('/admin');

        // If not authenticated, try to refresh session before redirecting
        if (!isAuthenticated && !(loggingIn || isResetFlow)) {
          try {
            final session = client.auth.currentSession;
            if (session != null) {
              // Session exists but user is null - try to refresh
              final refreshed = await refreshSessionWithRetry(client)
                  .timeout(const Duration(seconds: 5), onTimeout: () {
                AppLogger.warn(
                  'Session refresh timed out',
                  name: 'AppRouter',
                );
                return false;
              });
              if (refreshed) {
                // Refresh succeeded, wait for auth state to update
                return null;
              }
            }
          } catch (e) {
            // If session refresh fails, log and continue to login
            AppLogger.debug(
              'Session refresh error: $e',
              name: 'AppRouter',
              error: e,
            );
          }
          
          // Show notification if session expired (not manual logout)
          try {
            final wasExpired = ref.read(sessionExpirationReasonProvider);
            if (wasExpired && context.mounted) {
              // Delay to allow navigation to complete first
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.sessionExpired),
                      duration: Duration(seconds: 4),
                    ),
                  );
                }
              });
            }
          } catch (e) {
            // Ignore errors in showing notification
            AppLogger.debug(
              'Error showing session expired notification: $e',
              name: 'AppRouter',
              error: e,
            );
          }
          
          return '/login';
        }
        if (isAuthenticated && loggingIn) {
          // Log successful authentication for debugging
          AppLogger.debug(
            'User authenticated, redirecting to dashboard',
            name: 'AppRouter',
          );
          return '/dashboard';
        }
        if (wantsAdmin && user?.role != 'admin') {
          return '/dashboard';
        }
        if (user != null && user.isActive == false) {
          if (!state.matchedLocation.startsWith('/profile')) {
            return '/profile';
          }
        }
        return null;
      } catch (e, stackTrace) {
        // Catch any unexpected errors in redirect logic
        AppLogger.error(
          'Redirect error: $e',
          name: 'AppRouter',
          error: e,
          stackTrace: stackTrace,
        );
        // Return null to allow navigation to proceed, or redirect to login as safe fallback
        final isAuthPage = state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup' ||
            state.matchedLocation.startsWith('/forgot-password') ||
            state.matchedLocation.startsWith('/reset-password');
        return isAuthPage ? null : '/login';
      }
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          // Show loading state while auth is loading
          if (auth.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // Handle error state
          if (auth.hasError) {
            AppLogger.error(
              'Auth error in ShellRoute: ${auth.error}',
              name: 'AppRouter',
              error: auth.error,
            );
            return UnauthShell(child: child);
          }
          
          final user = auth.asData?.value;
          if (user == null) {
            return UnauthShell(child: child);
          }
          if (!user.isActive) {
            return const InactiveShell();
          }
          return AppShell(role: user.role, child: child);
        },
        routes: [
          GoRoute(
            name: 'login',
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            name: 'signup',
            path: '/signup',
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            name: 'forgot-password',
            path: '/forgot-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            name: 'reset-password',
            path: '/reset-password',
            builder: (context, state) => ResetPasswordScreen(
              refreshToken: _readAuthParam(
                state.uri,
                candidates: const ['refresh_token', 'token', 'access_token'],
              ),
              email: _readAuthParam(state.uri, candidates: const ['email']),
            ),
          ),
          GoRoute(
            name: 'dashboard',
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
      GoRoute(
        name: 'claims-queue',
        path: '/claims',
        builder: (context, state) {
          final statusParam = state.uri.queryParameters['status'];
          ClaimStatus? initialStatusFilter;
          if (statusParam != null) {
            try {
              initialStatusFilter = ClaimStatus.fromJson(statusParam);
            } catch (_) {
              // Invalid status parameter, ignore it
              initialStatusFilter = null;
            }
          }
          return ClaimsQueueScreen(initialStatusFilter: initialStatusFilter);
        },
      ),
      GoRoute(
        name: 'claims-map',
        path: '/claims/map',
        builder: (context, state) => const MapViewScreen(),
      ),
          GoRoute(
            name: 'claim-create',
            path: '/claims/new',
            builder: (context, state) => const CaptureClaimScreen(),
          ),
          GoRoute(
            name: 'claim-detail',
            path: '/claims/:id',
            builder: (context, state) =>
                ClaimDetailScreen(claimId: state.pathParameters['id']!),
          ),
          GoRoute(
            name: 'scheduling',
            path: '/scheduling',
            builder: (context, state) => const SchedulingScreen(),
          ),
          GoRoute(
            name: 'assignments',
            path: '/assignments',
            builder: (context, state) => const AssignmentScreen(),
          ),
          GoRoute(
            name: 'profile',
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            name: 'reports',
            path: '/reports',
            builder: (context, state) => const ReportingScreen(),
          ),
          GoRoute(
            name: 'admin-users',
            path: '/admin/users',
            builder: (context, state) => const AdminUsersScreen(),
          ),
          GoRoute(
            name: 'admin-insurers',
            path: '/admin/insurers',
            builder: (context, state) => const AdminInsurersScreen(),
          ),
          GoRoute(
            name: 'admin-brands',
            path: '/admin/brands',
            builder: (context, state) => const AdminBrandsScreen(),
          ),
          GoRoute(
            name: 'admin-settings',
            path: '/admin/settings',
            builder: (context, state) => const AdminSettingsScreen(),
          ),
          GoRoute(
            name: 'admin-service-providers',
            path: '/admin/service-providers',
            builder: (context, state) => const AdminServiceProvidersScreen(),
          ),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(
    Stream<AuthState> stream, {
    void Function(AuthState)? onAuthStateChange,
  }) {
    _subscription = stream.asBroadcastStream().listen((authState) {
      onAuthStateChange?.call(authState);
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

String? _readAuthParam(Uri uri, {required List<String> candidates}) {
  for (final key in candidates) {
    final queryValue = uri.queryParameters[key];
    if (queryValue != null && queryValue.isNotEmpty) {
      return queryValue;
    }
  }

  if (uri.fragment.isEmpty) {
    return null;
  }

  try {
    final fragmentParams = Uri.splitQueryString(uri.fragment);
    for (final key in candidates) {
      final fragmentValue = fragmentParams[key];
      if (fragmentValue != null && fragmentValue.isNotEmpty) {
        return fragmentValue;
      }
    }
  } on FormatException {
    // ignore malformed fragments
  }

  return null;
}
