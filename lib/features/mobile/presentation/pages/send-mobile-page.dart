import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:journeyhazard/core/constants.dart';
import 'package:journeyhazard/features/login/presentation/pages/login-page.dart';
import 'package:journeyhazard/features/mobile/data/models/country.dart';
import 'package:journeyhazard/features/mobile/data/models/language.dart';
import 'package:journeyhazard/features/mobile/presentation/bloc/mobile-bloc.dart';
import 'package:journeyhazard/features/mobile/presentation/bloc/mobile-events.dart';
import 'package:journeyhazard/features/mobile/presentation/bloc/mobile-state.dart';
import 'package:journeyhazard/features/share/loading-dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/login/presentation/bloc/login-events.dart';
import 'package:journeyhazard/features/login/presentation/bloc/login-state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:journeyhazard/features/trips/presentation/pages/trips.dart';

class SendMobileWidget extends StatefulWidget {
  static const routeName = ' SendMobileWidget';

  SendMobileWidgetState createState() => SendMobileWidgetState();
}

class SendMobileWidgetState extends State<SendMobileWidget> {
  SendMobileBloc _bloc = SendMobileBloc(BaseSendMobileState());
  TextEditingController mobileController = TextEditingController();
  UserModel user = new UserModel(
      mobile: '', country: '', supportNo: '000', company: 'Cement');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _clicked = false;
  CountryModel selectedCountry;
  List<CountryModel> countries = [];

  LanguageModel selectedLang;
  List<LanguageModel> languages = [
    LanguageModel(code: 'ar', lang: 'arabic'),
    LanguageModel(code: 'en', lang: 'english'),
    LanguageModel(code: 'fil', lang: 'filipino'),
    LanguageModel(code: 'hi', lang: 'hindi'),
    LanguageModel(code: 'ur', lang: 'urdu'),
    LanguageModel(code: 'es', lang: 'Spanish')
  ];

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');

  List<String> countryList = [];
  List<CountryModel> companies = [];

