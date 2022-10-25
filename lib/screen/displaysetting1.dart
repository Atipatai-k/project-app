import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RealtimeDisplaysetting1 extends StatefulWidget {
  const RealtimeDisplaysetting1({super.key});

  @override
  State<RealtimeDisplaysetting1> createState() =>
      _RealtimeDisplaysetting1State();
}

class _RealtimeDisplaysetting1State extends State<RealtimeDisplaysetting1> {
  final referenceDatabase = FirebaseDatabase.instance.ref().child("Controller");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SettingController"),
        actions: [iconhome(homepage())],
      ),
      body: SafeArea(
        child: FirebaseAnimatedList(
          query: referenceDatabase.orderByChild("ControllerID"),
/*               .equalTo("Controller1"), */
          itemBuilder: (context, snapshot, animation, index) {
            return Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      title: Text(
                        snapshot.child('ControllerID').value.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              updateDialog(
                                  snapshot
                                      .child('ControllerID')
                                      .value
                                      .toString(),
                                  snapshot.child('ArduinoID').value.toString(),
                                  snapshot.child('LoraID').value.toString(),
                                  snapshot.child('Sensor1ID').value.toString(),
                                  snapshot.child('Sensor2ID').value.toString(),
                                  context,
                                  snapshot.key);
                            },
                          ),
                          IconButton(
                              onPressed: () {
                                _Confirm(
                                    "Delete Confirm", context, snapshot.key);
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Color.fromARGB(255, 145, 219, 253),
                          borderRadius: BorderRadius.circular(20)),
                      height: 225,
                      width: 375,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "Controller ID :",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot
                                      .child('ControllerID')
                                      .value
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "Arduino ID :",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.child('ArduinoID').value.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "Lora ID :",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.child('LoraID').value.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "Sensor1 ID :",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.child('Sensor1ID').value.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "Sensor2 ID :",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.child('Sensor2ID').value.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> updateDialog(String id, String arduino, String lora,
      String sensor1, String sensor2, BuildContext context, var key) {
    var idController = TextEditingController(text: id);
    var arduinoController = TextEditingController(text: arduino);
    var loraController = TextEditingController(text: lora);
    var sensor1Controller = TextEditingController(text: sensor1);
    var sensor2Controller = TextEditingController(text: sensor2);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update Value"),
            content: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: idController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "ControllerID"),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: arduinoController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: "ArduinoID"),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: loraController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: "LoraID"),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: sensor1Controller,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: "Sensor1ID"),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: sensor2Controller,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: "Sensor2ID"),
                ),
              ]),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancle"),
              ),
              TextButton(
                onPressed: () {
                  UpdataData(
                    idController.text,
                    arduinoController.text,
                    loraController.text,
                    sensor1Controller.text,
                    sensor2Controller.text,
                    key,
                  );
                  Fluttertoast.showToast(
                      msg: "Update Data Success", gravity: ToastGravity.TOP);
                  Navigator.of(context).pop();
                },
                child: Text("Update"),
              ),
            ],
          );
        });
  }

  void UpdataData(String id, String arduino, String lora, String sensor1,
      String sensor2, var key) {
    Map<String, String> x = {
      "ControllerID": id,
      "ArduinoID": arduino,
      "LoraID": lora,
      "Sensor1ID": sensor1,
      "Sensor2ID": sensor2,
    };
    referenceDatabase.child(key).update(x);
  }

  _deleteRecord(String text, var key) async {
    await referenceDatabase.child(key).remove();
  }

  Future<void> _Confirm(String text, BuildContext context, var key) {
    var textcontroller = TextEditingController(text: text);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Confirm"),
            content: SingleChildScrollView(
              child: Column(
                  children: [Text("Would you like to delete this Data")]),
            ),
            actions: [
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  _deleteRecord(
                    textcontroller.text,
                    key,
                  );
                  Fluttertoast.showToast(
                      msg: "Delete Data Success", gravity: ToastGravity.TOP);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
