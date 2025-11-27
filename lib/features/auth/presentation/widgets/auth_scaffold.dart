import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const _AuthBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _LogoBadge(),
                    const SizedBox(height: 32),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Material(
                        color: theme.colorScheme.surface.withValues(alpha: 0.94),
                        elevation: 16,
                        borderRadius: BorderRadius.circular(28),
                        shadowColor: Colors.black.withValues(alpha: 0.4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 36,
                          ),
                          child: child,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111217),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/Repair-On-Call-Logo.png',
            height: 72,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            'Repair On Call',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF170A12),
            Color(0xFF0E1016),
            Color(0xFF08090C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: const [
          Positioned.fill(
            child: CustomPaint(
              painter: _DiagonalStripesPainter(),
            ),
          ),
          Positioned(
            top: -180,
            right: -140,
            child: _HaloGlow(radius: 320, color: Color(0x33D8232A)),
          ),
          Positioned(
            bottom: -220,
            left: -160,
            child: _HaloGlow(radius: 360, color: Color(0x331E88F5)),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalStripesPainter extends CustomPainter {
  const _DiagonalStripesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final redPaint = Paint()
      ..color = const Color(0x33D8232A)
      ..strokeWidth = 3;

    final neutralPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1.5;

    const spacing = 48.0;

    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), redPaint);
    }

    for (double x = -size.height / 2; x < size.width + size.height; x += spacing) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), neutralPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HaloGlow extends StatelessWidget {
  const _HaloGlow({
    required this.radius,
    required this.color,
  });

  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}


