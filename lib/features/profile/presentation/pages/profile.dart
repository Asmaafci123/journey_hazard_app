//import 'package:journeyhazard/core/constants.dart';
//import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
//import 'package:journeyhazard/features/login/data/models/user.dart';
//import 'package:journeyhazard/features/login/presentation/pages/login-page.dart';
//import 'package:journeyhazard/features/navigationDrawer/navigationDrawer.dart';
//import 'package:journeyhazard/features/trips/presentation/pages/trips.dart';
//import 'package:flutter/material.dart';
//import 'package:localize_and_translate/localize_and_translate.dart';
//
//import '../../../home.dart';
//
//class ProfileWidget extends StatefulWidget {
//  static const routeName = 'ProfileWidget';
//  ProfileWidgetState createState() => ProfileWidgetState();
//}
//
//class ProfileWidgetState extends State<ProfileWidget> {
//  String currentLanguage = translator.currentLanguage;
//  final List<Map<String, String>> languages = [
//    {'name': 'arabic', 'value': 'ar'},
//    {'name': 'english', 'value': 'en'}
//  ];
//  UserModel userModel = new UserModel();
//  String firstLetter = 'A';
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    currentUser();
//    super.initState();
//  }
//
//  void choiceLanguage(lang) {
//    translator.setNewLanguage(
//      context,
//      newLanguage: lang,
//      remember: true,
//      restart: true,
//    );
//  }
//
//  currentUser() async {
//    var data = await DBHelper.getData('cemex_user');
//    print(data);
//    setState(() {
//      if (data.length > 0){
//        userModel = UserModel.fromSqlJson(data[0]);
//        print(userModel);
//        firstLetter =  userModel.userName.substring(0,1).toUpperCase();
//      }
//    });
//  }
//
//  @override
//  Widget  build(BuildContext context) {
//    // TODO: implement  build
//    return Scaffold(
//        appBar: AppBar(
//          title: Text(translator.translate('myAccount'),
//              style: TextStyle(
//                  fontFamily: FONT_FAMILY, fontWeight: FontWeight.w400)),
//          centerTitle: true,
//        ),
//        body: SingleChildScrollView(
//            child: SafeArea(
//          child: Column(
//            children: [
//              Container(
//                decoration: BoxDecoration(
////                  color: Colors.blue,
//                    image: DecorationImage(
//                        image: AssetImage(SHHNATY_BACK_GROUND),
//                        fit: BoxFit.cover)),
//                child: Container(
//                  width: double.infinity,
//                  height: 170,
//                  child: Container(
//                    alignment: Alignment.center,
//                    child: Column(children: [
//                      SizedBox(
//                        height: 15,
//                      ),
//                      CircleAvatar(
//                        backgroundColor: Colors.grey,
////                      backgroundImage: AssetImage(SHHNATY_BACK_GROUND),
//                        radius: 60.0,
//                        child: Text(firstLetter,
//                          style: TextStyle(fontSize: 40.0),
//                        ),
//                      ),
//                      SizedBox(
//                        height: 5,
//                      ),
//                      // userName
//                      Text('${userModel.userName} ',
//                        style: TextStyle(
//                            fontSize: 18.0,
//                            color: Colors.white,
//                            letterSpacing: 2.0,
//                            fontWeight: FontWeight.w400),
//                      ),
//                      SizedBox(
//                        height: 5,
//                      ),
//                      //userEmail
//                    ]),
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 10,
//              ),
//              Align(
//                child: Card(
//                    margin:
//                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//                    elevation: 2.0,
//                    child: Padding(
//                        padding:
//                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//                        child: Container(
//                            width: 170,
//                            child: Row(
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: [
//                                  Icon(
//                                    Icons.star,
//                                    color: Colors.yellowAccent,
//                                  ),
//                                  SizedBox(
//                                    width: 7,
//                                  ),
//                                  Text(
//                                      translator.translate('companyDetails'),
//                                    style: TextStyle(
//                                        letterSpacing: 2.0,
//                                        fontWeight: FontWeight.w300),
//                                  )
//                                ])))),
//                alignment:  currentLanguage != 'en'
//                    ? Alignment.centerRight : Alignment.centerLeft,
//              ),
//              Card(
//                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
//                child: Padding(
//                  padding: const EdgeInsets.all(10.0),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: [
//                      Row(
//                        children: [
//                          Icon(
//                            Icons.label,
//                            color: Colors.grey,
//                          ),
//                          SizedBox(
//                            width: 7,
//                          ),
//                          Text('${userModel.companyName} ',
//                            style: TextStyle(
//                              color: Colors.blue,
//                              fontSize: 20.0,
//                              fontFamily: FONT_FAMILY,
//                              fontWeight: FontWeight.w400,
//                            ),
//                          )
//                        ],
//                      ),
//                      Row(
//                        children: [
//                        RotatedBox( quarterTurns: (translator.currentLanguage == 'en' ) ? 0 : 3,
//                            child:Icon(
//                            Icons.call,
//                            color: Colors.green,
//                          )),
//                          SizedBox(
//                            width: 7,
//                          ),
//                          Text('${userModel.companyPhone} ',
//                            style: TextStyle(
//                              color: Colors.blueGrey,
//                              fontSize: 18.0,
//                              fontFamily: FONT_FAMILY,
//                              fontWeight: FontWeight.w400,
//                            ),
//                          )
//                        ],
//                      ),
//                      Row(
//                        children: [
//                          Icon(
//                            Icons.whatshot,
//                            color: Colors.orange,
//                          ),
//                          SizedBox(
//                            width: 7,
//                          ),
//                          Text('${userModel.industry} ',
//                            style: TextStyle(
//                              color: Colors.blueGrey,
//                              fontSize: 18.0,
//                              fontFamily: FONT_FAMILY,
//                              fontWeight: FontWeight.w400,
//                            ),
//                          )
//                        ],
//                      ),
//                      Row(
//                        children: [
//                          Icon(
//                            Icons.home,
//                            color: Colors.grey,
//                          ),
//                          SizedBox(
//                            width: 7,
//                          ),
//                          Text('${userModel.companyAddress} ',
//                            style: TextStyle(
//                              color: Colors.blueGrey,
//                              fontSize: 18.0,
//                              fontFamily: FONT_FAMILY,
//                              fontWeight: FontWeight.w400,
//                            ),
//                          )
//                        ],
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 15,
//              ),
//              Align(
//                child: Card(
//                    margin:
//                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//                    elevation: 2.0,
//                    child: Padding(
//                        padding:
//                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//                        child: Container(
//                            width: 170,
//                            child: Row(
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: [
//                                  Icon(
//                                    Icons.person,
//                                    color: Colors.blue,
//                                  ),
//                                  SizedBox(
//                                    width: 7,
//                                  ),
//                                  Text(translator.translate('personal'),
//                                    style: TextStyle(
//                                        letterSpacing: 2.0,
//                                        fontWeight: FontWeight.w300),
//                                  )
//                                ])))),
//                alignment:  currentLanguage != 'en'
//                    ? Alignment.centerRight : Alignment.centerLeft,
//              ),
//              Card(
//                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
//                child: Padding(
//                  padding: const EdgeInsets.all(10.0),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: [
//                      Row(
//                        children: [
//                          Icon(
//                            Icons.label,
//                            color: Colors.grey,
//                          ),
//                          SizedBox(
//                            width: 7,
//                          ),
//                          Text('${userModel.companyName} ',
//                            style: TextStyle(
//                                fontSize: 18.0,
//                                color: Colors.blueGrey,
//                                fontWeight: FontWeight.w400),
//                          )
//                        ],
//                      ),
//                      Row(
//                        children: [
//                          Icon(
//                            Icons.email,
//                            color: Colors.orange,
//                          ),
//                          SizedBox(
//                            width: 7,
//                          ),
//                          Text(
//                            "${userModel.userName}",
//                            style: TextStyle(
//                                fontSize: 18.0,
//                                color: Colors.blueGrey,
//                                fontWeight: FontWeight.w400),
//                          ),
//                        ],
//                      ),
//                      Row(
//                        children: [
//                          RotatedBox( quarterTurns: (translator.currentLanguage == 'en' ) ? 0 : 3,
//                              child:Icon(
//                                Icons.call,
//                                color: Colors.green,
//                              )),
//                          SizedBox(
//                            width: 7,
//                          ),
//                          Text('${userModel.contactPhone} ',
//                            style: TextStyle(
//                              color: Colors.blueGrey,
//                              fontSize: 18.0,
//                              fontFamily: FONT_FAMILY,
//                              fontWeight: FontWeight.w400,
//                            ),
//                          )
//                        ],
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 15,
//              ),
//              Align(
//                child: Card(
//                    margin:
//                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//                    elevation: 2.0,
//                    child: Padding(
//                        padding:
//                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//                        child: Container(
//                            width: 170,
//                            child: Row(
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: [
//                                  Icon(
//                                    Icons.settings,
//                                    color: Colors.grey,
//                                  ),
//                                  SizedBox(
//                                    width: 7,
//                                  ),
//                                  Text(translator.translate('settings'),
//                                    style: TextStyle(
//                                        letterSpacing: 2.0,
//                                        fontWeight: FontWeight.w300),
//                                  )
//                                ])))),
//                alignment:  currentLanguage != 'en'
//                    ? Alignment.centerRight : Alignment.centerLeft,
//              ),
//              Card(
//                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
//                child: Padding(
//                  padding: const EdgeInsets.all(10.0),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: [
//                      Row(
//                        children: [
//                          Expanded(
//                            flex: 2,
//                            child: Row(children: [
//                              Icon(
//                                Icons.language,
//                                color: Colors.grey,
//                              ),
//                              SizedBox(
//                                width: 7,
//                              ),
//                              Text(
//                                currentLanguage != 'en'
//                                    ? translator.translate('arabic')
//                                    : translator.translate('english'),
//                                style: TextStyle(
//                                    fontSize: 18.0,
//                                    color: Colors.blueGrey,
//                                    fontWeight: FontWeight.w400),
//                              ),
//                            ]),
//                          ),
//                          Expanded(
//                            child: PopupMenuButton<String>(
//                              child: Text(translator.translate('language'),
//                                  style: TextStyle(
//                                    color: Colors.blue,
//                                    fontFamily: FONT_FAMILY,
//                                    fontWeight: FontWeight.w400,
//                                  )),
//                              onSelected: choiceLanguage,
//                              initialValue: currentLanguage,
//                              itemBuilder: (BuildContext context) {
//                                return languages
//                                    .map((Map<String, String> lang) {
//                                  return PopupMenuItem<String>(
//                                    value: lang['value'],
//                                    child:
//                                        Text(translator.translate(lang['name']),
//                                            style: TextStyle(
//                                              fontFamily: FONT_FAMILY,
//                                              fontWeight: FontWeight.w400,
//                                            )),
//                                  );
//                                }).toList();
//                              },
//                            ),
//                          ),
//                        ],
//                      ),
//                      SizedBox(
//                        height: 5,
//                      ),
//                      InkWell(
//                          child: Row(children: [
//                            Icon(
//                              Icons.logout,
//                              color: Colors.red,
//                            ),
//                            Text(translator.translate('logout'),
//                                style: TextStyle(
//                                    fontFamily: FONT_FAMILY,
//                                    fontSize: 18.0,
//                                    color: Colors.blueGrey,
//                                    fontWeight: FontWeight.w400)),
//                          ]),
//                          onTap: () {
//                            DBHelper.deleteUser(userModel.id);
//                            Navigator.pop(context);
//                            Navigator.of(context).pushNamedAndRemoveUntil(LoginWidget.routeName, (Route<dynamic> route) => false);
//
//                          })
//                    ],
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 10,
//              ),
//            ],
//          ),
//        )));
//  }
//}
