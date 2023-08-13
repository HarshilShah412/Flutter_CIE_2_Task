import 'package:practical_cie_task/DisplayLeave.dart';
import 'package:flutter/material.dart';
import 'package:practical_cie_task/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var name;

class AdminDashbord extends StatefulWidget {
  const AdminDashbord({super.key});

  @override
  State<AdminDashbord> createState() => _AdminDashbordState();
}

class _AdminDashbordState extends State<AdminDashbord> {
  bool activeDeactive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvaluefrompref();
  }

  void getvaluefrompref() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("Name");
      print(name);
    });
  }

  final CollectionReference _tblEmployee = FirebaseFirestore.instance.collection('practical-cie-task');

  void Logout() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("isAdminloggedin", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyLogin()));
  }

  Future<void> _Update(DocumentSnapshot documentSnapshot) async {
    print(documentSnapshot.id);
    print(activeDeactive);
    await _tblEmployee
        .doc(documentSnapshot.id)
        .update({'status': !activeDeactive});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          name.toString(),
          style: TextStyle(color: Colors.white),
        ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.logout)
          ),
        ),
      body: StreamBuilder(
        stream: _tblEmployee.snapshots(), //contains data

        builder: (context, AsyncSnapshot<QuerySnapshot> streamsnapshot) {
          if (streamsnapshot.hasData) {
            print(streamsnapshot.data!.docs.length);
            return ListView.builder(
              itemCount:
              streamsnapshot.data!.docs.length, //docs refers to the rows
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                streamsnapshot.data!.docs[index];
                activeDeactive = documentSnapshot['status'];
                return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DisplayLeave(documentSnapshot.id)));
                      },
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(documentSnapshot['email']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: activeDeactive
                                        ? Colors.green
                                        : Colors.red),
                                onPressed: () async {
                                  _Update(documentSnapshot);
                                },
                                child: activeDeactive
                                    ? Text(
                                  "Active",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                                    : Text(
                                  "Deactive",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )),
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
      ),
    );
  }
}