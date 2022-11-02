import 'package:app2/screen/displaysetting1.dart';
import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class Newformscreen extends StatefulWidget {
  const Newformscreen({super.key});

  @override
  State<Newformscreen> createState() => _NewformscreenState();
}

class _NewformscreenState extends State<Newformscreen> {
  final _humidityRef = FirebaseDatabase.instance.ref().child("Humidity");
  final _statusRef = FirebaseDatabase.instance.ref().child("Switch");
  final switchData = GetStorage();

bool isSwitched = false;
  var textValue = 'OFF';

  

  void LedOn() async {
    await _statusRef.child("Status1").update({'status': 'ON'});
  }

  void LedOFF() async {
    await _statusRef.child("Status1").update({'status': 'OFF'});
  }

  void getStatus1() async {
      final newValue = await FirebaseDatabase.instance
      .ref()
      .child("Switch").child("Status1")
      .orderByChild("status");

    setState(() {
      if (newValue == 'ON') {
        isSwitched = true;
      } else {
        isSwitched = false;
      }
    });
  }

    void _handleSwitch(bool value) async {
    if( value ) {
        LedOn();
    } else {
        LedOFF();
    }
    setState(() {
        isSwitched = value;
        switchData.write(
          'isSwitched', 
          isSwitched);
    });
  }
  
  @override
  void initState() {
    getStatus1(); 
    super.initState();
      if(switchData.read('isSwitched') != null){
        setState(() {
          isSwitched = switchData.read('isSwitched');
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controller 1"),
        actions: [
          iconhome(homepage()),
          IconButton(
            icon: Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return RealtimeDisplaysetting1();
              }));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20)),
                height: 150,
                width: 350,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Status1",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: new FirebaseAnimatedList(
                            shrinkWrap: true,
                            query: _statusRef.child("Status1").orderByChild("status"),
                            itemBuilder: ((context, snapshot, animation, index) {
                              return new ListTile(
                                title: new Text(
                                  snapshot.child('status').value.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              );
                            })),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(20)),
                height: 150,
                width: 350,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Humidity 1",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: new FirebaseAnimatedList(
                            shrinkWrap: true,
                            query: _humidityRef.child("Humidity1")
                            ,
                            itemBuilder: ((context, snapshot, animation, index) {
                              return new ListTile(
                                title: new Text(
                                  snapshot.child('values').value.toString() +
                                      " % RH",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              );
                            })),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(20)),
                height: 150,
                width: 350,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Humidity 2",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: new FirebaseAnimatedList(
                            shrinkWrap: true,
                            query: _humidityRef
                                .child("Humidity2"),
                            itemBuilder: ((context, snapshot, animation, index) {
                              return new ListTile(
                                title: new Text(
                                  snapshot.child('values').value.toString() +
                                      " % RH",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              );
                            })),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: LiteRollingSwitch(
                  onChanged: (value) {
                    _handleSwitch(value);
                  },
                  value: isSwitched,
                  textOn: "ON",
                  textOff: "OFF",
                  colorOn: Colors.green,
                  colorOff: Colors.red,
                  iconOn: Icons.done,
                  iconOff: Icons.alarm_off,
                  textSize: 18.0,
                  onDoubleTap: () {},
                  onSwipe: () {},
                  onTap: () {},
                ),
              ),
            ]),
          ),
        ),
      ),
    );
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
