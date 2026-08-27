import 'package:flutter/material.dart';

import '../../../core/routes/app_router.dart';
import '../../../shared/widgets/theme_selector.dart';
import '../../auth/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await AuthService.signOut();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to log out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ZYNCUP'),
        actions: [
          const ThemeSelector(),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hub_outlined,
                size: 56,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text('ZYNCUP', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                user == null
                    ? 'Authentication is ready.'
                    : 'Signed in as ${user.email ?? user.id}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(AppRoutes.login, (_) => false),
                icon: const Icon(Icons.shield_outlined),
                label: const Text('Auth state protected'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
