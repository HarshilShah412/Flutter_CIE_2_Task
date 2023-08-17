import 'package:flutter/material.dart';
import 'package:practical_cie_task/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  runApp(MyReg());
}

const List<String> City = <String>[
  'Surat',
  'Bardoli',
  'Ahmadabad',
  'Navsari',
  'Vapi',
  'Valsad'
];
const List<String> Designation = <String>[
  'Project Manager',
  'Assistent Manager',
  'Sr. Developer',
  'Jr. Developer'
];

class MyReg extends StatefulWidget {
  const MyReg({super.key});

  @override
  State<MyReg> createState() => _MyRegState();
}

class _MyRegState extends State<MyReg> {
  final CollectionReference EmployeeDetails = FirebaseFirestore.instance.collection("practical-cie-task");

  TextEditingController txtempid = TextEditingController();
  TextEditingController txtempname = TextEditingController();
  TextEditingController txtempcontact = TextEditingController();
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpass = TextEditingController();
  TextEditingController txtsalary = TextEditingController();
  TextEditingController dateController = TextEditingController();

  var gender = null;

  String? email,Pass;

  String dropdownCity = City.first;
  String dropdownDesig = Designation.first;

  var selectedDate;

  login() async{
    // var pref = await SharedPreferences.getInstance();
    // email = txtemail.text.toString();
    // Pass = txtpass.text.toString();
    //
    // pref.setString("email", email!);
    // pref.setString("Pass", Pass!);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLogin(),));
  }

  Future<void> Add() async{

    String Id = txtempid.text;
    String Name = txtempname.text;
    String Contact = txtempcontact.text;
    String Gender = gender.toString();
    String Email = txtemail.text;
    String Password = txtpass.text;
    String City = dropdownCity.toString();
    String Date = selectedDate.toString();
    String Designation = dropdownDesig.toString();
    String Salary = txtsalary.text;
    bool Status = false;

    await EmployeeDetails.add({"id":Id,"name":Name,"contact":Contact,"gender":Gender,"email":Email,"password":Password,"city":City,"date":Date,"designation":Designation,"salary":Salary,"status":Status});
    QuickAlert.show(context: context, type: QuickAlertType.success,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registeration Page"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                  maxRadius: 100,
                  child: Icon(Icons.note_alt_outlined,size: 150,),
                  backgroundColor: Colors.black,
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: txtempid,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add),
                      label: Text("Enter Employee Number"),
                      hintText: "Enter Employee Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: txtempname,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle),
                      label: Text("Enter Name"),
                      hintText: "Enter Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: txtempcontact,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      label: Text("Enter Contact No."),
                      hintText: "Enter Contact No.",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.lightGreenAccent
                          )
                      )
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                RadioListTile(title: Text("Male"), value: 'Male', groupValue: gender, onChanged: (value){setState(() {
                    gender = value;
                  });
                }),
                RadioListTile(title: Text("Female"),value: 'Female', groupValue: gender, onChanged: (value){
                  setState(() {
                    gender = value;
                  });
                }),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: txtemail,
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
                value: dropdownCity,
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
                    dropdownCity = value!;
                  });
                },
                items: City.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 25,
              ),
                TextField(
                    controller: dateController, //editing controller of this TextField
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Date",
                    ),
                    readOnly: true, // when true user cannot edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), //get today's date
                          firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        String formattedDate = DateFormat('dd-MM-yyyy').format(
                            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

                        setState(() {
                          dateController.text =
                              formattedDate; //set foratted date to TextField value.
                        });
                        print(dateController.text);
                      } else {
                        print("Date is not selected");
                      }
                    }),
                SizedBox(
                  height: 25,
                ),
                DropdownButton<String>(
                  value: dropdownDesig,
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
                      dropdownDesig = value!;
                    });
                  },
                  items: Designation.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: txtsalary,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_balance_wallet),
                      labelText: "Salary Offered",
                      hintText: "Salary Offered",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(onPressed: (){
                  Add();
                  login();
                }, child: Text("Register"),style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.orange)
                )
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(onPressed: (){
                  login();
                }, child: Text("Already Have an Account? Sign In"),style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green)
                )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
