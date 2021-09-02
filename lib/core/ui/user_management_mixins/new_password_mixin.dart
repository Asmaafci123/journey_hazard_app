//import 'package:doctor/core/localization/translations.dart';
//import 'package:doctor/core/ui/resources.dart';
//import 'package:doctor/core/utils/screen_utils/screen_utils.dart';
//import 'package:doctor/core/validators/base_validator.dart';
//import 'package:doctor/core/validators/min_length_validator.dart';
//import 'package:doctor/core/validators/required_validator.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//mixin NewPasswordFormMixin<T extends StatefulWidget> on State<T> {
//  bool triedToSubmit = false;
//  bool _validation = true;
//  final _key = new GlobalKey<FormFieldState<String>>();
//  final _controller = TextEditingController();
//  final FocusNode myFocusNewPasswordNode = FocusNode();
//  bool _passwordSecure = true;
//
//  buildNewPasswordFieldWithPadding() {
//    return Padding(
//      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
//      child: Column(
//        children: <Widget>[
//          buildNewPasswordField(),
//        ],
//      ),
//    );
//  }
//
//  TextFormField buildNewPasswordField() {
//    return TextFormField(
//      style: TextStyle(
//          decorationThickness: 0,
//          decorationColor: const Color(0xFF),
//          fontSize: 14,
//          height: ScreensHelper.fromHeight(0.17)),
//      key: _key,
//      controller: this._controller,
//      textInputAction: TextInputAction.go,
//      keyboardType: TextInputType.text,
//      focusNode: this.myFocusNewPasswordNode,
//      decoration: InputDecoration(
//          enabledBorder: OutlineInputBorder(
//              borderSide: BorderSide(
//            color: GlobalColors.greyHint,
//          )),
//          errorStyle: const TextStyle(height: 0.8),
//          border: OutlineInputBorder(),
//          isDense: true,
//          labelText: translate('new_password'),
//          labelStyle: GlobalStyles.textFieldStyle.copyWith(
//            color: GlobalColors.greyHint,
//          ),
//          suffixIcon: IconButton(
//              icon: Icon(
//                this._passwordSecure ? Icons.visibility : Icons.visibility_off,
//                color: GlobalColors.greyHint,
//              ),
//              onPressed: () {
//                setState(() {
//                  this._passwordSecure = !this._passwordSecure;
//                });
//              })),
//      validator: (value) {
//        return BaseValidator.validateValue(
//          context,
//          value,
//          [RequiredValidator(), MinLengthValidator(minLength: 8)],
//          _validation,
//        );
//      },
//      autovalidate: false,
//      onFieldSubmitted: (term) {
//        this.triedToSubmit = true;
//        setState(() {});
////        if (_userNameKey.currentState.validate()) {
////          if (_passwordKey.currentState.validate()) {
////            _bloc.add(
////              LoginEvent(context,
////                username: _userController.text,
////                password: _passwordController.text,
////                cancelToken: _loginCancelToken,
////              ),
////            );
////          }
////        }
//      },
//      onChanged: (value) {
//        if (!this.triedToSubmit) return;
//        _validation = true;
//        if (_key.currentState.validate()) {
//          setState(() {
//            _validation = false;
//          });
//        }
//      },
//      obscureText: _passwordSecure,
//    );
//  }
//
//  String getNewPasswordValue() {
//    return _controller.text;
//  }
//
//  bool validateNewPassword() {
//    return _key.currentState.validate();
//  }
//}
