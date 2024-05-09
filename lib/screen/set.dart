import 'package:app2/model/deleteclass.dart';
import 'package:app2/model/updateclass.dart';
import 'package:app2/screen/NewControllscreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

final deleteclass = mydeleteclass();
final updateclass = myupdateclass();

class Setscreen extends StatefulWidget {
  final String id;
  Setscreen({required this.id, Key? key}) : super(key: ValueKey<String>(id));

  @override
  _SetscreenState createState() => _SetscreenState();
}

class _SetscreenState extends State<Setscreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  final firebase = FirebaseDatabase.instance.ref().child("Controller");

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime, // ใช้เวลาเริ่มต้นที่ต้องการ
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void insertData(
    String TimeValveOn,
    String HumiValveOff,
  ) async {
    int ssd = 1;
    var dataSnapshot = await firebase
        .child('${widget.id}')
        .child("ValveAuto")
        .child('$ssd')
        .once();

    if (dataSnapshot.snapshot.value != null) {
      int newValue = ssd + 1;
      firebase.child('${widget.id}').child("ValveAuto").child('$newValue').set({
        'TimeValveOn': TimeValveOn,
        'HumiValveOff': HumiValveOff,
      });
    } else {
      firebase.child('${widget.id}').child("ValveAuto").child('$ssd').set({
        'TimeValveOn': TimeValveOn,
        'HumiValveOff': HumiValveOff,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var humi = new TextEditingController();
    String TimeValveOn =
        '${selectedTime.hour.toString().padLeft(2, '0')}.${selectedTime.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/logobran.JPG'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text('เพิ่มการรดน้ำระบบ Auto Con_${widget.id}'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return NewControllscreen(id: "${widget.id}");
              }));
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/backhome3.JPG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text('เลือกเวลารดน้ำ'),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'เวลาที่เลือก: $TimeValveOn',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: humi,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      labelText: 'ค่าความชื้นที่ต้องการหยุดรดน้ำ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (humi.text.isNotEmpty) {
                      String HumiValveOff = humi.text;
                      insertData(
                        TimeValveOn,
                        HumiValveOff,
                      );
                      Fluttertoast.showToast(
                          msg: "เพิ่มข้อมูลสำเร็จ", gravity: ToastGravity.TOP);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return NewControllscreen(id: "${widget.id}");
                      }));
                    } else {
                      Fluttertoast.showToast(
                          msg: "กรุณากรอกข้อมูล", gravity: ToastGravity.CENTER);
                    }
                  },
                  child: Text('บันทึก'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
