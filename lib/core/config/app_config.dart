class AppConfig {
  AppConfig._();

  static const supabaseUrl =
      String.fromEnvironment('SUPABASE_URL');

  static const supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static const zyncupWebBaseUrl =
      String.fromEnvironment('ZYNCUP_WEB_BASE_URL');

  static const zyncupProfilePath =
      String.fromEnvironment('ZYNCUP_PROFILE_PATH');

  static const zyncupAndroidAppUrl =
      String.fromEnvironment('ZYNCUP_ANDROID_APP_URL');

  static const zyncupIosAppUrl =
      String.fromEnvironment('ZYNCUP_IOS_APP_URL');

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty &&
      supabasePublishableKey.isNotEmpty;

  static bool get isWebConfigured =>
      zyncupWebBaseUrl.isNotEmpty &&
      zyncupProfilePath.isNotEmpty;

  static String profileUrl(String zyncupId) {
    return '$zyncupWebBaseUrl'
        '$zyncupProfilePath/${zyncupId.trim()}';
  }
}
