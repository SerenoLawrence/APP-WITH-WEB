import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';

class CivilWatchApp extends StatelessWidget {
  const CivilWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Make AppState accessible anywhere via InheritedWidget pattern
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        return MaterialApp(
          title: 'CIVILWATCH',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
