import 'package:flutter/material.dart';

import '../../../shared/widgets/theme_selector.dart';
import '../../auth/services/auth_service.dart';
import '../../connections/screens/my_zyncup_code_screen.dart';
import '../../connections/screens/scan_zyncup_screen.dart';
import '../../connections/screens/connections_screen.dart';
import '../../profile/screens/edit_profile_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../profile/services/profile_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.profile,
    super.key,
  });

  final ZyncupProfile profile;

  Future<void> _signOut(BuildContext context) async {
    try {
      await AuthService.signOut();
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to log out. Please try again.'),
        ),
      );
    }
  }

  Future<void> _openProfile(BuildContext context) async {
    try {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ProfileScreen(
            profile: profile,
            onEdit: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => EditProfileScreen(
                    profile: profile,
                    onSaved: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open your profile. Please try again.',
          ),
        ),
      );
    }
  }

  Future<void> _openZyncupCode(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MyZyncupCodeScreen(
          profile: profile,
        ),
      ),
    );
  }

  Future<void> _scanZyncupCode(BuildContext context) async {
    final scannedId = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const ScanZyncupScreen(),
      ),
    );

    if (!context.mounted || scannedId == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scanned ZYNCUP ID: $scannedId'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 12),

            Text(
              'Hey, ${profile.displayName}',
              style: theme.textTheme.headlineMedium,
            ),

            const SizedBox(height: 8),

            Text(
              'Someone interesting might just be one scan away.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 28),

            _MainActionCard(
              icon: Icons.qr_code_2,
              title: 'My ZYNCUP Code',
              subtitle:
                  'Your personal code for starting a connection.',
              buttonLabel: 'Show my code',
              onPressed: () => _openZyncupCode(context),
            ),

            const SizedBox(height: 16),

            Text(
              'Explore',
              style: theme.textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.qr_code_scanner,
                    title: 'Scan',
                    subtitle: 'Discover someone',
                    onTap: () => _scanZyncupCode(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.people_outline,
                    title: 'Connections',
                    subtitle: 'Your people',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ConnectionsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _WideActionCard(
              icon: Icons.person_outline,
              title: 'My Profile',
              subtitle:
                  'View and manage your ZYNCUP identity.',
              onTap: () => _openProfile(context),
            ),

            const SizedBox(height: 32),

            Center(
              child: Text(
                'More Than Friends',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _MainActionCard extends StatelessWidget {
  const _MainActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.arrow_forward),
              label: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 30,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideActionCard extends StatelessWidget {
  const _WideActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Icon(
          icon,
          size: 30,
          color: theme.colorScheme.primary,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}




