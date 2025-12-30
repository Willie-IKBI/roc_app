import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_input.dart';
import '../controller/auth_controller.dart';
import 'widgets/auth_scaffold.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(signUpControllerProvider.notifier).submit(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpControllerProvider);

    ref.listen(signUpControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'Account created. Check your email to verify before signing in.',
                ),
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create your account',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Verify your email after signing up to access the ROC console.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: GlassInput.decoration(
                context: context,
                label: 'Full name (optional)',
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: GlassInput.decoration(
                context: context,
                label: 'Work email',
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
              onPressed: signUpState.isLoading ? null : _handleSubmit,
              child: signUpState.isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create account'),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                Text(
                  'Already have access?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Sign in instead'),
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

