import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class RealtimeDisplaysetting2 extends StatefulWidget {
  const RealtimeDisplaysetting2({super.key});

  @override
  State<RealtimeDisplaysetting2> createState() => _RealtimeDisplaysetting2State();
}

class _RealtimeDisplaysetting2State extends State<RealtimeDisplaysetting2> {
  final referenceDatabase = FirebaseDatabase.instance.ref().child("Controller");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SettingController"),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: referenceDatabase.orderByChild("ControllerID"),
/*               .equalTo("Controller1"), */
          itemBuilder: (context, snapshot, animation, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("data"),
                ElevatedButton(
                  onPressed: (){

                  }, 
                  child: Text(snapshot.child('ControllerID').value.toString(),)
                  ),
              ],
            );
          })
          ),
      );
    }}