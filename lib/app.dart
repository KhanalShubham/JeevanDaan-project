import 'package:flutter/material.dart';
import 'package:jeevandaan/themes/themes.dart';
import 'package:jeevandaan/view/splash.dart';
import 'package:jeevandaan/view/widget/mainnavigation.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainNavigation(),theme: getApplicationTheme(),);
  }
}