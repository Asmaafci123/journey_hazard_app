import 'package:journeyhazard/core/errors/error_helper.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/core/services/navigation_service/navigation_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:journeyhazard/core/ui/styles/global_colors.dart';

class CustomSnackbar {
  static showSnackbar(BuildContext context, String message) {
    return Flushbar(
      backgroundColor: GlobalColors.primaryGreen,
      duration: Duration(
        seconds: 3,
      ),
      animationDuration: Duration(milliseconds: 500),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          LimitedBox(
            maxWidth: ScreensHelper.fromWidth(75),
            child: Text(
              message ?? '',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Icon(
            Icons.info_outline,
            color: Colors.white70,
          ),
        ],
      ),
    ).show(context);
  }

  static showErrorSnackbar(BuildContext context, dynamic error) {
    return Flushbar(
      backgroundColor: GlobalColors.primaryGreen,
      duration: Duration(
        seconds: 3,
      ),
      animationDuration: Duration(milliseconds: 500),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          LimitedBox(
            maxWidth: ScreensHelper.fromWidth(75),
            child: Text(
              ErrorHelper().getErrorMessage(error) ?? '',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Icon(
            Icons.info_outline,
            color: Colors.white70,
          ),
        ],
      ),
    ).show(context);
  }

  static showGuestSnackbar(BuildContext context) {
    return Flushbar(
      backgroundColor: GlobalColors.primaryBlue,
      duration: Duration(
        seconds: 3,
      ),
      animationDuration: Duration(milliseconds: 500),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          LimitedBox(
            maxWidth: ScreensHelper.fromWidth(75),
            child: Text(
              'You logged in as guest',
              style: TextStyle(color: Colors.white),
            ),
          ),
          InkWell(
              onTap: () {
//                gNavigationService.pushNamed(LoginPage.routeName);
              },
              child: Text(
                'Sign in',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              )),
        ],
      ),
    ).show(context);
  }
}
