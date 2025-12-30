import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';

class InactiveShell extends StatelessWidget {
  const InactiveShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: GlassCard(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Account inactive',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your profile has been deactivated. Contact an administrator to regain access.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  GlassButton.primary(
                    onPressed: () => GoRouter.of(context).go('/profile'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_outline),
                        SizedBox(width: 8),
                        Text('View profile'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

