import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/details/details_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';
  static const String details = '/details';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return _build(const HomeScreen(), settings);
      case AppRoutes.settings:
        return _build(const SettingsScreen(), settings);
      case AppRoutes.details:
        final args = settings.arguments;
        if (args is DetailsArgs) {
          return _build(DetailsScreen(args: args), settings);
        }
        return _errorRoute('Eksik veya hatalı argüman: DetailsArgs bekleniyordu.');
      default:
        return _errorRoute('Bilinmeyen rota: ${settings.name}');
    }
  }

  static MaterialPageRoute _build(Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }

  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Hata')),
        body: Center(child: Text(message)),
      ),
    );
  }
}