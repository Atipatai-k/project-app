import 'package:app2/screen/displaysetting1.dart';
import 'package:app2/screen/homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class formscreen extends StatefulWidget {
  const formscreen({super.key});
  @override
  State<formscreen> createState() => _formscreenState();
}

class _formscreenState extends State<formscreen> {
  final _humidityRef = FirebaseDatabase.instance.ref().child("Humidity");

  bool isSwitched = false;
  var textValue = 'OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'ON';
      });
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'OFF';
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return RealtimeDisplaysetting1();
              }));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Color.fromARGB(255, 190, 226, 255),
                      borderRadius: BorderRadius.circular(20)),
                  height: 150,
                  width: 350,
                  child: Column(children: [
                    Text(
                      "Status System",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "$textValue",
                      style: TextStyle(fontSize: 20),
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
                              query: _humidityRef
                                  .orderByChild("id")
                                  .equalTo("-NF1pC1zdMCVBNmkuleC"),
                              itemBuilder:
                                  ((context, snapshot, animation, index) {
                                return new ListTile(
                                  title: new Text(
                                    snapshot.child('values').value.toString() +
                                        " % RH",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
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
                                  .orderByChild("id")
                                  .equalTo("-NF1pEkwV2MIOoQK-OfX"),
                              itemBuilder:
                                  ((context, snapshot, animation, index) {
                                return new ListTile(
                                  title: new Text(
                                    snapshot.child('values').value.toString() +
                                        " % RH",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
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
                    onChanged: toggleSwitch,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

IconButton iconhome(key){
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
