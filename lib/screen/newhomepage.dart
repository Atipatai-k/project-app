import 'package:app2/screen/formscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class NewHomepage extends StatefulWidget {
  const NewHomepage({super.key});

  @override
  State<NewHomepage> createState() => _NewHomepageState();
}

class _NewHomepageState extends State<NewHomepage> {
  final auth = FirebaseAuth.instance;
  final referenceDatabase = FirebaseDatabase.instance.ref().child("Controller");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SettingController"),
      ),
      body: SafeArea(
        child: FirebaseAnimatedList(
          query: referenceDatabase.orderByChild("ControllerID"),
/*               .equalTo("Controller1"), */
          itemBuilder: (context, snapshot, animation, index) {
            return Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                               child: SizedBox(
                                width: 200,
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blueAccent),
                                  ),
                                  child: Text(
                                    snapshot.child('ControllerID').value.toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return formscreen();
                                    }));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                    ),],
            );
          },
        ),
      ),
    );
  }
}
