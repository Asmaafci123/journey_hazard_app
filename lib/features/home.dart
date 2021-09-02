import 'package:journeyhazard/core/constants.dart';
import 'package:journeyhazard/features/trips/presentation/pages/trips.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'navigationDrawer/navigationDrawer.dart';

class HomeWidget extends StatefulWidget {
  static const routeName = 'HomeWidget';

  HomeWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<HomeWidget> {

  @override
  Widget  build(BuildContext context) {
    return Scaffold(
//      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text(translator.translate('homeTitle'),style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400)),
         centerTitle: true,

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          // Add your onPressed code here!
          String phone = '201003380442';
          var whatsappUrl ="whatsapp://send?phone=$phone&text=Hellothere!";
          await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");

        },
        icon: Icon(whatsapp),
        label: Text(translator.translate('question'),style: TextStyle(
          fontFamily: FONT_FAMILY,
          fontWeight: FontWeight.w400,
        )),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Container(
        width: double.infinity,
        alignment: AlignmentDirectional.center,
        padding: EdgeInsets.only(top:100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(child:
            Card(
              elevation: 5,
              child:Container(
                height: 150.0,
                width: 150.0,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_shipping,color: Colors.blue,size: 40,),
                      SizedBox(height: 10,),
                      Text(translator.translate('requestHeader'),
                          style: TextStyle(
                              fontFamily: FONT_FAMILY,
                              fontWeight: FontWeight.w400,
                          )),
                    ],
                  )
              ),

            ),
              onTap: () {
              },),

            InkWell(child:
            Card(
                elevation: 5,
                child:Container(
                  height: 150.0,
                  width: 150.0,

                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(Icons.place,color: Colors.blue,size: 40,),
                      SizedBox(height: 10,),
                    Text(translator.translate('locations'),style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400)),
                  ],
                  ),
                )
            ),
              onTap: () {
//                Navigator.pushNamed(context, LocationsWidget.routeName);
              },),
          ],
        ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(child:
                  Card(
                      elevation: 5,
                      child:Container(
                        height: 150.0,
                        width: 150.0,
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.featured_play_list,color: Colors.blue,size: 40,),
                            SizedBox(height: 10,),
                            Text(translator.translate('requestList'),style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400)),
                          ],
                        )
                      )),
                    onTap: () {
//                      Navigator.pushNamed(context, RequestListWidget.routeName);
                    },),
                  InkWell(
                    child:Card(
                        elevation: 5,
                        child:Container(
                          height: 150.0,
                          width: 150.0,
                          alignment: AlignmentDirectional.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map,color: Colors.blue,size: 40,),
                              SizedBox(height: 10,),
                              Text(translator.translate('truckMap'),style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400)),
                            ],
                          )                  ,)
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, TripsWidget.routeName);
                    },),
                ],
              )
        ]
      )
      ),
    );
  }
}