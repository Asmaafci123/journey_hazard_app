import 'package:flutter/material.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';

import 'global_colors.dart';

class GlobalStyles {
  static TextStyle textFieldStyle = TextStyle(
      decorationThickness: 0,
      decorationColor: const Color(0xFF),
      fontSize: ScreensHelper.scaleText(36),
      height: ScreensHelper.fromHeight(0.14));
  static TextStyle defaultTextStyle = TextStyle(
      fontSize: ScreensHelper.scaleText(40),
      color: Colors.black87,
      fontFamily: 'Manjari');

  static InputDecoration pidgeInputDecoration(
      {@required labelText, Icon suffixIcon}) {
    return InputDecoration(
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ScreensHelper.fromWidth(1.5)),
          borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ScreensHelper.fromWidth(1.5)),
          borderSide: BorderSide(color: GlobalColors.primaryGreen)),
      fillColor: Color.fromRGBO(228, 237, 240, 1),
      filled: true,
      labelText: labelText,
      labelStyle: TextStyle(
          fontSize: ScreensHelper.scaleText(36),
          color: Color.fromRGBO(189, 189, 189, 1),
          fontFamily: 'Manjari'),
    );
  }
}
