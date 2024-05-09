import 'package:app2/model/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> sendEmailVerification() async {
  User? user = FirebaseAuth.instance.currentUser;
  await user?.sendEmailVerification();
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/logobran.JPG'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text("สมัครสมาชิก"),
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
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณากรอกอีเมล';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'รหัสผ่าน',
                            icon: Icon(Icons.lock, size: 40),
                            focusedBorder: myfocusborder(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              child: Text(
                                "สมัครสมาชิก",
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                    await sendEmailVerification();
                                    Fluttertoast.showToast(
                                        msg: "กรุณาไปยืนยันอีเมล",
                                        gravity: ToastGravity.TOP);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return LoginScreen();
                                    }));
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      print(
                                          'The password provided is too weak.');
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      print(
                                          'The account already exists for that email.');
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
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
