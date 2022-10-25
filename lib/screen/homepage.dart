import 'package:app2/model/alertdialog.dart';
import 'package:app2/screen/displaysetting2.dart';
import 'package:app2/screen/login.dart';
import 'package:app2/screen/newformscreen.dart';
import 'package:app2/screen/newformscreen2.dart';
import 'package:app2/screen/realtimeInsert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final auth = FirebaseAuth.instance;
  String title = 'AlertDialog';
  bool tappedYes = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Automatic Watering Durian"),
        actions: [ 
          logoutalert(LoginScreen()),
          testwindow(RealtimeDisplaysetting2()),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(70),
            child: Column(
              children: [
                Icon(
                  Icons.people,
                  size: 150,
                ),
                Text(
                  auth.currentUser!.email.toString(),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 50,
                ),
                sizedBoxController('Controller1',Newformscreen()),
                SizedBox(
                  height: 20,
                ),
                sizedBoxController('Controller2',Newformscreen2())
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return RealtimeInsert();
            }));
          }),
    );
  }

IconButton logoutalert(key){
  return IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final action = await AlertDialogs.yesCancleDialog(
                  context, 'Logout', 'are you sure ?');
              if (action == DialogAction.Yes) {
                setState(() => tappedYes = true);
                auth.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return key;
                  }));
                  Fluttertoast.showToast(
                      msg: "Log out Success", gravity: ToastGravity.TOP);
                });
              } else {
                setState(() => tappedYes = false);
              }
            },
          );
  }  
IconButton testwindow(key){
  return            IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return key;
                }));
            },
          );
}    
SizedBox sizedBoxController(String t,key){ 
  return                 SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueAccent),
                    ),
                    child: Text(
                      t,
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return key;
                      }));
                    },
                  ),
                );
}
}
