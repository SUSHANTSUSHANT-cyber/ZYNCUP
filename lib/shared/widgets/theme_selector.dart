import 'package:flutter/material.dart';

import '../../core/theme/theme_controller.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeScope.of(context);
    final selectedTheme = controller.selectedTheme;

    return PopupMenuButton<ZyncupThemeOption>(
      tooltip: 'Theme',
      initialValue: selectedTheme,
      icon: Icon(selectedTheme.icon),
      onSelected: controller.setTheme,
      itemBuilder: (context) {
        return ZyncupThemeOption.values.map((theme) {
          return PopupMenuItem<ZyncupThemeOption>(
            value: theme,
            child: Row(
              children: [
                Icon(theme.icon, size: 20),
                const SizedBox(width: 12),
                Text(theme.label),
                if (theme == selectedTheme) ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 18),
                ],
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
