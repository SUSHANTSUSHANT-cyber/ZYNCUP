import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/theme/theme_controller.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  final themeController = await ThemeController.load();
  runApp(ZyncupApp(themeController: themeController));
}
