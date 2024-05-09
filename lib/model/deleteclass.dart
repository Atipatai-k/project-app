import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final firebase = FirebaseDatabase.instance.ref().child("Controller");
final firebase2 = FirebaseDatabase.instance.ref().child("statistics");

class mydeleteclass {
  static Confirm(String text, context, var key) {
    deletecon(String text, var key) async {
      await firebase.child(key).remove();
      await firebase2.child(key).remove();
    }

    var textcontroller = TextEditingController(text: text);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            content: SingleChildScrollView(
              child: Column(children: [
                Text("คุณต้องการจะลบ Con_" + key + " ใช่หรือไม่ ?")
              ]),
            ),
            actions: [
              TextButton(
                child: Text("ไม่"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("ใช่"),
                onPressed: () {
                  deletecon(
                    textcontroller.text,
                    key,
                  );
                  Fluttertoast.showToast(
                      msg: "ลบข้อมูลสำเร็จ", gravity: ToastGravity.TOP);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => homepage(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          );
        });
  }

  static Confirm2(String text, context, var key, var key2) {
    deletecon(String text, var key) async {
      await firebase.child(key).child("ValveAuto").child(key2).remove();
    }

    var textcontroller = TextEditingController(text: text);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            content: SingleChildScrollView(
              child: Column(children: [
                Text("คุณต้องการจะลบใช่หรือไม่ ?")
              ]),
            ),
            actions: [
              TextButton(
                child: Text("ไม่"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("ใช่"),
                onPressed: () {
                  deletecon(
                    textcontroller.text,
                    key,
                  );
                  Fluttertoast.showToast(
                      msg: "ลบข้อมูลสำเร็จ", gravity: ToastGravity.TOP);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
