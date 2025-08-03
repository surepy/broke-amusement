import 'package:broke_amusement/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BrokeAmusementApp());
}

class BrokeAmusementApp extends StatelessWidget {
  const BrokeAmusementApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '(Brok)e-amusement',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const MyHomePage(title: '(brok)e-amusement'),
    );
  }
}
