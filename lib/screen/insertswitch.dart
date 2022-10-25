import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InsertSwitch extends StatefulWidget {
  const InsertSwitch({super.key});

  @override
  State<InsertSwitch> createState() => _InsertSwitchState();
}

class _InsertSwitchState extends State<InsertSwitch> {
  var statusController = new TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Controller"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Add Controller Data",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: statusController,
                  decoration: InputDecoration(
                      labelText: 'Switch', border: OutlineInputBorder()),
                ),

                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (statusController.text.isNotEmpty) {
                        insertData(statusController.text);
                        Fluttertoast.showToast(
                            msg: "Insert Success", gravity: ToastGravity.TOP);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return homepage();
                        }));
                      }
                      else
                          Fluttertoast.showToast(
                          msg: "Please check the information",
                          gravity: ToastGravity.CENTER);
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertData(String status) {
    String? key = databaseRef.child("Switch").push().key;
    databaseRef.child("Switch").child(key!).set({
      'id' : key,
      'status': status,
    });
    statusController.clear();
  }
}