import 'package:flutter/material.dart';
import 'package:practical_cie_task/Login.dart';
import 'package:practical_cie_task/Regestration.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/team_illustration.png'),
              SizedBox(
                height: 400,
              ),
              Row(
                children: [
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed: (){
                          setState(() {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyReg(),));
                          });
                        }, child: Text("Register Yourself")),
                        SizedBox(
                          width: 140,
                        ),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLogin(),));
                          });
                        }, child: Text("SIGN IN"))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
