import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/ambient_glow.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import 'widgets/auth_scaffold.dart';

/// Welcome/onboarding screen with glassmorphism design.
/// 
/// Provides an introduction to the Repair On Call platform with
/// glass-styled cards and ambient glow effects.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      body: Stack(
        children: [
          // Background with ambient glow
          if (brightness == Brightness.dark) ...[
            AmbientGlow(
              radius: 320,
              color: DesignTokens.primaryRed.withValues(alpha: 0.2),
              top: -180,
              right: -140,
            ),
            AmbientGlow(
              radius: 360,
              color: const Color(0x331E88F5), // Blue/violet glow
              bottom: -220,
              left: -160,
            ),
          ],
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spaceL,
                  vertical: DesignTokens.spaceXL,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      GlassCard(
                        padding: const EdgeInsets.all(DesignTokens.spaceXL),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/Repair-On-Call-Logo.png',
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: DesignTokens.spaceM),
                            Text(
                              'Repair On Call',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spaceS),
                            Text(
                              'Claims Management Platform',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: DesignTokens.textSecondary(brightness),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spaceXL),
                      // Features
                      GlassCard(
                        padding: const EdgeInsets.all(DesignTokens.spaceL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Get Started',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spaceM),
                            _FeatureItem(
                              icon: Icons.assignment_outlined,
                              title: 'Manage Claims',
                              description: 'Track and process insurance claims efficiently',
                            ),
                            const SizedBox(height: DesignTokens.spaceM),
                            _FeatureItem(
                              icon: Icons.map_outlined,
                              title: 'Geographic View',
                              description: 'Visualize claims on an interactive map',
                            ),
                            const SizedBox(height: DesignTokens.spaceM),
                            _FeatureItem(
                              icon: Icons.insights_outlined,
                              title: 'Analytics & Reports',
                              description: 'Monitor performance with detailed insights',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spaceXL),
                      // Action buttons
                      GlassButton.primary(
                        onPressed: () => context.go('/login'),
                        child: const Text('Sign In'),
                      ),
                      const SizedBox(height: DesignTokens.spaceM),
                      GlassButton.outlined(
                        onPressed: () => context.go('/signup'),
                        child: const Text('Create Account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24,
          color: DesignTokens.primaryRed,
          semanticLabel: title,
        ),
        const SizedBox(width: DesignTokens.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: DesignTokens.spaceXS),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.textSecondary(brightness),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

