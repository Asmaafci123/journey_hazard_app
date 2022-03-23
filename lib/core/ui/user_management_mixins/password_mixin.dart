import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:journeyhazard/core/constants.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/core/ui/styles/global_colors.dart';
import 'package:journeyhazard/core/ui/styles/global_styles.dart';
import 'package:journeyhazard/core/validators/base_validator.dart';
import 'package:journeyhazard/core/validators/min_length_validator.dart';
import 'package:journeyhazard/core/validators/required_validator.dart';

mixin PasswordFormMixin<T extends StatefulWidget> on State<T> {
  bool triedToSubmit = false;
  bool _validation = true;
  final _key = new GlobalKey<FormFieldState<String>>();
  final passwordController = TextEditingController();
  final FocusNode myFocusPasswordNode = FocusNode();
  bool _passwordSecure = true;

  TextFormField buildPasswordField(
      {FocusNode nextFocusNode,
      Function onSubmitFunction,
      TextInputAction textInputAction}) {
    return TextFormField(
      style: GlobalStyles.textFieldStyle,
      key: _key,
      controller: this.passwordController,
      textInputAction: textInputAction ??
          (onSubmitFunction != null
              ? TextInputAction.go
              : TextInputAction.next),
      keyboardType: TextInputType.text,
      focusNode: this.myFocusPasswordNode,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreensHelper.fromWidth(1.5)),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreensHelper.fromWidth(1.5)),
              borderSide: BorderSide(color: GlobalColors.primaryGreen)),
          fillColor: Color.fromRGBO(228, 237, 240, 1),
          filled: true,
          labelText: 'Password',
          labelStyle: TextStyle(
              fontSize: ScreensHelper.scaleText(36),
              color: Color.fromRGBO(189, 189, 189, 1),
              fontFamily: 'Manjari'),
          suffixIcon: IconButton(
              icon: Icon(
                _passwordSecure ? Icons.visibility : Icons.visibility_off,
                color: GlobalColors.greyHint,
              ),
              onPressed: () {
                setState(() {
                  _passwordSecure = !_passwordSecure;
                });
              })),
      validator: (value) {
        return BaseValidator.validateValue(
          context,
          value,
          [
            RequiredValidator(),
            MinLengthValidator(minLength: MIN_PASSWORD_LENGTH)
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
      obscureText: _passwordSecure,
    );
  }

  String getPasswordValue() {
    return passwordController.text;
  }

  bool validatePassword() {
    this.triedToSubmit = true;
    setState(() {});
    return _key.currentState.validate();
  }
}
