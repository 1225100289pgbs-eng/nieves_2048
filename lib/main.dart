import 'package:flutter/material.dart';
import 'presentation/juego_screen.dart';

void main() => runApp(const Nieves2048App());

class Nieves2048App extends StatelessWidget {
  const Nieves2048App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nieves 2048',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const JuegoScreen(),
    );
  }
}
