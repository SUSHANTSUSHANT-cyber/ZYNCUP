import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/services/auth_service.dart';
import 'features/home/screens/home_page.dart';
import 'features/profile/screens/profile_onboarding_screen.dart';
import 'features/profile/services/profile_service.dart';

class ZyncupApp extends StatefulWidget {
  const ZyncupApp({
    required this.themeController,
    super.key,
  });

  final ThemeController themeController;

  @override
  State<ZyncupApp> createState() => _ZyncupAppState();
}

class _ZyncupAppState extends State<ZyncupApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  StreamSubscription<AuthState>? _authSubscription;

  bool _isAuthenticated = AuthService.currentSession != null;

  @override
  void initState() {
    super.initState();

    _authSubscription = AuthService.authStateChanges.listen(
      _handleAuthChange,
      onError: (_, _) {},
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _handleAuthChange(AuthState state) {
    final nextIsAuthenticated = state.session != null;

    if (_isAuthenticated == nextIsAuthenticated) {
      return;
    }

    setState(() {
      _isAuthenticated = nextIsAuthenticated;
    });

    final targetRoute =
        nextIsAuthenticated ? AppRoutes.home : AppRoutes.login;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        targetRoute,
        (_) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: widget.themeController,
      child: AnimatedBuilder(
        animation: widget.themeController,
        builder: (context, _) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            title: 'ZYNCUP',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.themeFor(
              widget.themeController.selectedTheme,
            ),

            initialRoute:
                _isAuthenticated ? AppRoutes.home : AppRoutes.login,

            onGenerateRoute: (settings) {
              if (settings.name == AppRoutes.home) {
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => const _ProfileGate(),
                );
              }

              return AppRouter.onGenerateRoute(
                settings,
                isAuthenticated: _isAuthenticated,
              );
            },
          );
        },
      ),
    );
  }
}

class _ProfileGate extends StatefulWidget {
  const _ProfileGate();

  @override
  State<_ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<_ProfileGate> {
  late Future<ZyncupProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final user = AuthService.currentUser;

    if (user == null) {
      _profileFuture = Future.value(null);
      return;
    }

    _profileFuture = ProfileService.getProfile(user.id);
  }

  void _onProfileCompleted() {
    setState(() {
      _loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ZyncupProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = AuthService.currentUser;
        final profile = snapshot.data;

        if (user == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load your profile.\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        if (profile == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Your ZYNCUP profile could not be found.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (!profile.onboardingCompleted) {
          return ProfileOnboardingScreen(
            profile: profile,
            onCompleted: _onProfileCompleted,
          );
        }

        return const HomePage();
      },
    );
  }
}