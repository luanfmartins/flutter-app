import 'package:flutter/material.dart';
import 'package:meu_app/pages/calculator.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: CalculatorPage(),
    );
  }
}
