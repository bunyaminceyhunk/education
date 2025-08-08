import 'package:flutter/material.dart';

class DetailsArgs {
  final int id;
  final String? title;
  const DetailsArgs({required this.id, this.title});
}

class DetailsScreen extends StatelessWidget {
  final DetailsArgs args;
  const DetailsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(args.title ?? 'Detay')),
      body: Center(
        child: Text('Detay id: ${args.id}'),
      ),
    );
  }
}