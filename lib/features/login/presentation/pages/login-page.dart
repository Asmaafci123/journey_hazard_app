import 'dart:ui';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:journeyhazard/core/constants.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/features/mobile/presentation/pages/send-mobile-page.dart';
import 'package:journeyhazard/features/share/loading-dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/login/presentation/bloc/login-bloc.dart';
import 'package:journeyhazard/features/login/presentation/bloc/login-events.dart';
import 'package:journeyhazard/features/login/presentation/bloc/login-state.dart';
import 'package:journeyhazard/core/ui/widgets/loader_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:journeyhazard/features/trips/presentation/pages/trips.dart';

class LoginWidget extends StatefulWidget {
  static const routeName = 'LoginWidget';

  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  LoginBloc _bloc;
  TextEditingController shipmentIdController = TextEditingController();
  UserModel user = new UserModel(shipmentId: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _bloc = LoginBloc(BaseLoginState());
//    print(translator.currentLanguage);

    super.initState();
  }

//   validate Password
  String validateString(String value) {
    if (value.isEmpty)
      return translator.translate('passwordError');
    else
      return null;
  }

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#FF7F00", translator.translate('canceled'), true, ScanMode.QR)
        .then((value) {
      if (value.isNotEmpty || value == -1 || value == null) {
        return;
      }
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(translator.translate('sendData'))));
      this.user?.shipmentId = value.toString();
      _bloc.add(LoginEvent(userModel: this.user));
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                  child: Center(
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                            fontSize: 45,
                          ),
                        )),
                  ),
                ),
                BlocConsumer(
                    bloc: _bloc,
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: translator.translate('shipmentNo'),
                                hintText: translator.translate('shipmentNo'),
                                labelStyle: TextStyle(
                                    fontFamily: FONT_FAMILY,
                                    fontWeight: FontWeight.w600)),
                            style: TextStyle(
                                fontFamily: FONT_FAMILY,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                            keyboardType: TextInputType.text,
                            controller: shipmentIdController,
                            validator: validateString,
                            onChanged: (String val) {
                              this.user?.shipmentId =
                                  shipmentIdController.text.toString();
                            },
                          ),
                          if (state is LoginFailedState)
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 5, bottom: 5),
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
                            margin: EdgeInsets.only(top: 45),
                            height: 50,
                            width: MediaQuery.of(context).size.width - 30.0,
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
                                  _bloc.add(LoginEvent(userModel: this.user));
                                }
                              },
                              child: Text(
                                translator.translate('login'),
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
                      if (state is LoginSuccessState) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            TripsWidget.routeName,
                            (Route<dynamic> route) => false,
                            arguments: state.userData);
                      }
                      if (state is LoginFailedState) Navigator.pop(context);
                      if (state is LoginLoadingState)
                        loadingAlertDialog(context);
                    }),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 3.0, right: 3.0, top: 3, bottom: 3),
                    child: Align(
                      child: FlatButton(
                        onPressed: () {},
                        child: Text(
                          translator.translate('qrcodeText'),
                          style: TextStyle(
                              fontFamily: FONT_FAMILY,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                    )),
                Center(
                    child: InkWell(
                  child: Image.asset(
                    'assets/images/qrcode.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  onTap: _scan,
                )),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
