import 'package:flutter/material.dart';
import '../core/routes.dart';

class WinchoosApp extends StatelessWidget {
  const WinchoosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Winchoos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0066CC)),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}