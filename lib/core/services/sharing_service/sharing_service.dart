import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class SharingService {


  sendSmsMessage({@required String phoneNumber}) {
    if (phoneNumber == null) return;

    launch(
      'sms:$phoneNumber',
    );
  }

  phoneCall({@required String phoneNumber}) {
    if (phoneNumber == null) return;

    launch(
      'tel:$phoneNumber',
    );
  }

  launchURL({@required String url}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

}
