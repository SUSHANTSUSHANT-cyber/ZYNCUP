import 'package:flutter/material.dart';

import '../../auth/services/auth_service.dart';
import '../../home/screens/home_page.dart';
import '../services/profile_service.dart';
import 'profile_onboarding_screen.dart';

class ProfileGate extends StatefulWidget {
  const ProfileGate({super.key});

  @override
  State<ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<ProfileGate> {
  late Future<ZyncupProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<ZyncupProfile?> _loadProfile() {
    final user = AuthService.currentUser;
    if (user == null) return Future.value(null);
    return ProfileService.getProfile(user.id);
  }

  void _retry() {
    setState(() => _profileFuture = _loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ZyncupProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _ProfileLoadingScreen();
        }

        if (snapshot.hasError) {
          return _ProfileLoadError(
            onRetry: _retry,
            onSignOut: () => AuthService.signOut(),
          );
        }

        final profile = snapshot.data;
        if (profile == null) {
          return _ProfileLoadError(
            message: 'Your profile could not be found yet. Please try again.',
            onRetry: _retry,
            onSignOut: () => AuthService.signOut(),
          );
        }

        if (!profile.onboardingCompleted) {
          return ProfileOnboardingScreen(
            profile: profile,
            onCompleted: _retry,
          );
        }

        return const HomePage();
      },
    );
  }
}

class _ProfileLoadingScreen extends StatelessWidget {
  const _ProfileLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ProfileLoadError extends StatelessWidget {
  const _ProfileLoadError({
    required this.onRetry,
    required this.onSignOut,
    this.message = 'We could not load your profile.',
  });

  final String message;
  final VoidCallback onRetry;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_search_outlined,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async => onSignOut(),
                  child: const Text('Log out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
