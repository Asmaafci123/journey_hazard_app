//import 'dart:io';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:journeyhazard/core/services/local_storage/local_storage_service.dart';
//final FirebaseMessaging _fcm = new FirebaseMessaging();
//
//class PushNotificationService {
//  static String fcmToken = '';
//
//  static Future<Null>  init() async {
//    print("enter");
//    if(Platform.isIOS) {
//      _fcm.requestNotificationPermissions(IosNotificationSettings());
//    }
//    _fcm.autoInitEnabled().then((bool enabled) => print(enabled));
//    _fcm.setAutoInitEnabled(true).then( (_) => _fcm.autoInitEnabled().then((bool enabled) => print(enabled)));
//    await configure();
//   }
//
//  static Future<Null> configure() async {
//   await _fcm.configure(
//      /// called when app in foreground and received notification
//      onMessage: (Map<String, dynamic> message) async {
//        print("On Message: $message");
//
//      },
//      /// called when app in the background
//      onResume: (Map<String, dynamic> message) async {
//        print("On Resume: $message");
//        _serialiseAndNavigate(message);
//
//      },
//      /// called when app closed comlpetely
//      onLaunch: (Map<String, dynamic>message) async {
//        print("On Launch: $message");
//        _serialiseAndNavigate(message);
//
//      },
//    );
//
//  }
//  static getDeviceToken() async {
//    String deviceToken = await _fcm.getToken();
//    print("deviceFirebase Token: $deviceToken");
//    LocalStorageService().setToken(deviceToken);
//    return deviceToken;
//  }
//   static _serialiseAndNavigate(Map<String, dynamic>message) {
//    var notificationData = message['data'];
//    var view = notificationData['view'];
//    if(view != null) {
//      // navigate
//    }
//
//   }
//
//
//}