import 'dart:async';

import 'package:flutter/material.dart';
import 'package:practical_cie_task/Home.dart';
import 'package:practical_cie_task/Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState(){
    super.initState();
    Timer(Duration(seconds: 5),() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLogin() ,)),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: 300,
              child: Image.asset('assets/Logo.png'),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Loading...",style: TextStyle(
              fontSize: 50,
            ),)
          ],
        ),
      )
    );
  }
}
