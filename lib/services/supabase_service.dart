import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/app_config.dart';

class SupabaseService {
  SupabaseService._();

  static var _isInitialized = false;

  static bool get isConfigured => AppConfig.isSupabaseConfigured;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    if (!isConfigured) return;

    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabasePublishableKey,
    );
    _isInitialized = true;
  }

  static SupabaseClient get client {
    if (!_isInitialized) {
      throw StateError(
        'Supabase is not initialized. Supply SUPABASE_URL and '
        'SUPABASE_PUBLISHABLE_KEY as Dart defines.',
      );
    }
    return Supabase.instance.client;
  }
}
