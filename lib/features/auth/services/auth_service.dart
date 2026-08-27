import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/supabase_service.dart';

class AuthService {
  AuthService._();

  static bool get isReady => SupabaseService.isInitialized;

  static Session? get currentSession {
    if (!isReady) return null;
    return SupabaseService.client.auth.currentSession;
  }

  static User? get currentUser => currentSession?.user;

  static Stream<AuthState> get authStateChanges {
    if (!isReady) return const Stream<AuthState>.empty();
    return SupabaseService.client.auth.onAuthStateChange;
  }

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) {
    _checkReady();
    return SupabaseService.client.auth.signUp(email: email, password: password);
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    _checkReady();
    return SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() {
    _checkReady();
    return SupabaseService.client.auth.signOut();
  }

  static void _checkReady() {
    if (!isReady) {
      throw const AuthException(
        'Supabase is not configured yet. Add SUPABASE_URL and '
        'SUPABASE_PUBLISHABLE_KEY as Dart defines to use authentication.',
      );
    }
  }
}
