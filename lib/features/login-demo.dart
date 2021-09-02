import 'package:journeyhazard/features/signup.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:journeyhazard/core/ui/widgets/loader_widget.dart';
import 'package:journeyhazard/core/services/navigation_service/navigation_service.dart';


class LoginDemoWidget extends StatefulWidget {
  @override
  static const routeName = 'LoginWidget';
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginDemoWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email;
  String _password;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(translator.currentLanguage);
    translator.setNewLanguage(
      context,
      newLanguage: 'en',
      remember: true,
      restart: false,
    );
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return  translator.translate('emailError');
    else
      return null;
  }
  String validatePassword(String value) {
    if (value.isEmpty)
      return  translator.translate('passwordError');
    else
      return null;
  }

  @override
  Widget  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/cemex.jpg')),
              ),
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                  children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child:
                    TextFormField(
                      decoration:  InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: translator.translate('email'),
                          hintText: translator.translate('emailHint')
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      onSaved: (String val) {
                        _email = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(
                      decoration:  InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: translator.translate('password'),
                          hintText: translator.translate('passwordHint')
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: validatePassword,
                      onSaved: (String val) {
                        _password = val;
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: (){
                      //TODO FORGOT PASSWORD SCREEN GOES HERE
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () {
                        LoaderWidget(
                          text: 'Loading Dashboard...',
                        );
//                        Navigator.push(
//                            context, MaterialPageRoute(builder: (_) => SignupWidget()));
//                      //  gNavigationService.pushNamed(SignupWidget.routeName);

                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  ]),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}

