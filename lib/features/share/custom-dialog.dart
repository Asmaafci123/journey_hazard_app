import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AdvanceCustomAlert extends StatelessWidget {
  final title;
  final message;
  final type;
  AdvanceCustomAlert(this.title, this.message, this.type);

  @override
  Widget  build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)
        ),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(title, style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      color: type ? Colors.lightGreen : Colors.red ,
                    ),),
                    Text(message, style: TextStyle(fontSize: 18),
                     maxLines: 3,),
            RaisedButton(onPressed: () {
              Navigator.of(context).pop();
            },
              color: type ? Colors.lightGreen : Colors.red ,
              child: Text(  (translator.currentLanguage == 'en')? 'Okay': 'تم', style: TextStyle(color: Colors.white),),
            )]),
              ),
            ),
            Positioned(
                top: -50,
                child: type ? CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  radius: 50,
                  child: Icon(Icons.assistant_photo, color: Colors.white, size: 50,),
                ): CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 50,
                  child: Icon(Icons.error, color: Colors.white, size: 50,),
                )
            ),
          ],
        )
    );
  }
}