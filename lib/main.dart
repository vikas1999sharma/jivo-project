import 'package:flutter/material.dart';

import 'Screens/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.indigo[900],
          backgroundColor: Colors.greenAccent,
          accentColor: Colors.red),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
