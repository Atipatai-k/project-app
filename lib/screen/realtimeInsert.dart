import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RealtimeInsert extends StatefulWidget {
  const RealtimeInsert({super.key});

  @override
  State<RealtimeInsert> createState() => _RealtimeInsertState();
}

class _RealtimeInsertState extends State<RealtimeInsert> {
  var idController = new TextEditingController();
  var arduionController = new TextEditingController();
  var loraController = new TextEditingController();
  var sensor1Controller = new TextEditingController();
  var sensor2Controller = new TextEditingController();
  var docController = new TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Controller"),
        actions: [iconhome(homepage())],
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
                  controller: idController,
                  decoration: InputDecoration(
                      labelText: 'ControllerID', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: arduionController,
                  decoration: InputDecoration(
                      labelText: 'ArduinoID', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: loraController,
                  decoration: InputDecoration(
                      labelText: 'LoraID', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: sensor1Controller,
                  decoration: InputDecoration(
                      labelText: 'Sensor1ID', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: sensor2Controller,
                  decoration: InputDecoration(
                      labelText: 'Sensor2ID', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: docController,
                  decoration: InputDecoration(
                      labelText: 'Documentname', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (idController.text.isNotEmpty &&
                          arduionController.text.isNotEmpty &&
                          loraController.text.isNotEmpty &&
                          sensor1Controller.text.isNotEmpty &&
                          sensor2Controller.text.isNotEmpty) {
                        insertData(
                            idController.text,
                            arduionController.text,
                            loraController.text,
                            sensor1Controller.text,
                            sensor2Controller.text,
                            docController.text,
                            );
                        Fluttertoast.showToast(
                            msg: "Insert Success", gravity: ToastGravity.TOP);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return homepage();
                        }));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please check the information",
                            gravity: ToastGravity.CENTER);
                      }
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

  void insertData(
      String id, String arduino, String lora, String sensor1, String sensor2,String doc) {
    databaseRef.child("Controller").child(doc).set({
      'ControllerID': id,
      'ArduinoID': arduino,
      'LoraID': lora,
      'Sensor1ID': sensor1,
      'Sensor2ID': sensor2,
    });
    idController.clear();
    arduionController.clear();
    loraController.clear();
    sensor1Controller.clear();
    sensor2Controller.clear();
  }

  IconButton iconhome(key) {
    return IconButton(
      icon: Icon(Icons.home),
      onPressed: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return key;
        }));
      },
    );
  }
}
