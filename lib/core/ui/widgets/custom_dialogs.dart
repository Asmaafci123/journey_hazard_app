import 'package:flutter/material.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/core/ui/styles/global_colors.dart';

class CustomDialogs {
  static void showTowButtonsDialog({
    @required BuildContext context,
    @required List<Widget> children,
    @required String firstButtonString,
    @required String secondButtonString,
    @required Function firstButtonFunction,
    @required Function secondButtonFunction,
    bool barrierDismissible = true,
  }) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context)  {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: children
                  ..addAll(<Widget>[
                    SizedBox(
                      height: ScreensHelper.fromHeight(3),
                    ),
                    Row(
                      textDirection: TextDirection.ltr,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: firstButtonFunction,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        ScreensHelper.fromWidth(1.5)),
                                    topLeft: Radius.circular(
                                        ScreensHelper.fromWidth(1.5)))),
                            width: ScreensHelper.fromWidth(30),
                            height: ScreensHelper.fromHeight(5),
                            child: Center(
                                child: Text(
                              firstButtonString,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreensHelper.scaleText(35)),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: secondButtonFunction,
                          child: Container(
                            decoration: BoxDecoration(
                                color: GlobalColors.primaryGreen,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(
                                        ScreensHelper.fromWidth(1.5)),
                                    topRight: Radius.circular(
                                        ScreensHelper.fromWidth(1.5)))),
                            width: ScreensHelper.fromWidth(30),
                            height: ScreensHelper.fromHeight(5),
                            child: Center(
                              child: Text(
                                secondButtonString,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreensHelper.scaleText(35)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
              ),
            );
          },
        );
  }
}
