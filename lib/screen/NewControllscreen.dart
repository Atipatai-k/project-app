import 'dart:async';
import 'package:app2/model/deleteclass.dart';
import 'package:app2/model/updateclass.dart';
import 'package:app2/screen/homepage.dart';
import 'package:app2/screen/noti.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';

final deleteclass = mydeleteclass();
final updateclass = myupdateclass();

class NewControllscreen extends StatefulWidget {
  final String id;
  NewControllscreen({required this.id, Key? key})
      : super(key: ValueKey<String>(id));

  @override
  State<NewControllscreen> createState() => _NewControllscreenState();
}

class _NewControllscreenState extends State<NewControllscreen> {
  final firebase = FirebaseDatabase.instance.ref().child("Controller");
  late final firebase2 =
      FirebaseDatabase.instance.ref('Controller/${widget.id}/').onValue;
  final Future<FirebaseApp> firebase3 = Firebase.initializeApp();
  final switchData = GetStorage();
  bool isSwitched1 = false;
  bool isSwitched2 = false;
  void Auto() async {
    await firebase.child("${widget.id}").update({'System': 'Auto'});
  }

  void Manual() async {
    await firebase.child("${widget.id}").update({'System': 'Manual'});
  }

  void ValveON() async {
    await firebase.child("${widget.id}").update({'Valve': 'ON'});
  }

  void ValveOFF() async {
    await firebase.child("${widget.id}").update({'Valve': 'OFF'});
  }

  void ModeSwitch(bool value) async {
    setState(() {
      if (!isSwitched2) {
        isSwitched1 = value;
        isSwitched2 = false;
        if (!value) {
          Manual();
        } else {
          Auto();
        }
      }
      switchData.write('${widget.id}', isSwitched1);
    });
  }

