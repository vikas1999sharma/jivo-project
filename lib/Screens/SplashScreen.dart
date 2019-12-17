import 'dart:async';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'LoginPage.dart';

import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String email = prefs.getString('email');

        if (email == null) {
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => new LoginPage()));
        } else {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new HomeScreen(data: email)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        home: 
         Padding(padding: const EdgeInsets.all(11),
        
       child: Stack(
          
          fit: StackFit.expand, 
          
          children: <Widget>[
    Padding(padding: const EdgeInsets.all(5),),   
       
          new Image(
            image: AssetImage("assets/j.jpg"),
            fit: BoxFit.contain,
            color: Colors.green,
          ),
        ])) );
  }
}

Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print(email);
  runApp(MaterialApp(home: email == null ? LoginPage() : HomeScreen()));
}
