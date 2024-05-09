import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

final firebase = FirebaseDatabase.instance.ref().child("Controller");

class myupdateclass {
  static update1(String set1, context, var key, var node) {
    void updateData(String timevalveon, var key) {
      Map<String, String> x = {
        "TimeValveOn": timevalveon,
      };
      firebase.child(node).child("ValveAuto").child(key).update(x);
    }

    var set_1 = TextEditingController(text: set1);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Text("แก้ไขระบบรดน้ำ Auto"),
            content: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: set_1,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                      labelText: 'เวลาที่ต้องการรดน้ำ',
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
                onPressed: () {
                  updateData(set_1.text, key);
                  Fluttertoast.showToast(
                      msg: "แก้ไขข้อมูลสำเร็จ", gravity: ToastGravity.TOP);
                  Navigator.of(context).pop();
                },
                child: Text("แก้ไข"),
              ),
            ],
          );
        });
  }

  static update2(String set2, context, var key, var node) {
    void updateData(String humivalveoff, var key) {
      
      Map<String, String> x = {
        "HumiValveOff": humivalveoff,
      };
      firebase.child(node).child("ValveAuto").child(key).update(x);
    }
    

    var set_2 = TextEditingController(text: set2);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Text("แก้ไขระบบรดน้ำ Auto"),
            content: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: set_2,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                      labelText: 'ค่าความชื้นที่ต้องการหยุดรดน้ำ',
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
                onPressed: () {
                  updateData(set_2.text, key);
                  Fluttertoast.showToast(
                      msg: "แก้ไขข้อมูลสำเร็จ", gravity: ToastGravity.TOP);
                  Navigator.of(context).pop();
                },
                child: Text("แก้ไข"),
              ),
            ],
          );
        });
  }

  static update3(String set1, context, var key) {
    void updateData(String x) {
      firebase.child(key).update({
        'Nonti-less': x,
      });
    }

    var set_1 = TextEditingController(text: set1);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Text("แจ้งเตือนเมื่อความชื้นน้อยกว่า"),
            content: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: set_1,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
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
                onPressed: () {
                  updateData(
                    set_1.text,
                  );
                  Fluttertoast.showToast(
                      msg: "แก้ไขข้อมูลสำเร็จ", gravity: ToastGravity.TOP);
                  Navigator.of(context).pop();
                },
                child: Text("แก้ไข"),
              ),
            ],
          );
        });
  }

  static update4(String set1, context, var key) {
    void updateData(String x) {
      firebase.child(key).update({
        'Nonti-more': x,
      });
    }

    var set_1 = TextEditingController(text: set1);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Text("แจ้งเตือนเมื่อความชื้นมากกว่า"),
            content: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: set_1,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
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
                onPressed: () {
                  updateData(
                    set_1.text,
                  );
                  Fluttertoast.showToast(
                      msg: "แก้ไขข้อมูลสำเร็จ", gravity: ToastGravity.TOP);
                  Navigator.of(context).pop();
                },
                child: Text("แก้ไข"),
              ),
            ],
          );
        });
  }
}
