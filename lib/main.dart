import 'package:flutter/material.dart';
import 'package:practical_cie_task/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyCgMwdK6wdu69ybPR9prTFyEvTHlWsp2p4",
          appId: '1:41315824406:android:58dd3220ac6febccb9d637',
          messagingSenderId: '41315824406',
          projectId: 'practical-cie-task')
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: SplashScreen()
    );
  }
}