import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

final firebase = FirebaseDatabase.instance.ref().child("Controller");
final firebase2 = FirebaseDatabase.instance.ref().child("statistics");

class myinsertclass {
  static insert(context) {
    var idController = new TextEditingController();
    String humi1 = "0.1";
    String humi2 = "0.1";
    String nontiless = "0";
    String nontimore = "90";
    String system = "Manual";
    String humivalveoff1 = "0";
    String timevalveon1 = "00.00";
    String humivalveoff2 = "0";
    String timevalveon2 = "00.00";
    String valveA = "OFF";
    String valveM = "OFF";
    int statusnode = 1;
    int statussensor = 1;
    void insertData(
      int id,
      String humi1,
      String humi2,
      String nontiless,
      String nontimore,
      String valveM,
      String valveA,
      String system,
      String humivalveoff1,
      String timevalveon1,
      String humivalveoff2,
      String timevalveon2,
      int statusnode,
      int statussensor,
    ) {
      firebase.child("$id").set({
        'Humidity1': humi1,
        'Humidity2': humi2,
        'Local': id,
        'Nonti-less': nontiless,
        'Nonti-more': nontimore,
        'Valve': valveM,
        'ValveStatusAuto': valveA,
        'System': system,
        'StatusSensor': statussensor,
        'ValveAuto': {
          '1': {'HumiValveOff': humivalveoff1, 'TimeValveOn': timevalveon1},
          '2': {'HumiValveOff': humivalveoff2, 'TimeValveOn': timevalveon2},
        },
        'Statusnode': statusnode,
      });
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Text("เพิ่มชุดควบคุมความชื้น"),
            content: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: idController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      labelText: 'หมายเลขไอดีชุดควบคุม',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
              ]),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("ยกเลิก"),
              ),
              TextButton(
                child: Text(
                  "เพิ่มชุดควบคุม",
                ),
                onPressed: () async {
                  if (idController.text.isNotEmpty) {
                    String id = idController.text;
                    int d = int.parse(id);
                    if (d < 16) {
                      insertData(
                        d,
                        humi1,
                        humi2,
                        nontiless,
                        nontimore,
                        valveM,
                        valveA,
                        system,
                        humivalveoff1,
                        timevalveon1,
                        humivalveoff2,
                        timevalveon2,
                        statusnode,
                        statussensor,
                      );
                      Fluttertoast.showToast(
                          msg: "เพิ่มข้อมูลสำเร็จ", gravity: ToastGravity.TOP);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => homepage(),
                        ),
                        (route) => false,
                      );
                    } else if (d == 0 || d >= 16) {
                      Fluttertoast.showToast(
                          msg: "กรุณากรอก ID ให้อยู่ในช่วง 1-15",
                          gravity: ToastGravity.CENTER);
                    } else {
                      Fluttertoast.showToast(
                          msg: "กรุณากรอกข้อมูล", gravity: ToastGravity.CENTER);
                    }
                  }
                },
              ),
            ],
          );
        });
  }
}
