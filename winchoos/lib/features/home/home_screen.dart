import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../../widgets/app_drawer.dart';
import '../details/details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Winchoos - Home')),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
              icon: const Icon(Icons.settings),
              label: const Text('Ayarlar'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                final args = DetailsArgs(id: 1, title: 'Örnek Detay');
                Navigator.pushNamed(context, AppRoutes.details, arguments: args);
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Detay (id=1)'),
            ),
          ],
        ),
      ),
    );
  }
}