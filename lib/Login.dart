import 'package:flutter/material.dart';
import 'package:practical_cie_task/AdminDashboard.dart';
import 'package:practical_cie_task/Dashboard.dart';
import 'package:practical_cie_task/Regestration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

var loggedin;
var Adminloggedin;

const List<String> rolelist = <String>[
  'Admin',
  'Employee',
];

class MyLogin extends StatefulWidget {

  var email,Pass;
//  MyLogin(this.email,this.Pass);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {

  final CollectionReference _tblEmployee = FirebaseFirestore.instance.collection('practical-cie-task');

  TextEditingController txtuname = TextEditingController();
  TextEditingController txtpass = TextEditingController();
  bool isPasswordVisible = true;

  String Role = rolelist.first;

  //String? uname,pass;

  clear(){
    txtuname.text = "";
    txtpass.text = "";
  }

  Future<void> _singin() async {
    if (Role == 'Admin') {
      if (txtuname.text == "Admin@gmail.com" && txtpass.text == "Admin123") {
        var pref = await SharedPreferences.getInstance();
        pref.setBool("isAdminloggedin", true);
        pref.setString("Name", "Admin");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminDashbord()));
      }
    } else {
      try {
        QuerySnapshot querySnapshot = await _tblEmployee
            .where("email", isEqualTo: txtuname.text)
            .where("password", isEqualTo: txtpass.text)
            .get();
        if (querySnapshot.docs.length == 0) {
          QuickAlert.show(
            context: context,
            text: "No User is found",
            type: QuickAlertType.error,
          );
        }
        // Process the querySnapshot
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          // bool status = doc['Estatus'];
          if (doc['status'] == true) {
            var pref = await SharedPreferences.getInstance();
            pref.setBool("isloggedin", true);
            pref.setString("Id", doc.id);
            //pref.setString("Name", doc['name']);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(txtuname.text)));
          } else {
            QuickAlert.show(
              context: context,
              text: "You are not activated",
              type: QuickAlertType.error,
            );
            print("Status False");
          }
          print(
              'Name: ${doc['name']}, Status: ${doc['status']},Id: ${doc.id}');
        }
      } catch (e) {
        print('Error fetching data: $e');
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  CircleAvatar(
                    child: Image.asset('assets/team_illustration.png'),
                    //child: Icon(Icons.account_circle,size: 150,),
                    maxRadius: 100,
                    backgroundColor: Colors.blueGrey,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    controller: txtuname,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                        label: Text("Enter Email"),
                        hintText: "Enter Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    obscureText: true,
                    controller: txtpass,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.remove_red_eye_sharp),
                        label: Text("Enter Password"),
                        hintText: "Enter Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  DropdownButton<String>(
                    value: Role,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        Role = value!;
                        print(value);
                      });
                    },
                    items: rolelist.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(onPressed: (){
                    _singin();
                        clear();
                      }, child: Text("SIGN IN"),style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green)
                  )
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  OutlinedButton(onPressed: (){
                    setState(() {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyReg(),));
                    });
                  }, child: Text("Doesn't Have an Account? Sign Up"),style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black)
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

