import 'package:app2/model/forgotpassword.dart';
import 'package:app2/model/profile.dart';
import 'package:app2/model/register2.dart';
import 'package:app2/model/warning.dart';
import 'package:app2/screen/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final TextEditingController email = TextEditingController();

  Future<void> saveCredentials(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email);
  }

  Future<void> _loadStoredCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email.text = prefs.getString('user_email') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStoredCredentials();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          final back = await Warning.showexit(context);
          return back ?? false;
        },
        child: FutureBuilder(
            future: firebase,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
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
                    title: Text("เข้าสู่ระบบ"),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.person_add),
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return RegisterPage(); //RegisterScreen();
                          }));
                        },
                      )
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

                                TextFormField(
                                  controller: email,
                                  decoration: InputDecoration(
                                    hintText: 'อีเมล',
                                    icon: Icon(
                                      Icons.people,
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
                                  height: 10,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: SizedBox(
                                    width: 200,
                                    height: 50,
                                    child: ElevatedButton(
                                      child: Text(
                                        "เข้าสู่ระบบ",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo,
                                      ),
                                      onPressed: () async {
                                        await saveCredentials(email.text);
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState?.save();
                                          try {
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                    email: profile.email,
                                                    password: profile.password)
                                                .then((value) {
                                              formKey.currentState?.reset();
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return homepage();
                                              }));
                                              Fluttertoast.showToast(
                                                  msg: "เข้าสู่ระบบสำเร็จ",
                                                  gravity: ToastGravity.TOP);
                                            });
                                          } on FirebaseAuthException catch (e) {
                                            Fluttertoast.showToast(
                                                msg: e.message.toString(),
                                                gravity: ToastGravity.CENTER);
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "รหัสผ่านไม่ถูกต้อง",
                                              gravity: ToastGravity.TOP);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: SizedBox(
                                    width: 200,
                                    height: 50,
                                    child: ElevatedButton(
                                      child: Text(
                                        "ลืมรหัสผ่าน",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo,
                                      ),
                                      onPressed: () async {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ForgotPasswordPage();
                                        }));
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
            }),
      );

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 3,
        ));
  }
}
