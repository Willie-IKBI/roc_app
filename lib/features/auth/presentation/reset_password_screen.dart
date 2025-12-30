import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_input.dart';
import '../controller/auth_controller.dart';
import 'widgets/auth_scaffold.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({
    super.key,
    this.refreshToken,
    this.email,
  });

  final String? refreshToken;
  final String? email;

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _hasTokens =>
      widget.refreshToken != null && widget.refreshToken!.isNotEmpty;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(passwordResetControllerProvider.notifier).submit(
          newPassword: _passwordController.text,
          refreshToken: widget.refreshToken,
        );
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(passwordResetControllerProvider);

    ref.listen(passwordResetControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Password updated. You can now sign in.'),
              ),
            );
          context.go('/login');
        },
        error: (error, _) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(_mapAuthError(error))),
            );
        },
      );
    });

    return AuthScaffold(
      child: !_hasTokens
          ? _TokenMissingState(email: widget.email)
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Set a new password',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter a strong password to secure your account.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: GlassInput.decoration(
                      context: context,
                      label: 'New password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: GlassInput.decoration(
                      context: context,
                      label: 'Confirm password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  GlassButton.primary(
                    onPressed: resetState.isLoading ? null : _handleSubmit,
                    child: resetState.isLoading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Update password'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Back to sign in'),
                  ),
                ],
              ),
            ),
    );
  }

  String _mapAuthError(Object error) {
    if (error is AuthException) {
      return error.message;
    }
    return error.toString();
  }
}

class _TokenMissingState extends StatelessWidget {
  const _TokenMissingState({this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          'Reset link expired or invalid',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Request a new password reset link and open it on this device.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        if (email != null) ...[
          const SizedBox(height: 16),
          Text(
            'We attempted to recover the request for $email.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        GlassButton.primary(
          onPressed: () => GoRouter.of(context).go('/forgot-password'),
          child: const Text('Request new link'),
        ),
      ],
    );
  }
}

