import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_input.dart';
import '../controller/auth_controller.dart';
import 'widgets/auth_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(signInControllerProvider.notifier).submit(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final signInState = ref.watch(signInControllerProvider);

    ref.listen(signInControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Signed in successfully')),
            );
          context.go('/dashboard');
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
              'Welcome back',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in with your ROC account to manage claims.',
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: GlassInput.decoration(
                context: context,
                label: 'Password',
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
                return null;
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => context.push('/forgot-password'),
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 8),
            GlassButton.primary(
              onPressed: signInState.isLoading ? null : _handleSubmit,
              child: signInState.isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Sign in'),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () => context.push('/signup'),
                  child: const Text('Create one'),
                ),
              ],
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

