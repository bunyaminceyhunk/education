import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.color_lens_outlined),
            title: Text('Tema'),
            subtitle: Text('Varsayılan (Seed Color)'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language_outlined),
            title: Text('Dil'),
            subtitle: Text('tr-TR'),
          ),
        ],
      ),
    );
  }
}