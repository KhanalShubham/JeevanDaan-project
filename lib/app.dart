import 'package:flutter/material.dart';
import 'package:jeevandaan/view/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login());
  }
}