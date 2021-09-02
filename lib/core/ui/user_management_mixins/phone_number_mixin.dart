//import 'package:doctor/core/localization/translations.dart';
//import 'package:doctor/core/ui/resources.dart';
//import 'package:doctor/core/utils/screen_utils/screen_utils.dart';
//import 'package:doctor/core/validators/base_validator.dart';
//import 'package:doctor/core/validators/required_validator.dart';
//import 'package:doctor/core/validators/syrian_number_validator.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//mixin PhoneNumberFormMixin<T extends StatefulWidget> on State<T> {
//  bool triedToSubmit = false;
//  bool _phoneValidation = true;
//  final _key = new GlobalKey<FormFieldState<String>>();
//  final phoneController = TextEditingController();
//  final FocusNode myPhoneFocusNode = FocusNode();
//
//  buildPhoneFieldWithPadding() {
//    return Padding(
//      padding: EdgeInsets.only(top: ScreenUtil().setWidth(5)),
//      child: Padding(
//        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
//        child: buildPhoneField(),
//      ),
//    );
//  }
//
//  TextFormField buildPhoneField() {
//    return TextFormField(
//      style: TextStyle(decorationThickness: 0, decorationColor: const Color(0xFF), fontSize: 14,height: ScreensHelper.fromHeight(0.17)),
//      key: _key,
//      controller: phoneController,
//      focusNode: myPhoneFocusNode,
//      keyboardType: TextInputType.phone,
//      textInputAction: TextInputAction.next,
//      onEditingComplete: (){
//        print('KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK');
//      },onSaved: (c){
//      print('KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK');
//
//    },
//      decoration: InputDecoration(
//        enabledBorder: OutlineInputBorder(
//            borderSide: BorderSide(
//              color: GlobalColors.greyHint,
//            )),
//        border: OutlineInputBorder(),
//        isDense: true,
//        labelText: translate('phone_number'),labelStyle: GlobalStyles.textFieldStyle.copyWith(
//        color: GlobalColors.greyHint,
//      )
//      ),
//      validator: (value) {
//        return BaseValidator.validateValue(
//          context,
//          value,
//          [RequiredValidator(), SyrianNumberValidator()],
//          _phoneValidation,
//        );
//      },
//      autovalidate: false,
//      onChanged: (value) {
//        if (!this.triedToSubmit) return;
//        _phoneValidation = true;
//        if (_key.currentState.validate()) {
//          setState(() {
//            _phoneValidation = false;
//          });
//        }
//      },
//      onFieldSubmitted: (term) {
//        this.triedToSubmit = true;
//        setState(() {});
////        _fieldFocusChange(context, myFocusNodeUserName, myFocusNodePassword);
//      },
//    );
//  }
//
//  String getPhoneNumberValue() {
//    return _key.currentState.value;
//  }
//}
