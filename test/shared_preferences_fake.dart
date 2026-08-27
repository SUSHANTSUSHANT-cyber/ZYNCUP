import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesAsyncFake extends SharedPreferencesAsync {
  final Map<String, Object> _values = {};

  @override
  Future<String?> getString(
    String key,
    SharedPreferencesOptions? options,
  ) async {
    return _values[key] as String?;
  }

  @override
  Future<void> setString(
    String key,
    String value,
    SharedPreferencesOptions? options,
  ) async {
    _values[key] = value;
  }
}
