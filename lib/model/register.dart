import 'package:app2/model/login.dart';
import 'package:app2/model/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
        return false;
      },
      child: FutureBuilder(
          future: firebase,
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
                        key: formKey,
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
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "กรุณากรอกอีเมล"),
                                  EmailValidator(
                                      errorText:
                                          "ไม่พบอีเมลนี้ในระบบ กรุณาตรวจสอบอีเมล"),
                                ]),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (String? email) {
                                  profile.email = email!;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'รหัสผ่าน',
                                  icon: Icon(Icons.lock, size: 40),
                                  focusedBorder: myfocusborder(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                validator: RequiredValidator(
                                    errorText: "กรุณากรอกรหัสผ่าน"),
                                obscureText: true,
                                onSaved: (String? password) {
                                  profile.password = password!;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
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
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState?.save();
                                        try {
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                                  email: profile.email,
                                                  password: profile.password)
                                              .then((value) {
                                            formKey.currentState?.reset();
                                            Fluttertoast.showToast(
                                                msg: "สมัครสมาชิกสำเร็จ",
                                                gravity: ToastGravity.TOP);

                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return LoginScreen();
                                            }));
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.message.toString(),
                                              gravity: ToastGravity.CENTER);
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
              );
            }
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }));

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
