// import 'dart:async';
// import 'dart:math';
// import 'dart:ui';
// import 'dart:io' show Platform;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_animarker/core/ripple_marker.dart';
// import 'package:flutter_animarker/widgets/animarker.dart';
// import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
// import 'package:journeyhazard/features/login/data/models/user.dart';
// import 'package:journeyhazard/features/login/presentation/pages/login-page.dart';
// import 'package:journeyhazard/features/share/loading-dialog.dart';
// import 'package:journeyhazard/features/trips/data/models/risk.dart';
// import 'package:journeyhazard/features/trips/presentation/bloc/trip-bloc.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:journeyhazard/core/constants.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:journeyhazard/features/trips/presentation/bloc/trip-events.dart';
// import 'package:journeyhazard/features/trips/presentation/bloc/trip-state.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
//
// class TripsWidget extends StatefulWidget {
//   static const routeName = 'TripsWidget';
//
//   TripsWidgetState createState() => TripsWidgetState();
// }
// enum TtsState { playing, stopped, paused, continued }
//
// class TripsWidgetState extends State<TripsWidget> {
//   Completer<GoogleMapController> _controller = Completer();
//   TripBloc _bloc = TripBloc(BaseTripState());
//   FlutterTts flutterTts;
//
//   LatLng _center = LatLng(27.167928, 31.196732);
//   LatLng _lastMapPosition =  LatLng(27.2134, 31.4456);
//   MapType _currentMapType = MapType.normal;
//   // Position currentLocation;
//   final double cameraZoom = 16;
//   final double cameraTilt = 80;
//   final double cameraBearing = 30;
//
//
// // the user's initial location and current location
// // as it moves
//   Position currentLocation;
// // a reference to the destination location
//   Position destinationLocation;
// // wrapper around the location API
//   Position location;
//
//   CameraPosition _cameraPosition;
//   bool addEnable = true;
//   bool removeEnable = true;
//
//   Map<MarkerId, Marker> markers = {};
// //  Set<Marker> markers = {};
//
//   Map<MarkerId, Marker> markersRed = <MarkerId, Marker>{};
//
//   String googleAPiKey = MAP_API_KEY;
//   List<RiskModel> allLocations = [];
//   List<RiskModel> noTrip = [];
//   RiskModel currentTrip = new RiskModel();
//
//   bool showInfo = false;
//   BitmapDescriptor bitmapDescriptorRed;
//   BitmapDescriptor bitmapDescriptorGreen;
//   BitmapDescriptor bitmapDescriptorBlue;
//   UserModel userData;
//
//   TtsState ttsState = TtsState.stopped;
//
//   get isPlaying => ttsState == TtsState.playing;
//   get isStopped => ttsState == TtsState.stopped;
//   get isPaused => ttsState == TtsState.paused;
//   get isContinued => ttsState == TtsState.continued;
//
//   StreamSubscription<Position> positionStream ;
//
//   String resultText = "";
//
//
//   void _onMapCreated(GoogleMapController controller)  {
//     //print("enter");
//     _controller.complete(controller);
//     //print(_controller.isCompleted);
//     _controller.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition)));
//   }
//
//   getUser() async {
//     final driverDataDB =  await DBHelper.getData('driver_data');
//     if(driverDataDB.isNotEmpty) userData=  UserModel.fromJson(driverDataDB.first);
//   }
// //  Sound Init
//   initializeTts() {
//     flutterTts = FlutterTts();
//     flutterTts.setStartHandler(() {
//       setState(() {
//         //print("Playing");
//         ttsState = TtsState.playing;
//       });
//     });
//
//     flutterTts.setCompletionHandler(() {
//       //print("Complete");
//       ttsState = TtsState.stopped;
//     });
//
//     flutterTts.setCancelHandler(() {
//       //print("Cancel");
//       ttsState = TtsState.stopped;
//     });
//     flutterTts.setErrorHandler((msg) {
//       //print("error: $msg");
//       ttsState = TtsState.stopped;
//     });
//
//     var lang = translator.currentLanguage == 'fil' ? 'fil-PH' : translator.currentLanguage;
//     //print(lang);
//     flutterTts.setLanguage(lang);
//     flutterTts.setVolume(1);
//     flutterTts.setSpeechRate(1);
//     flutterTts.setPitch(1);
//   }
//
//
//   initData() async {
//     // bitmapDescriptorGreen = await MarkerGenerator(200)
//     //     .createBitmapDescriptorFromIconData(Icons.flag, Colors.grey, Colors.transparent, Colors.transparent);
//     // bitmapDescriptorRed = await MarkerGenerator(200)
//     //     .createBitmapDescriptorFromIconData(Icons.flag, Colors.red, Colors.transparent, Colors.transparent);
//     // bitmapDescriptorBlue = await MarkerGenerator(150)
//     //     .createBitmapDescriptorFromIconData(Icons.local_shipping, Colors.blue, Colors.transparent, Colors.transparent);
//     bitmapDescriptorRed =  await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0 ), 'assets/images/flag.png',mipmaps: true);
//
//     bitmapDescriptorBlue = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0), 'assets/images/truck.png');
//   }
//
//   Future getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     //print(permission);
//     if (permission != PermissionStatus.granted) {
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission != PermissionStatus.granted)
//         getLocation();
//       return;
//     }
//     getLocation();
//   }
//
//   getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     //print(position.latitude);
//     //print('lat position${position?.latitude}, ${position?.longitude}');
//     setState(() {
//       _center = new LatLng(position.latitude, position.longitude);
//       _cameraPosition = CameraPosition(target:_center,zoom: 14 );
//       currentLocation = position;
//       if(_controller != null)
//         _controller.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition)));
//       markers[MarkerId('me')] = Marker(
//         markerId: MarkerId('me'),
//         position: _center,
//         icon: bitmapDescriptorBlue,
//       );
//       _bloc.add(GetTripEvent());
//     });
//   }
//
//   getUserLocation() async {
//     currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     if(currentLocation != null) {
//       _center = LatLng(currentLocation?.latitude, currentLocation?.longitude);
//       _cameraPosition = CameraPosition(target:_center,zoom: 14, bearing: 15.0,
//         tilt: 75.0, );
//       _controller.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition)));
//     }
//   }
//
//   addNewHazar() {
//     _bloc.add(AddHazarEvent());
//   }
//
//   removeHazar() async {
//     removeEnable = false;
//     _bloc.add(RemoveHazarEvent(risk: currentTrip));
//   }
//
//   completeShipment() {
//     _bloc.add(CompleteTripEvent());
//
//   }
//
//   startShipment() {
//     _bloc.add(StartTripEvent());
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getUser();
//     _cameraPosition = CameraPosition(target: _center, zoom: 11.0, tilt: 0, bearing: 0);
//     initData();
//     initializeTts();
//     getCurrentLocation();
//     positionStream = Geolocator.getPositionStream(distanceFilter: 500).listen(
//             (Position position) {
//           print(position);
//           if(position != null) {
//             setState(() {
//               currentLocation = position;
//               _center = LatLng(currentLocation?.latitude, currentLocation?.longitude);
//             });
//           }
//           _bloc.add(GetTripEvent());
//         });
//   }
//
//   /////////////////
//   Future _speak(_newVoiceText) async {
//     if (_newVoiceText != null) {
//       if (_newVoiceText.isNotEmpty) {
//         await flutterTts.awaitSpeakCompletion(true);
//         await flutterTts.speak(_newVoiceText);
//       }
//     }
//   }
//
//   show({String message, String title ,bool flag}) {
//     AlertDialog alert = AlertDialog(
//       title: Center(child: Text( translator.translate(title),style: TextStyle(fontSize: 20 ,fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600, color: flag? Colors.green : Colors.red),)),
//       content: Text(translator.translate(message), style: TextStyle(fontSize: 16,fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//       ),
//       contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
//     );
//     showDialog( context: context,
//       builder: (BuildContext context) {
//         Future.delayed(Duration(seconds: 5),(){
//           Navigator.of(context).pop();
//         });
//         return  alert;
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _bloc.close();
//     positionStream.cancel();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   moveCamera() async{
//     _controller.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 14.0,))));
//   }
//
//   _launchCaller() {
//     _bloc.add(SupportMobileEvent());
//   }
//
//   _callSupport (mobile) async{
//     final url = "tel:$mobile";
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   void choiceAction(RiskModel risk) async{
//     //print("chose: $risk");
//     removeEnable = true;
//     var riskText = (translator.currentLanguage == 'en')? risk.riskEn : risk.riskAr;
//     _controller.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       target: LatLng(double.parse(risk.lat), double.parse(risk.long)),
//       zoom: 18.0,))));
//     _speak(riskText);
//     currentTrip = risk;
//     showInfo = true;
//     Future.delayed(const Duration(seconds: 30), () async {
//       //print("Duration(seconds: 30)$markersRed");
//       showInfo=false;
//       markersRed.clear();
//       markersRed[MarkerId(risk.riskId.toString())] = Marker(
//         markerId: MarkerId(risk.riskId.toString()),
//         position: LatLng(double.parse(risk.lat), double.parse(risk.long)),
//         visible: false,
//         infoWindow: InfoWindow(
//             title: risk.riskAr,
//             snippet: risk.riskAr
//         ),
//         icon: bitmapDescriptorGreen,
//         onTap: () {},
//       );
//       _bloc.add(DoneHazarEvent(risk: risk));
//       await getUserLocation();
//
//     });
//
//   }
//
//   @override
//   Widget  build(BuildContext context) {
//     CameraPosition initialCameraPosition = CameraPosition(
//         zoom: cameraZoom,
//         tilt: cameraTilt,
//         bearing: cameraBearing,
//         target: _center
//     );
//     if (currentLocation != null) {
//       initialCameraPosition = CameraPosition(
//         target: LatLng(currentLocation.latitude, currentLocation.longitude),
//         zoom: cameraZoom,
//         tilt: cameraTilt,
//         bearing: cameraBearing,
//       );
//     }
//     return  Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Container(
//           child: BlocConsumer(
//               bloc: _bloc,
//               builder: (context, state) {
//                 return Stack(
//                   children: <Widget>[
//                     Animarker(
//                       mapId: _controller.future.then((value) => value.mapId), //Grab Google Map Id
//                       rippleRadius: 0.5,  //[0,1.0] range, how big is the circle
//                       rippleColor: Colors.red, // Color of fade ripple circle
//                       rippleDuration: Duration(milliseconds: 3000), //Pulse ripple duration
//                       markers: Set<Marker>.of(markersRed.values),
//                       child: GoogleMap(
//                         onMapCreated: _onMapCreated,
//                         markers: markers.values.toSet(),
//                         initialCameraPosition: initialCameraPosition,
//                         // CameraPosition(
//                         //   target: _center,
//                         //   zoom: 14,
//                         // ),
//                         indoorViewEnabled: true,
//                         trafficEnabled: true,
//                         mapType: _currentMapType,
//                         myLocationEnabled: true,
//                         tiltGesturesEnabled: true,
//                         compassEnabled: true,
//                         rotateGesturesEnabled: true,
//                         scrollGesturesEnabled: true,
//                         zoomGesturesEnabled: true,
//                         zoomControlsEnabled: true,
//                         gestureRecognizers: Set()
//                           ..add(Factory<PanGestureRecognizer>(() =>
//                               PanGestureRecognizer()))..add(
//                               Factory<ScaleGestureRecognizer>(() =>
//                                   ScaleGestureRecognizer()))..add(
//                               Factory<TapGestureRecognizer>(() =>
//                                   TapGestureRecognizer()))..add(
//                               Factory<VerticalDragGestureRecognizer>(() =>
//                                   VerticalDragGestureRecognizer()))..add(
//                               Factory<HorizontalDragGestureRecognizer>(() =>
//                                   HorizontalDragGestureRecognizer())),
//                       ),
//                       // Other properties
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(top: 5),
//                       padding: EdgeInsets.all(5),
//                       height: 60,
//                       alignment: AlignmentDirectional.topCenter,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           (userData != null)? (userData?.shipmentId != null) ? Expanded(
//                               child: Material(
//                                   elevation: 5,
//                                   borderRadius: BorderRadius.circular(4),
//                                   color: Colors.green,
//                                   child: InkWell(
//                                       borderRadius: BorderRadius.circular(4),
//                                       radius: 25,
//                                       onTap: startShipment,
//                                       splashColor: Colors.lightGreen.withOpacity(0.6),
//                                       highlightColor: Colors.lightGreen.withOpacity(0.6),
//                                       child: Container(
//                                         child:
//                                         TextButton.icon(onPressed: completeShipment,
//                                           icon: Icon(Icons.done_all,color: Colors.white,)
//                                           ,label: Text(translator.translate('endTrip'),
//                                             style: TextStyle(color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//                                           ),
//                                         ),
//                                       ))
//                               )
//                           ) : Expanded(
//                               child: Material(
//                                   elevation: 5,
//                                   borderRadius: BorderRadius.circular(4),
//                                   color: Colors.orange,
//                                   child: InkWell(
//                                       borderRadius: BorderRadius.circular(4),
//                                       radius: 25,
//                                       onTap: startShipment,
//                                       splashColor: Colors.deepOrange.withOpacity(0.6),
//                                       highlightColor: Colors.deepOrange.withOpacity(0.6),
//                                       child: Container(
//                                         child:
//                                         TextButton.icon(onPressed: startShipment,
//                                           icon: Icon(Icons.local_shipping,color: Colors.white,)
//                                           ,label: Text(translator.translate('startTrip'),
//                                             style: TextStyle(color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//                                           ),
//                                         ),
//                                       ))
//                               )
//                           ) :
//                           Expanded(
//                               child: Material(
//                                   elevation: 5,
//                                   borderRadius: BorderRadius.circular(4),
//                                   color: Colors.grey,
//                                   child: InkWell(
//                                       borderRadius: BorderRadius.circular(4),
//                                       radius: 25,
//                                       onTap: null,
//                                       splashColor: Colors.grey.withOpacity(0.6),
//                                       highlightColor: Colors.grey.withOpacity(0.6),
//                                       child: Container(
//                                         child:
//                                         TextButton.icon(onPressed: startShipment,
//                                           icon: Icon(Icons.refresh ,color: Colors.white,)
//                                           ,label: Text(translator.translate('loading'),
//                                             style: TextStyle(color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//                                           ),
//                                         ),
//                                       ))
//                               )
//                           ),
//                           SizedBox(width: 5,),
//                           Expanded(
//                             child: Material(
//                                 borderRadius: BorderRadius.circular(4),
//                                 elevation: 5,
//                                 color: Colors.red,
//                                 child: TextButton.icon(onPressed: addNewHazar,
//                                   icon: Icon(Icons.add_circle_outline,color: Colors.white,)
//                                   ,label: Text(translator.translate('addHazar'),
//                                     style: TextStyle( color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//                                     maxLines: 3,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   style:  ButtonStyle(
//                                     backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
//                                       if (states.contains(MaterialState.disabled)) {
//                                         return Colors.grey[200];
//                                       }
//                                       return Colors.red;
//                                     }),
//                                     overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
//                                       if (states.contains(MaterialState.pressed)) {
//                                         return Colors.redAccent;
//                                       }
//                                       return Colors.transparent;
//                                     }),
//
//                                   ),
//                                 )
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(top: 80,right: 10,left:10),
//                       padding: EdgeInsets.all(5),
//                       height: 60,
//                       width:60,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.teal,
//                       ),
//                       child: Material(
//                         elevation: 6,
//                         color: Colors.teal,
//                         borderRadius: BorderRadius.all(Radius.circular(50)),
//                         child:  IconButton(onPressed: _launchCaller,
//                             icon: Icon(Icons.call,color: Colors.white, size:30)
//                         ),
//                       ),
//                     ),
//
//                     if(showInfo) Align(
//                       alignment:Alignment.bottomCenter,
//                       child: Container(
//                           alignment:Alignment.bottomCenter,
//                           margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0,),
//                           padding: EdgeInsets.all(10),
//                           height: 150.0,
//                           width: MediaQuery.of(context).size.width -40,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10.0),
//                               boxShadow: [ BoxShadow( color: Colors.black54, offset: Offset(0.0, 4.0), blurRadius: 10.0,),]
//                           ),
//                           child: Column(
//                             children: [
//                               Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       height: 60.0,
//                                       width: 60.0,
//                                       child:  Material(
//                                           elevation: 6,
//                                           borderRadius: BorderRadius.all(Radius.circular(50)),
//                                           child: Icon(Icons.play_circle_outline,color:Colors.teal,size: 40,)),
//                                     ),
//                                     SizedBox(width: 10.0),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
// //                                mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text(
//                                             (translator.currentLanguage == 'en')? currentTrip.riskEn : currentTrip.riskAr,
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold),
//                                             maxLines: 4,
//                                           ),
//                                         ],
//                                       ),),
//                                   ]),
//                               OutlinedButton.icon(
//                                 onPressed:removeEnable ? removeHazar : null,
//                                 icon: Icon(Icons.delete,color: Colors.red,)
//                                 ,label: Text(translator.translate('removeHazar'),
//                                 style: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//                               ),
//                                 style: ButtonStyle(
//
//                                   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
//                                     side: BorderSide(color: Colors.red,width:2),
//
//                                   )),
//                                   backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
//                                     if (states.contains(MaterialState.disabled)) {
//                                       return Colors.grey[200];
//                                     }
//                                     return Colors.white;
//                                   }),
//                                   overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
//                                     if (states.contains(MaterialState.pressed)) {
//                                       return Colors.red;
//                                     }
//                                     return Colors.transparent;
//                                   }),
//
//                                 ),
//                               ),
//                             ],
//                           )),
//                     ),
//                   ],
//                 );
//               },
//               listener: (context, state)  {
//                 if (state is TripSuccessState) {
//                   //print("here first State :${state.trips.data}");
//                   //               await getUserLocation();
//                   noTrip.clear();
//                   //print("noTrip");
//                   state.trips.data.forEach((element) {
//                     //print(element.toJson());
//                     //print(currentLocation);
//                     double distanceInMeters = Geolocator.distanceBetween(currentLocation?.latitude,
//                         currentLocation?.longitude, double.parse(element.lat), double.parse(element.long));
//                     //print('Distance${element.riskId}:=>> $distanceInMeters');
//                     if(distanceInMeters <= 3000 ) {
//                       //print('Distance Lower${element.riskId}:=>> $distanceInMeters');
//                       final Marker marker = Marker(
//                         markerId: MarkerId(element.riskId.toString()),
//                         position: LatLng(double.parse(element.lat), double.parse(element.long)),
//                         icon: bitmapDescriptorRed,
//                       );
//                       markersRed[MarkerId(element.riskId.toString())] = marker;
//                     }
//                     element.distance = distanceInMeters;
//                     // else if (distanceInMeters < 300) {
//                     //   //print("ttt${element.riskId}");
//                     //   //print("${element.riskAr}");
//                     noTrip.add(element);
//                     // }
//                   });
//
//                   noTrip.sort((a,b)=> a.distance.compareTo(b.distance));
//
//                   print (noTrip);
//                   // noTrip.sort((a,b) {
//                   //  return Geolocator.distanceBetween(currentLocation?.latitude, currentLocation?.longitude,
//                   //       double.parse(b.lat), double.parse(b.long)).compareTo(
//                   //      Geolocator.distanceBetween(
//                   //          currentLocation?.latitude,
//                   //          currentLocation?.longitude,
//                   //           double.parse(a.lat), double.parse(a.long)));
//                   // });
//
//                   if(noTrip.length != 0) Future.delayed(const Duration(seconds: 10), () {
//                     //print(noTrip);
//                     //print("RippleMarker");
//                     var rippleMarker =  new RippleMarker(
//                       markerId: MarkerId(noTrip.first.riskId.toString()),
//                       position: LatLng(double.parse(noTrip.first.lat), double.parse(noTrip.first.long)),
//                       ripple: true,  //Ripple state
//                       infoWindow: InfoWindow(
//                           title: noTrip.first.riskAr,
//                           snippet: noTrip.first.riskAr
//                       ),
//                       icon: bitmapDescriptorRed,
//                       onTap: () {},
//                     );
//                     markersRed[MarkerId(noTrip.first.riskId.toString())] = rippleMarker;
//                     if(noTrip.isNotEmpty) choiceAction(noTrip.first);
//                   });
//
//                   print(markersRed);
//                 }
//                 if (state is TripLoadingState ) loadingAlertDialog(context);
//                 if (state is TripStartState) {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pushNamedAndRemoveUntil(LoginWidget.routeName, (Route<dynamic> route) => false);
//                 }
//                 if (state is TripDoneState) {
//                   Navigator.of(context).pop();
//                   // _bloc.add(GetTripEvent());
//                 }
//                 if (state is TripFailedState) {
//                   Navigator.of(context).pop();
//                   show(title: "errorTitle", flag: false, message: "errorMessage");
//                 }
//                 if (state is RemoveRiskSaveState) {
//                   Navigator.of(context).pop();
//                   show(message: "removeHazarMessage", flag: true, title: "successTitle");
//                 }
//                 if (state is AddRiskSaveState) {
//                   Navigator.of(context).pop();
//                   show(message: "addHazarMessage", flag: true, title: "successTitle");
//                 }
//                 if (state is TripCompletedState) {
//                   userData = state.userData;
//                   Navigator.of(context).pop();
//                   show(title: "successTitle", flag: true, message: "tripCompletedMessage");
//                   _bloc.add(GetTripEvent());
//                 }
//                 if (state is GetSupportNumberSuccessState) {
//                   var mobile = state.supportNumber;
//                   Navigator.of(context).pop();
//                   _callSupport(mobile);
//                 }
//               }
//           ),
//         ),
//       ),
//     );
//
//   }
//
//
// }
//
// // class MarkerGenerator {
// //   final double _markerSize;
// //   double _circleStrokeWidth;
// //   double _circleOffset;
// //   double _outlineCircleWidth;
// //   double _fillCircleWidth;
// //   double _iconSize;
// //   double _iconOffset;
// //
// //   MarkerGenerator(this._markerSize) {
// //     // calculate marker dimensions
// //     _circleStrokeWidth = _markerSize / 10.0;
// //     _circleOffset = _markerSize / 2;
// //     _outlineCircleWidth = _circleOffset - (_circleStrokeWidth / 2);
// //     _fillCircleWidth = _markerSize / 2;
// //     final outlineCircleInnerWidth = _markerSize - (2 * _circleStrokeWidth);
// //     _iconSize = sqrt(pow(outlineCircleInnerWidth, 2) / 2);
// //     final rectDiagonal = sqrt(2 * pow(_markerSize, 2));
// //     final circleDistanceToCorners = (rectDiagonal - outlineCircleInnerWidth) / 2;
// //     _iconOffset = sqrt(pow(circleDistanceToCorners, 2) / 2);
// //   }
// //
// //   /// Creates a BitmapDescriptor from an IconData
// //   Future<BitmapDescriptor> createBitmapDescriptorFromIconData(
// //       IconData iconData, Color iconColor, Color circleColor, Color backgroundColor) async {
// //     final pictureRecorder = PictureRecorder();
// //     final canvas = Canvas(pictureRecorder);
// //
// //     _paintCircleFill(canvas, backgroundColor);
// //     _paintCircleStroke(canvas, circleColor);
// //     _paintIcon(canvas, iconColor, iconData);
// //
// //     final picture = pictureRecorder.endRecording();
// //     final image = await picture.toImage(_markerSize.round(), _markerSize.round());
// //     final bytes = await image.toByteData(format: ImageByteFormat.png);
// //
// //     return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
// //   }
// //
// //   /// Paints the icon background
// //   void _paintCircleFill(Canvas canvas, Color color) {
// //     final paint = Paint()
// //       ..style = PaintingStyle.fill
// //       ..color = color;
// //     canvas.drawCircle(Offset(_circleOffset, _circleOffset), _fillCircleWidth, paint);
// //   }
// //
// //   /// Paints a circle around the icon
// //   void _paintCircleStroke(Canvas canvas, Color color) {
// //     final paint = Paint()
// //       ..style = PaintingStyle.stroke
// //       ..color = color
// //       ..strokeWidth = _circleStrokeWidth;
// //     canvas.drawCircle(Offset(_circleOffset, _circleOffset), _outlineCircleWidth, paint);
// //   }
// //
// //   /// Paints the icon
// //   void _paintIcon(Canvas canvas, Color color, IconData iconData) {
// //     final textPainter = TextPainter(textDirection: TextDirection.ltr);
// //     textPainter.text = TextSpan(
// //         text: String.fromCharCode(iconData.codePoint),
// //         style: TextStyle(
// //           letterSpacing: 0.0,
// //           fontSize: _iconSize,
// //           fontFamily: iconData.fontFamily,
// //           color: color,
// //         ));
// //     textPainter.layout();
// //     textPainter.paint(canvas, Offset(_iconOffset, _iconOffset));
// //   }
// // }
