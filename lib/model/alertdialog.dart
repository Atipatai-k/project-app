import 'package:flutter/material.dart';

enum DialogAction { Yes, Cancle }

class AlertDialogs {
  static Future<DialogAction> yesCancleDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          title: Text(title),
          content: Text(body),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(DialogAction.Cancle),
              child: Text(
                "ยกเลิก",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(DialogAction.Yes),
              child: Text(
                "ยืนยัน",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.Cancle;
  }
}