  void ValveSwitch(bool value) async {
    setState(() {
      if (!isSwitched1) {
        isSwitched1 = false;
        isSwitched2 = value;
        if (value) {
          ValveON();
        } else {
          ValveOFF();
        }
        switchData.write('${widget.id}x', isSwitched2);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final humibase =
        FirebaseDatabase.instance.ref().child("Controller/${widget.id}");
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    Noti.initialize(flutterLocalNotificationsPlugin);
    humibase.onValue.listen((event) {
      setState(() {
        if (mounted) {
          double humi1 =
              double.parse(event.snapshot.child("Humidity1").value as String);
          double humi2 =
              double.parse(event.snapshot.child("Humidity2").value as String);
          double nontiless =
              double.parse(event.snapshot.child("Nonti-less").value as String);
          double nontimore =
              double.parse(event.snapshot.child("Nonti-more").value as String);
          String system = event.snapshot.child("System").value as String;
          String valveA =
              event.snapshot.child("ValveStatusAuto").value as String;
          String valveM = event.snapshot.child("Valve").value as String;
          int statussensor = event.snapshot.child("StatusSensor").value as int;

          if (system == "Auto" || system == "Manual") {
            if ((humi1 >= nontimore || humi2 >= nontimore)) {
              Noti.showBigTextNotification(
                  title: "คำเตือน ค่าความชื้นสูง",
                  body: "Con_ ${widget.id}" + " ค่าความชื้นสูงเกิน กรุณาปิดน้ำ",
                  fln: flutterLocalNotificationsPlugin);
            }
            if (humi1 <= nontiless || humi2 <= nontiless) {
              Noti.showBigTextNotification(
                  title: "คำเตือน ค่าความชื้นต่ำ",
                  body:
                      "Con_ ${widget.id}" + " ค่าความชื้นต่ำเกิน กรุณาเปิดน้ำ",
                  fln: flutterLocalNotificationsPlugin);
            }
            if (humi1 < 0 || humi2 < 0 || humi1 > 100 || humi2 > 100) {
              Noti.showBigTextNotification(
                  title: "คำเตือน ค่าความชื้นผิดปกติ",
                  body: "กรุณาตรวจสอบ Con_" + "${widget.id}",
                  fln: flutterLocalNotificationsPlugin);
            }
          }
          if (statussensor == 1) {
            Noti.showBigTextNotification(
                title: "เกิดข้อผิดพลาด Con_" + "${widget.id}",
                body: "ผู้ใช้กรุณาตรวจสอบการเชื่อมต่อเซ็นเซอร์ 1",
                fln: flutterLocalNotificationsPlugin);
          } else if (statussensor == 2) {
            Noti.showBigTextNotification(
                title: "เกิดข้อผิดพลาด Con_" + "${widget.id}",
                body: "ผู้ใช้กรุณาตรวจสอบการเชื่อมต่อเซ็นเซอร์ 2",
                fln: flutterLocalNotificationsPlugin);
          } else if (statussensor == 3) {
            Noti.showBigTextNotification(
                title: "เกิดข้อผิดพลาด Con_" + "${widget.id}",
                body: "ผู้ใช้กรุณาตรวจสอบการเชื่อมต่อเซ็นเซอร์ทั้ง 2 ตัว",
                fln: flutterLocalNotificationsPlugin);
          }

          List<double> numbers = [];
          double initialHumi1 = 0;
          if (initialHumi1 == 0) {
            initialHumi1 = humi1;
            if (valveA == "ON" || valveM == "ON") {
              if (numbers.isEmpty) {
                numbers.add(initialHumi1);
                print(numbers);
                void checkHumi1() {
                  if (initialHumi1 > numbers[0]) {
                    print('ปกติ:$numbers');
                  } else {
                    Noti.showBigTextNotification(
                        title: "เกิดข้อผิดพลาด Con_" + "${widget.id}",
                        body: "ผู้ใช้กรุณาตรวจสอบทั้งระบบน้ำและเซ็นเซอร์",
                        fln: flutterLocalNotificationsPlugin);
                  }
                }
                Timer.periodic(Duration(minutes: 5), (timer) {
                  checkHumi1();
                  timer.cancel();
                });
              }
            }
            initialHumi1 = humi1;
          }
        }
      });
    });

    if (switchData.read('${widget.id}') != null) {
      setState(() {
        isSwitched1 = switchData.read('${widget.id}');
      });
    }
    if (switchData.read('${widget.id}x') != null) {
      setState(() {
        isSwitched2 = switchData.read('${widget.id}x');
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return homepage();
        }));
        return false;
      },
      child: FutureBuilder(
          future: firebase3,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(
                  title: Text("Error"),
                ),
                body: Center(
                  child: Text("${snapshot.error}"),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
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
                  title: Text("ระบบควบคุมความชื้น Con_" + '${widget.id}'),
                  actions: [
                    IconButton(
                        onPressed: () {
                          mydeleteclass.Confirm(
                              "Delete Confirm", context, '${widget.id}');
                        },
                        icon: Icon(Icons.delete)),
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return homepage();
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
                  child: SingleChildScrollView(
                    child: StreamBuilder(
                        stream: firebase2,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            //data
                            final data = snapshot.data?.snapshot.value as Map?;
                            final data2 = snapshot.data?.snapshot
                                .child('ValveAuto/1')
                                .value as Map?;
                            final data3 = snapshot.data?.snapshot
                                .child('ValveAuto/2')
                                .value as Map?;
                            //key
                            final key1 = snapshot.data?.snapshot
                                .child('ValveAuto/1')
                                .key;
                            final key2 = snapshot.data?.snapshot
                                .child('ValveAuto/2')
                                .key;
                            if (data == null) {
                              return Text('No data');
                            }
                            final humidity1 = data['Humidity1'];
                            final humidity2 = data['Humidity2'];
                            final nontiless = data['Nonti-less'];
                            final nontimore = data['Nonti-more'];
                            final valvestatusA = data['ValveStatusAuto'];
                            final timevalveon1 = data2?['TimeValveOn'];
                            final timevalveon2 = data3?['TimeValveOn'];
                            final humivalveoff1 = data2?['HumiValveOff'];
                            final humivalveoff2 = data3?['HumiValveOff'];

                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 35, 15, 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 15, 15),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: text1("โหมด"),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: text1("Manual"),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Switch(
                                                    value: isSwitched1,
                                                    onChanged: (value) {
                                                      ModeSwitch(value);
                                                    },
                                                    activeColor: Colors.amber,
                                                    activeTrackColor:
                                                        Colors.amber,
                                                    inactiveThumbColor:
                                                        Colors.red,
                                                    inactiveTrackColor:
                                                        Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: text1("Auto"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: text1("วาล์ว"),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: text1("ปิด"),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Switch(
                                                  value: isSwitched2,
                                                  onChanged: (value) {
                                                    ValveSwitch(value);
                                                  },
                                                  activeColor: Colors.amber,
                                                  activeTrackColor: Colors.cyan,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: text1("เปิด"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .water_drop_outlined,
                                                        color: Color.fromARGB(
                                                            255, 0, 122, 6),
                                                        size: 40),
                                                    Text(
                                                      humidity1 + " %",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Text("ความชื้นในดิน 1")
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .water_drop_outlined,
                                                        color: Color.fromARGB(
                                                            255, 0, 122, 6),
                                                        size: 40),
                                                    Text(
                                                      humidity2 + " %",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Text("ความชื้นในดิน 2")
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    height: 520,
                                    width: 385,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: text1(
                                                    "ตั้งค่าการเปิด-ปิดน้ำระบบ Auto"),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "สถานะวาล์ว : " +
                                                      valvestatusA,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 15, 15, 15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(25),
                                                  child: Column(
                                                    children: [
                                                      text1(
                                                          'เปิดน้ำระบบ Auto_1'),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    myupdateclass.update1(
                                                                        timevalveon1,
                                                                        context,
                                                                        key1,
                                                                        '${widget.id}');
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/clock.png',
                                                                    width: 50,
                                                                    height: 50,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "เปิดวาล์วเวลา",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                                Text(
                                                                  timevalveon1 +
                                                                      " น.",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    myupdateclass.update2(
                                                                        humivalveoff1,
                                                                        context,
                                                                        key1,
                                                                        '${widget.id}');
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/valve.png',
                                                                    width: 50,
                                                                    height: 50,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "ปิดเมื่อความชื้น",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                Text(
                                                                  humivalveoff1 +
                                                                      "% RH",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 15, 15, 15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(25),
                                                  child: Column(
                                                    children: [
                                                      text1(
                                                          'เปิดน้ำระบบ Auto_2'),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    myupdateclass.update1(
                                                                        timevalveon2,
                                                                        context,
                                                                        key2,
                                                                        '${widget.id}');
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/clock.png',
                                                                    width: 50,
                                                                    height: 50,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "เปิดวาล์วเวลา",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                                Text(
                                                                  timevalveon2 +
                                                                      " น.",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    myupdateclass.update2(
                                                                        humivalveoff2,
                                                                        context,
                                                                        key2,
                                                                        '${widget.id}');
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/valve.png',
                                                                    width: 50,
                                                                    height: 50,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "ปิดเมื่อความชื้น",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                Text(
                                                                  humivalveoff2 +
                                                                      "% RH",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    height: 200,
                                    width: 385,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          text1("ตั้งค่าการแจ้งเตือน"),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .unfold_less_double_outlined,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                        iconSize: 70,
                                                        onPressed: () {
                                                          myupdateclass.update3(
                                                              nontiless,
                                                              context,
                                                              '${widget.id}');
                                                        },
                                                      ),
                                                      Text(
                                                        nontiless + " %",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        "ความชื้นน้อยกว่า",
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .unfold_more_double_outlined,
                                                          color: Colors.orange,
                                                        ),
                                                        iconSize: 70,
                                                        onPressed: () {
                                                          myupdateclass.update4(
                                                              nontimore,
                                                              context,
                                                              '${widget.id}');
                                                        },
                                                      ),
                                                      Text(
                                                        nontimore + " %",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Text(
                                                        "ความชื้นมากกว่า",
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            );
                          }
                          if (snapshot.hasError) {
                            print(snapshot.error.toString());
                            return Text(snapshot.error.toString());
                          }
                          return Text('....');
                        }),
                  ),
                ),
              );
            }
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }));

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
}
