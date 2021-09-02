import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

loadingAlertDialog(BuildContext context){
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return  AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 5),child:Text(translator.translate('loading'))),
          ],),
      );
    },
  );
}