// import 'package:app_settings/app_settings.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// final firebase = FirebaseDatabase.instance.ref().child("token");
// class NotificationServices {
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   String fcmToken = "Getting Firebase Token";

//   getToken() async {
//     String? token = await _firebaseMessaging.getToken();
//     fcmToken = token!;
//     print("token :" + fcmToken);
//     await firebase.update({'token': fcmToken});
//   }

//   void request() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: true, // Allow notification announcement (heads-up display)
//       badge: true,
//       carPlay: true, // Allow notification on CarPlay
//       criticalAlert: true, // Allow critical alerts on iOS
//       provisional: true,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('user granted permission');
//       getToken();
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('user granted provisional permission');
//     } else {
//       AppSettings.openAppSettings();
//       print('user denied permission');
//     }
//   }
// }
