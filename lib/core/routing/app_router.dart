import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/claims/presentation/capture_claim_screen.dart';
import '../../features/claims/presentation/claim_detail_screen.dart';
import '../../features/claims/presentation/claims_queue_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/reporting/presentation/reporting_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../../features/shell/presentation/inactive_shell.dart';
import '../../features/shell/presentation/unauth_shell.dart';
import '../../features/admin/presentation/admin_brands_screen.dart';
import '../../features/admin/presentation/admin_insurers_screen.dart';
import '../../features/admin/presentation/admin_settings_screen.dart';
import '../../features/admin/presentation/admin_service_providers_screen.dart';
import '../../features/admin/presentation/admin_users_screen.dart';
import '../providers/current_user_provider.dart';
import '../../data/clients/supabase_client.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final auth = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(supabaseClientProvider).auth.onAuthStateChange,
    ),
    redirect: (context, state) {
      // Wait for auth to finish loading before making redirect decisions
      if (auth.isLoading) {
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

      if (!isAuthenticated && !(loggingIn || isResetFlow)) {
        return '/login';
      }
      if (isAuthenticated && loggingIn) {
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
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
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
            builder: (context, state) => const ClaimsQueueScreen(),
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
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

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
