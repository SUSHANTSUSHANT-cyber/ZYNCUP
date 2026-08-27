import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/services/auth_service.dart';

class ZyncupApp extends StatefulWidget {
  const ZyncupApp({required this.themeController, super.key});

  final ThemeController themeController;

  @override
  State<ZyncupApp> createState() => _ZyncupAppState();
}

class _ZyncupAppState extends State<ZyncupApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  StreamSubscription<AuthState>? _authSubscription;
  var _isAuthenticated = AuthService.currentSession != null;

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
    if (_isAuthenticated == nextIsAuthenticated) return;

    setState(() => _isAuthenticated = nextIsAuthenticated);
    final targetRoute = nextIsAuthenticated ? AppRoutes.home : AppRoutes.login;
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
            theme: AppTheme.themeFor(widget.themeController.selectedTheme),
            initialRoute: _isAuthenticated ? AppRoutes.home : AppRoutes.login,
            onGenerateRoute: (settings) => AppRouter.onGenerateRoute(
              settings,
              isAuthenticated: _isAuthenticated,
            ),
          );
        },
      ),
    );
  }
}
