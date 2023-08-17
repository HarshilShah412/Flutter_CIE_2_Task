import 'package:flutter/material.dart';
import 'package:practical_cie_task/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

var id;
var name;

class Dashboard extends StatefulWidget {
  var uname;
  Dashboard(this.uname);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  bool activeDeactive = false;
  var dateController = TextEditingController();
  var enddateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Getvaluefrompref();
  }

  void Getvaluefrompref() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("Id");
    });
  }

  void Logout() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("isloggedin", false);
    Navigator.pop(context);
  }

  final CollectionReference _tblEmployee = FirebaseFirestore.instance.collection('practical-cie-task');

  final nameController = TextEditingController();

  Future<void> _Delete(String leaveId) async {
    await _tblEmployee.doc(id).collection("Leave").doc(leaveId).delete();
  }

  void _showForm(DocumentSnapshot? documentSnapshot) async {
    if (documentSnapshot != null) {
      nameController.text = documentSnapshot['Reason'];
      dateController.text = documentSnapshot['StartDate'];
      enddateController.text = documentSnapshot['endDate'];
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter Leave Reason'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
                controller:
                dateController, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_month), //icon of text field
                    labelText: "Start Date" //label text of field
                ),
                readOnly: true, // when true user cannot edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      //get today's date
                      firstDate: DateTime(2000),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate); //

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
              height: 10,
            ),
            TextField(
                controller:
                enddateController, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_month), //icon of text field
                    labelText: "End Date" //label text of field
                ),
                readOnly: true, // when true user cannot edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);

                    setState(() {
                      enddateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                    print(enddateController.text);
                  } else {
                    print("Date is not selected");
                  }
                }),
            ElevatedButton(
                onPressed: () {
                  if (documentSnapshot == null)
                    _Add();
                  else
                    _Update(documentSnapshot);
                  nameController.clear();
                  dateController.clear();
                  enddateController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(documentSnapshot == null ? 'Create New' : 'Update'))
          ],
        ),
      ),
    );
  }

  Future<void> _Add() async {
    String name = nameController.text;
    String startDate = dateController.text;
    String endDate = enddateController.text;

    await _tblEmployee.doc(id).collection('Leave').add({
      'Reason': name,
      'StartDate': startDate,
      'endDate': endDate,
      'Status': false
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
    );
  }

  Future<void> _Update(DocumentSnapshot documentSnapshot) async {
    String name = nameController.text;
    String startDate = dateController.text;
    String endDate = enddateController.text;

    await _tblEmployee
        .doc(id)
        .collection("Leave")
        .doc(documentSnapshot.id)
        .update({
      'Reason': name,
      'StartDate': startDate,
      'endDate': endDate,
      'Status': false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            '${widget.uname}',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.logout)),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _showForm(null);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: StreamBuilder(
          stream: _tblEmployee
              .doc(id)
              .collection("Leave")
              .snapshots(), //contains data

          builder: (context, AsyncSnapshot<QuerySnapshot> streamsnapshot) {
            if (streamsnapshot.hasData) {
              print(streamsnapshot.data!.docs.length);
              return ListView.builder(
                itemCount:
                streamsnapshot.data!.docs.length, //docs refers to the rows
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamsnapshot.data!.docs[index];
                  activeDeactive = documentSnapshot['Status'];
                  return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(documentSnapshot['Reason']),
                        subtitle: activeDeactive
                            ? Text(
                          "Activate",
                          style: TextStyle(
                              backgroundColor: Colors.green,
                              color: Colors.white,
                              fontSize: 15),
                        )
                            : Text(
                          'Deactivate',
                          style: TextStyle(
                              backgroundColor: Colors.red,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _showForm(documentSnapshot);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    _Delete(documentSnapshot.id);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                      ));
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
     );
  }
}