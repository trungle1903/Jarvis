import 'package:flutter/material.dart';
import 'package:jarvis/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/pages/auth/signIn.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.signIn,
          (route) => false,
        );
      });
      return const Text('Redirecting...');
    }

    return child;
  }
}
