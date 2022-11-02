import 'package:app2/screen/displaysetting1.dart';
import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';


class Newformscreen2 extends StatefulWidget {
  const Newformscreen2({super.key});

  @override
  State<Newformscreen2> createState() => _Newformscreen2State();
}

class _Newformscreen2State extends State<Newformscreen2> {
  final _humidityRef = FirebaseDatabase.instance.ref().child("Humidity");
  final _statusRef = FirebaseDatabase.instance.ref().child("Switch");
  final switchData = GetStorage();

bool _isSwitched = false;
  var textValue = 'OFF';

  

  void LedOn() async {
    await _statusRef.child("Status2").update({'status': 'ON'});
  }

  void LedOFF() async {
    await _statusRef.child("Status2").update({'status': 'OFF'});
  }

  void getStatus() async {
      final newValue = await FirebaseDatabase.instance
      .ref()
      .child("Switch").child("Status2")
      .orderByChild("status");

    setState(() {
      if (newValue == 'ON') {
        _isSwitched = true;
      } else {
        _isSwitched = false;
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
        _isSwitched = value;
        switchData.write(
          '_isSwitched', 
          _isSwitched);
    });
  }
  
  @override
  void initState() {
    getStatus(); 
    super.initState();
      if(switchData.read('_isSwitched') != null){
        setState(() {
          _isSwitched = switchData.read('_isSwitched');
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controller 2"),
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
                        "Status",
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
                            query: _statusRef.child('Status2')
                                .orderByChild("status"),
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
                            query: _humidityRef.child("Humidity3"),
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
                            query: _humidityRef.child("Humidity4"),
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
                  value: _isSwitched,
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