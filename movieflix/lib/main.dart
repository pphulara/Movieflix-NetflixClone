import 'package:flutter/material.dart';
import 'package:movieflix/pages/homescreen.dart';
import 'package:movieflix/pages/searchscreen.dart';
import 'package:movieflix/pages/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splashscreen(),
      initialRoute: 'splashscreen',
      routes: {
        'spashscreen': (context) => const Splashscreen(),
        'home' : (context) => Homescreen(),
        'search' : (context) => Searchscreen(),
      },
    );
  }
}
