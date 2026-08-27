import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesAsyncFake implements SharedPreferencesAsync {
  final Map<String, Object> _values = {};

  @override
  Future<String?> getString(String key) async {
    final value = _values[key];
    return value is String ? value : null;
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = _values[key];
    return value is bool ? value : null;
  }

  @override
  Future<int?> getInt(String key) async {
    final value = _values[key];
    return value is int ? value : null;
  }

  @override
  Future<double?> getDouble(String key) async {
    final value = _values[key];
    return value is double ? value : null;
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    final value = _values[key];
    return value is List<String> ? value : null;
  }

  @override
  Future<Set<String>> getKeys({
    Set<String>? allowList,
  }) async {
    final keys = _values.keys.toSet();

    if (allowList == null) {
      return keys;
    }

    return keys.where(allowList.contains).toSet();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _values.containsKey(key);
  }

  @override
  Future<Map<String, Object?>> getAll({
    Set<String>? allowList,
  }) async {
    if (allowList == null) {
      return Map<String, Object?>.from(_values);
    }

    return {
      for (final entry in _values.entries)
        if (allowList.contains(entry.key)) entry.key: entry.value,
    };
  }

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> setBool(String key, bool value) async {
    _values[key] = value;
  }

  @override
  Future<void> setInt(String key, int value) async {
    _values[key] = value;
  }

  @override
  Future<void> setDouble(String key, double value) async {
    _values[key] = value;
  }

  @override
  Future<void> setStringList(
    String key,
    List<String> value,
  ) async {
    _values[key] = List<String>.from(value);
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> clear({
    Set<String>? allowList,
  }) async {
    if (allowList == null) {
      _values.clear();
      return;
    }

    _values.removeWhere((key, _) => allowList.contains(key));
  }
}