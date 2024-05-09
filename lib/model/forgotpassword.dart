import 'package:app2/model/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = '';

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _email);
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("รีเซ็ตรหัสผ่าน"),
          content: Text("รีเซ็ตรหัสถูกส่งไปยังอีเมลเรียบร้อย"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("เกิดข้อผิดพลาด"),
          content: Text("ไม่พบอีเมลนี้ในระบบ"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }));
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/logobran.JPG'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text("ลืมรหัสผ่าน"),
            actions: [
              iconhome(LoginScreen()),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/backhome5.JPG'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/image/logobran7.png',
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'อีเมล',
                            icon: Icon(
                              Icons.email_outlined,
                              size: 40,
                            ),
                            focusedBorder: myfocusborder(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _email = value.trim();
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              child: Text(
                                "รีเซ็ตรหัสผ่าน",
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                              ),
                              onPressed: () async {
                                _resetPassword();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
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

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 3,
        ));
  }
}