  @override
  void initState() {
//    print(translator.currentLanguage);
    super.initState();
    _bloc.add(GetCountriesEvent());
  }

// validate Mobile
  String validateMobile(String value) {
    if (value.isNotEmpty) {
      return RegExp(r'^01(0|1|2|5){1}[0-9]{8}$').hasMatch(value)
          ? null
          : translator.translate('required');
    }
    return null;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement  build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: MediaQuery.of(context).size.height - 40,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Center(
                          child: Container(
                              width: 200,
                              height: 100,
                              /*decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50.0)),*/
                              child: Image.asset('assets/images/cemex.jpg')),
                        ),
                      ),
                      BlocConsumer(
                          bloc: _bloc,
                          builder: (context, state) {
                            return Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25.0),
                                  child: InternationalPhoneNumberInput(
                                    spaceBetweenSelectorAndTextField: 0.0,
                                    onInputChanged: (PhoneNumber number) {
                                      this.user?.mobile =
                                          number.phoneNumber.toString();
                                      this.user?.country = countries
                                          .firstWhere((element) =>
                                              element.countryCode ==
                                              number.isoCode)
                                          .country;
                                      companies = countries
                                          .where((element) =>
                                              element.countryCode ==
                                              number.isoCode)
                                          .toList();
                                      print(companies);
                                      if (companies.length == 1) {
                                        selectedCountry = companies.first;
                                        this.user?.company =
                                            selectedCountry.company;
                                      } else {
                                        selectedCountry = null;
                                        this.user?.company = null;
                                      }
                                      _bloc.add(ChangeMobileEvent());
                                    },
                                    onInputValidated: (bool value) {
//                                          print(value);
                                    },
                                    selectorConfig: SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.DIALOG,
                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    selectorTextStyle:
                                        TextStyle(color: Colors.black),
                                    initialValue: number,
                                    textFieldController: controller,
                                    formatInput: false,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
//                                        inputBorder: OutlineInputBorder(),
                                    errorMessage:
                                        translator.translate('required'),
                                    onSaved: (PhoneNumber number) {
//                                          print('On Saved: $number');
                                    },
                                    countries: countries
                                        .map((e) => e.countryCode)
                                        .toList(),
                                    inputDecoration: InputDecoration(
                                      hintText: translator.translate('phone'),
                                    ),
                                    locale: translator.currentLanguage,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  child: DropdownButtonFormField<CountryModel>(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText:
                                          translator.translate('company'),
                                      contentPadding: EdgeInsets.only(
                                          top: 1.0, bottom: 0.0),
                                      labelStyle: TextStyle(
                                          fontFamily: FONT_FAMILY,
                                          fontWeight: FontWeight.w600),
                                      prefixIcon: const Icon(
                                        Icons.business_sharp,
                                      ),
                                    ),
                                    style: TextStyle(
                                        fontFamily: FONT_FAMILY,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey),
                                    validator: (value) => value == null
                                        ? translator.translate('required')
                                        : null,
                                    value: selectedCountry,
                                    isExpanded: true,
                                    onChanged: (CountryModel value) {
                                      selectedCountry = value;
                                      this.user?.company = value.company;
                                    },
                                    items:
                                        companies.map((CountryModel country) {
                                      return DropdownMenuItem<CountryModel>(
                                        value: country,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              country.company,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black45,
                                                  fontFamily: FONT_FAMILY),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
//                                    Padding(
//                                      padding: EdgeInsets.symmetric(vertical: 25),
//                                      child:
//                                      TextFormField(
//                                        decoration: InputDecoration(
//                                            border: OutlineInputBorder(),
//                                          labelText: translator.translate('phone'),
//                                          contentPadding: EdgeInsets.only(top: 1.0,bottom: 0.0),
//                                            labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),
//                                          prefixIcon: const Icon( Icons.mobile_friendly ,  ),
//
//                                        ),
//                                        inputFormatters: <TextInputFormatter>[
//                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                                        ],
//                                        style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.grey),
//                                        keyboardType: TextInputType.phone,
//                                        controller: mobileController,
//                                        validator: validateMobile,
//                                        onChanged: (String val) {
//                                          this.user?.mobile = mobileController.text.toString();
//                                        },
//                                      ),
//                                    ),
                                if (state is SendMobileFailedState)
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 5,
                                          bottom: 5),
                                      child: Align(
                                        child: Text(
                                          state.error.message,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: FONT_FAMILY,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        alignment: Alignment.centerRight,
                                      )),
                                Container(
                                  margin: EdgeInsets.only(top: 30),
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width - 40.0,
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      if (!_formKey.currentState.validate()) {
                                        return;
                                      }
                                      if (_formKey.currentState.validate()) {
//                                              print(this.user.toJson());
                                        _bloc.add(SendMobileEvent(
                                            userModel: this.user));
                                      }
                                    },
                                    child: Text(
                                      translator.translate('next'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: FONT_FAMILY,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    color: Colors.teal,
                                  ),
                                ),
                              ]),
                            );
                          },
                          listener: (context, state) {
                            if (state is SendMobileSuccessState) {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  TripsWidget.routeName,
                                  (Route<dynamic> route) => false,
                                  arguments: state.userData);
                            }
                            if (state is SendMobileFailedState)
                              Navigator.pop(context);
                            if (state is GetCountriesSuccessState) {
                              Navigator.pop(context);
                              countries = state.countries;
                              countryList =
                                  countries.map((e) => e.countryCode).toList();
                              //   final Map<String, CountryModel> jobSiteMap = new Map();
                              // countries.forEach((CountryModel item) {
                              //   jobSiteMap[item.company] = item;
                              // });
                              //
                              // companies = jobSiteMap.values.toList();
                              // print(companies);
                            }
                            if (state is SendMobileLoadingState) {
                              loadingAlertDialog(context);
                            }
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.privacy_tip,
                          color: Colors.blue,
                        ),
                        label: Text(
                          translator.translate('privacy'),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: FONT_FAMILY,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 150.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                            child: DropdownButtonFormField<LanguageModel>(
                              decoration: InputDecoration(
                                  hintText: translator.translate('lang'),
//                          contentPadding: EdgeInsets.only(top: 1.0,bottom: 0.0),
                                  hintStyle: TextStyle(
                                      fontFamily: FONT_FAMILY,
                                      fontWeight: FontWeight.w600),
                                  prefixIcon: const Icon(
                                    Icons.language,
                                    color: Colors.teal,
                                  ),
                                  border: InputBorder.none),
                              style: TextStyle(
                                  fontFamily: FONT_FAMILY,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45),
                              value: languages.firstWhere((element) =>
                                  element.code == translator.currentLanguage),
                              isExpanded: true,
                              onChanged: (LanguageModel value) {
                                selectedLang = value;
                                translator.setNewLanguage(
                                  context,
                                  newLanguage: value.code,
                                  remember: true,
                                  restart: true,
                                );
                              },
                              items: languages.map((LanguageModel lang) {
                                return DropdownMenuItem<LanguageModel>(
                                  value: lang,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        translator.translate(lang.lang),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                            fontFamily: FONT_FAMILY),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
