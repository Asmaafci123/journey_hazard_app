import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/core/ui/styles/global_colors.dart';
import 'package:journeyhazard/core/ui/styles/global_styles.dart';
import 'package:journeyhazard/core/validators/base_validator.dart';
import 'package:journeyhazard/core/validators/match_validator.dart';
import 'package:journeyhazard/core/validators/min_length_validator.dart';
import 'package:journeyhazard/core/validators/required_validator.dart';

import '../../constants.dart';

mixin ConfirmPasswordFormMixin<T extends StatefulWidget> on State<T> {
  bool triedToSubmit = false;
  bool _validation = true;
  final _key = new GlobalKey<FormFieldState<String>>();
  final _controller = TextEditingController();
  final FocusNode myFocusConfirmPasswordNode = FocusNode();
  bool _confirmPasswordSecure = true;

  TextFormField buildConfirmPasswordField(String password,
      {FocusNode nextFocusNode,
      Function onSubmitFunction,
      TextInputAction textInputAction}) {
    return TextFormField(
      style: GlobalStyles.textFieldStyle,
      key: _key,
      controller: this._controller,
      textInputAction: textInputAction ??
          (onSubmitFunction != null
              ? TextInputAction.go
              : TextInputAction.next),
      keyboardType: TextInputType.text,
      focusNode: this.myFocusConfirmPasswordNode,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreensHelper.fromWidth(1.5)),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreensHelper.fromWidth(1.5)),
              borderSide: BorderSide(color: GlobalColors.primaryGreen)),
          fillColor: Color.fromRGBO(228, 237, 240, 1),
          filled: true,
          labelText: 'Confirm Password',
          labelStyle: TextStyle(
              fontSize: ScreensHelper.scaleText(36),
              color: Color.fromRGBO(189, 189, 189, 1),
              fontFamily: 'Manjari'),
          suffixIcon: IconButton(
              icon: Icon(
                _confirmPasswordSecure
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: GlobalColors.greyHint,
              ),
              onPressed: () {
                setState(() {
                  _confirmPasswordSecure = !_confirmPasswordSecure;
                });
              })),
      validator: (value) {
        return BaseValidator.validateValue(
          context,
          value,
          [
            RequiredValidator(),
            MinLengthValidator(minLength: MIN_PASSWORD_LENGTH),
            MatchValidator(value: password)
          ],
          _validation,
        );
      },
      onFieldSubmitted: (term) {
        this.triedToSubmit = true;
        setState(() {});
        if (nextFocusNode != null) {
          nextFocusNode.requestFocus();
        }

        if (nextFocusNode == null && onSubmitFunction != null) {
          onSubmitFunction();
        }
      },
      onChanged: (value) {
        if (!this.triedToSubmit) return;
        _validation = true;
        if (_key.currentState.validate()) {
          setState(() {
            _validation = false;
          });
        }
      },
      obscureText: this._confirmPasswordSecure,
    );
  }

  String getConfirmPasswordValue() {
    return _controller.text;
  }

  bool validateConfirmPassword() {
    return _key.currentState.validate();
  }
}
