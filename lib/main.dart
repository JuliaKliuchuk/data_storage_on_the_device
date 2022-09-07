import 'package:flutter/material.dart';
import 'package:flutter_application/read_write_file.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyTabBar(),
    );
  }
}

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              text: 'path_provider',
            ),
            Tab(
              text: 'shared_preferences',
            ),
            Tab(
              text: 'SQLite',
            ),
          ]),
          title: const Text('Data storage on the device'),
        ),
        body: const TabBarView(
          children: [
            ReadWriteFile(),
            Icon(Icons.directions_transit, size: 350),
            Icon(Icons.directions_car, size: 350),
          ],
        ),
      ),
    );
  }
}
