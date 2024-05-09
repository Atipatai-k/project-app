import 'dart:async';

import 'package:app2/model/alertdialog.dart';
import 'package:app2/model/insertclass.dart';
import 'package:app2/model/login.dart';
import 'package:app2/model/warning.dart';
import 'package:app2/screen/Graphnow.dart';
import 'package:app2/screen/Graphpast.dart';
import 'package:app2/screen/NewControllscreen.dart';
import 'package:app2/screen/noti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

final insertclass = myinsertclass();

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final auth = FirebaseAuth.instance;
  String title = 'AlertDialog';
  bool tappedYes = false;
  final firebase = FirebaseDatabase.instance.ref().child("Controller");
  @override
  void initState() {
    super.initState();
    final humibase = FirebaseDatabase.instance.ref().child("Controller");
    final mainconbase = FirebaseDatabase.instance.ref().child("MainController");
    final FlutterLocalNotificationsPlugin notification =
        FlutterLocalNotificationsPlugin();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    Noti.initialize(notification);
    for (int i = 1; i < 15; i++) {
      humibase.child('$i').onValue.listen((event) {
        setState(() {
          if (mounted) {
            int statusnode =
                (event.snapshot.child("Statusnode").value as int?) ?? 0;
            String key = event.snapshot.key as String;
            if (statusnode == 1) {
              Noti.showBigTextNotification(
                  title: "เกิดข้อผิดพลาด Con_" + key,
                  body: "ผู้ใช้กรุณาตรวจสอบการเชื่อมต่อชุดควบคุม Con_" + key,
                  fln: notification);
            }
          }
        });
      });
    }
    // mainconbase.onValue.listen((event) {
    //   setState(() {
    //     if (mounted) {
    //       double time =
    //           double.parse(event.snapshot.child("TimeStamp").value as String);
    //       List<double> timebase = [];
    //       double timenow = 0;
    //       if (timenow == 0) {
    //         timenow = time;
    //         if (timebase.isEmpty) {
    //           timebase.add(timenow);
    //           print(timebase);
    //           void checktime() {
    //             if (time != timebase[0]) {
    //               print('ปกติ:$timebase');
    //             } else {
    //               Noti.showBigTextNotification(
    //                   title: "เกิดข้อผิดพลาด MainController",
    //                   body: "ไม่พบการเชื่อมต่อ MainController ผู้ใช้งานกรุณาตรวจสอบ",
    //                   fln: flutterLocalNotificationsPlugin);
    //             }
    //           }

    //           Timer.periodic(Duration(minutes: 10), (timer) {
    //             checktime();
    //             timer.cancel();
    //           });
    //         }

    //         timenow = time;
    //       }
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          final back = await Warning.showlogout(context);
          return back ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/logobran.JPG'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text("ระบบให้น้ำอัตโนมัติสำหรับต้นทุเรียน"),
            actions: [
              logoutalert(LoginScreen()),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/backhome3.JPG'),
                fit: BoxFit.cover,
              ),
            ),
            child: FirebaseAnimatedList(
              query: firebase.orderByKey(),
              itemBuilder: (context, snapshot, animation, index) {
                String con = snapshot.key.toString();
                String humi1 = snapshot.child("Humidity1").value.toString();
                String humi2 = snapshot.child("Humidity2").value.toString();
                String statusnode =
                    snapshot.child("Statusnode").value.toString();
                String node = "";
                if (statusnode == "1") {
                  node = "Disconnected";
                } else if (statusnode == "0") {
                  node = "Connected";
                } else {
                  node = "Error";
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0)),
                        Text("ชุดควบคุมความชื้น " + "Con_" + con,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("สถานะการเชื่อมต่อ : " + node,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.settings_applications_outlined,
                                        color: Color.fromARGB(255, 0, 54, 99),
                                      ),
                                      iconSize: 70,
                                      onPressed: () async {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NewControllscreen(id: con),
                                          ),
                                        );
                                      },
                                    ),
                                    Text(
                                      "ตั้งค่าชุดควบคุมความชื้น " + con,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.stacked_line_chart_outlined,
                                        color: Colors.amber,
                                      ),
                                      iconSize: 70,
                                      onPressed: () async {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Graphnow(id: con),
                                          ),
                                        );
                                      },
                                    ),
                                    Text(
                                      "ดูกราฟความชื้น        เรียลไทม์",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.bar_chart_rounded,
                                        color: Colors.red,
                                      ),
                                      iconSize: 70,
                                      onPressed: () async {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Graphpast(
                                              id: con,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Text(
                                      "ดูกราฟความชื้นสถิติย้อนหลัง",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(Icons.water_drop_outlined,
                                      color: Color.fromARGB(255, 0, 122, 6),
                                      size: 40),
                                  Text(
                                    humi1 + " %",
                                    style: TextStyle(fontSize: 26),
                                  ),
                                  Text("ความชื้นในดิน 1")
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(Icons.water_drop_outlined,
                                      color: Color.fromARGB(255, 0, 122, 6),
                                      size: 40),
                                  Text(
                                    humi2 + " %",
                                    style: TextStyle(fontSize: 26),
                                  ),
                                  Text("ความชื้นในดิน 2")
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              myinsertclass.insert(context);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.pink,
          ),
        ),
      );

  Text text1(String key) {
    return Text(
      key,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  IconButton logoutalert(key) {
    return IconButton(
      icon: Icon(Icons.logout),
      onPressed: () async {
        final action = await AlertDialogs.yesCancleDialog(
            context, 'ออกจากระบบ', 'คุณต้องการจะออกจากระบบใช่หรือไม่ ?');
        if (action == DialogAction.Yes) {
          setState(() => tappedYes = true);
          auth.signOut().then((value) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return key;
            }));
            Fluttertoast.showToast(
                msg: "ออกจากระบบสำเร็จ", gravity: ToastGravity.TOP);
          });
        } else {
          setState(() => tappedYes = false);
        }
      },
    );
  }
}
