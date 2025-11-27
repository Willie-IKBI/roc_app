import 'package:flutter/material.dart';

class UnauthShell extends StatelessWidget {
  const UnauthShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

