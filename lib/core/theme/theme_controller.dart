import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ZyncupThemeOption {
  light('light', 'Light', Icons.wb_sunny_outlined),
  dark('dark', 'Dark', Icons.dark_mode_outlined),
  warm('warm', 'Warm', Icons.local_fire_department_outlined);

  const ZyncupThemeOption(this.storageValue, this.label, this.icon);

  final String storageValue;
  final String label;
  final IconData icon;

  static ZyncupThemeOption fromStorageValue(String? value) {
    return values.firstWhere(
      (theme) => theme.storageValue == value,
      orElse: () => ZyncupThemeOption.light,
    );
  }
}

class ThemeController extends ChangeNotifier {
  ThemeController({
    required SharedPreferencesAsync preferences,
    ZyncupThemeOption initialTheme = ZyncupThemeOption.light,
  }) : _preferences = preferences,
       _selectedTheme = initialTheme;

  static const _preferenceKey = 'zyncup_theme';

  final SharedPreferencesAsync _preferences;
  ZyncupThemeOption _selectedTheme;

  static Future<ThemeController> load() async {
    final preferences = SharedPreferencesAsync();
    final savedTheme = await preferences.getString(_preferenceKey);

    return ThemeController(
      preferences: preferences,
      initialTheme: ZyncupThemeOption.fromStorageValue(savedTheme),
    );
  }

  ZyncupThemeOption get selectedTheme => _selectedTheme;

  Future<void> setTheme(ZyncupThemeOption theme) async {
    if (_selectedTheme == theme) return;

    _selectedTheme = theme;
    notifyListeners();
    await _preferences.setString(_preferenceKey, theme.storageValue);
  }
}

class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    required ThemeController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope is missing from the widget tree.');
    return scope!.notifier!;
  }
}
