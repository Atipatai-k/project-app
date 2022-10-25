import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Inserthumidity extends StatefulWidget {
  const Inserthumidity({super.key});

  @override
  State<Inserthumidity> createState() => _InserthumidityState();
}

class _InserthumidityState extends State<Inserthumidity> {
  var humidityController = new TextEditingController();

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
                  controller: humidityController,
                  decoration: InputDecoration(
                      labelText: 'Humidity', border: OutlineInputBorder()),
                ),

                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (humidityController.text.isNotEmpty) {
                        insertData(humidityController.text);
                        Fluttertoast.showToast(
                            msg: "Insert Success", gravity: ToastGravity.TOP);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return homepage();
                        }));
                      }
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

  void insertData(String humidity) {
    String? key = databaseRef.child("Humidity").push().key;
    databaseRef.child("Humidity").child(key!).set({
      'id' : key,
      'values': humidity,
    });
    humidityController.clear();
  }
}
