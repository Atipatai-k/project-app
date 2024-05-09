import 'package:app2/model/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Warning {
  static Future<bool?> showexit(BuildContext context) async => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('คุณต้องการออกจากแอปพลิเคชันนี้หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('ไม่'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('ใช่'),
            ),
          ],
        ),
      );
  static Future<bool?> showlogout(BuildContext context) async => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('ไม่'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                );
                Fluttertoast.showToast(
                    msg: "ออกจากระบบสำเร็จ", gravity: ToastGravity.TOP);
              },
              child: Text('ใช่'),
            ),
          ],
        ),
      );
}
