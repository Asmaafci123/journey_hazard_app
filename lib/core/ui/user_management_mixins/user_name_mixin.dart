import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/core/ui/styles/global_styles.dart';
import 'package:journeyhazard/core/validators/base_validator.dart';
import 'package:journeyhazard/core/validators/required_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin UserNameFormMixin<T extends StatefulWidget> on State<T> {
  bool triedToSubmit = false;
  bool _validation = true;
  final _key = new GlobalKey<FormFieldState<String>>();
  final _controller = TextEditingController();
  final FocusNode myFocusUserNameNode = FocusNode();

  TextFormField buildUserNameField(
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
      focusNode: this.myFocusUserNameNode,
      decoration: GlobalStyles.pidgeInputDecoration(labelText: 'User Name'),
      validator: (value) {
        return BaseValidator.validateValue(
          context,
          value,
          [RequiredValidator()],
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
    );
  }

  String getUserNameValue() {
    return _controller.text;
  }

  bool validateName() {
    return _key.currentState.validate();
  }
}
