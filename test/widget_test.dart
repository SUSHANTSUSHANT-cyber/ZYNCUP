import 'package:flutter_test/flutter_test.dart';
import 'package:zyncup/app.dart';
import 'package:zyncup/core/theme/theme_controller.dart';

import 'shared_preferences_fake.dart';

void main() {
  testWidgets('redirects unauthenticated users to login', (tester) async {
    final themeController = ThemeController(
      preferences: SharedPreferencesAsyncFake(),
    );

    await tester.pumpWidget(ZyncupApp(themeController: themeController));

    expect(find.text('ZYNCUP'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('switches between all selectable themes', (tester) async {
    final themeController = ThemeController(
      preferences: SharedPreferencesAsyncFake(),
    );

    await tester.pumpWidget(ZyncupApp(themeController: themeController));

    for (final theme in ZyncupThemeOption.values) {
      await themeController.setTheme(theme);
      await tester.pump();

      expect(themeController.selectedTheme, theme);
    }
  });
}
