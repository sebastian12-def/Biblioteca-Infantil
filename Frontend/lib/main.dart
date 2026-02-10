import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const BibliotecaApp());

}

class BibliotecaApp extends StatelessWidget{
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Biblioteca Escolar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF18181B),
      ),
      home: const DashboardScreen(),
    );
  }
}