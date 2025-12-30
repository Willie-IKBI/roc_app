import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_input.dart';
import '../controller/auth_controller.dart';
import 'widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(passwordResetRequestControllerProvider.notifier).submit(
          email: _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(passwordResetRequestControllerProvider);

    ref.listen(passwordResetRequestControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Password reset link sent. Check your inbox.'),
              ),
            );
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Reset your password',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the email associated with your account and we\'ll send a reset link.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              decoration: GlassInput.decoration(
                context: context,
                label: 'Email address',
                prefixIcon: const Icon(Icons.mail_outline),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email';
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
                  : const Text('Send reset link'),
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

