import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/login/presentation/pages/login-page.dart';
import 'package:journeyhazard/features/share/loading-dialog.dart';
import 'package:journeyhazard/features/trips/data/models/risk.dart';
import 'package:journeyhazard/features/trips/presentation/bloc/risk_bloc.dart';
import 'package:journeyhazard/features/trips/presentation/bloc/trip-bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:journeyhazard/core/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:journeyhazard/features/trips/presentation/bloc/trip-events.dart';
import 'package:journeyhazard/features/trips/presentation/bloc/trip-state.dart';
import 'package:flutter_tts/flutter_tts.dart';


class TripsWidget extends StatefulWidget {
  static const routeName = 'TripsWidget';

  TripsWidgetState createState() => TripsWidgetState();
}
enum TtsState { playing, stopped, paused, continued }

class TripsWidgetState extends State<TripsWidget> {
  Completer<GoogleMapController> _controller = Completer();
  TripBloc _bloc = TripBloc();
  RiskBloc _blocRisk = RiskBloc();
  FlutterTts flutterTts;

  LatLng _center = LatLng(27.167928, 31.196732);
  LatLng _currentRiskPosition =  LatLng(27.2134, 31.4456);
  MapType _currentMapType = MapType.normal;
  // Position currentLocation;
  final double cameraZoom = 16;
  final double cameraTilt = 80;
  final double cameraBearing = 30;
  final double cameraZoomIn = 19;
  CameraPosition initialCameraPosition;
// the user's initial location and current location
// as it moves
  Position currentLocation;
// wrapper around the location API
  Position location;

  CameraPosition _cameraPosition;
  bool addEnable = true;
  bool removeEnable = true;

  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // Set<Marker> markers = {};
  Set<Marker> markers = Set<Marker>();
  // Set<Marker> markersRed = Set<RippleMarker>();
  RippleMarker markerRed ;
  final markersRed = <MarkerId, Marker>{};


  // Map<MarkerId, Marker> markersRed = <MarkerId, Marker>{};

  String googleAPiKey = MAP_API_KEY;
  List<RiskModel> allLocations = [];
  List<RiskModel> validRisks = [];
  List<RiskModel> runRisks = [];
  RiskModel currentTrip = new RiskModel();

  bool showInfo = false;
  BitmapDescriptor bitmapDescriptorRed;
  // BitmapDescriptor bitmapDescriptorGreen;
  BitmapDescriptor bitmapDescriptorBlue;
  UserModel userData;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  StreamSubscription<Position> positionStream ;

  String resultText = "";
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
    initializeTts();
    setInitialLocation();
    showPinsOnMap();
  }

  //Functions//
  void updatePinOnMap() async {

    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: cameraZoom,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    // updated position
    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    // the trick is to remove the marker (by id)
    // and add it again at the updated location
    markers.removeWhere((marker) => marker.markerId.value == "me");
    markers.add(Marker(
        markerId: MarkerId('me'),
        position: pinPosition, // updated position
        icon: bitmapDescriptorBlue
    ));
  }

  void _onMapCreated(GoogleMapController controller)  {
    _controller.complete(controller);
    positionStream = Geolocator.getPositionStream(distanceFilter: 500).listen(
            (Position position) {
          if(position != null) {
            currentLocation = position;
            _center = LatLng(currentLocation?.latitude, currentLocation?.longitude);
            // updatePinOnMap();
            var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
            // the trick is to remove the marker (by id)
            // and add it again at the updated location
            markers.removeWhere((marker) => marker.markerId.value == "me");
            markers.add(Marker(
                markerId: MarkerId('me'),
                position: pinPosition, // updated position
                icon: bitmapDescriptorBlue
            ));
          }
          _bloc.add(GetTripEvent());
        });
  }

  // getUser() async {
  //   final driverDataDB =  await DBHelper.getData('driver_data');
  //   if(driverDataDB.isNotEmpty) userData=  UserModel.fromJson(driverDataDB.first);
  // }
//  Sound Init
  initializeTts() {
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      //print("Cancel");
      ttsState = TtsState.stopped;
    });
    flutterTts.setErrorHandler((msg) {
      //print("error: $msg");
      ttsState = TtsState.stopped;
    });

    var lang = translator.currentLanguage == 'fil' ? 'fil-PH' : translator.currentLanguage;
    //print(lang);
    flutterTts.setLanguage(lang);
    flutterTts.setVolume(1);
    flutterTts.setSpeechRate(1);
    flutterTts.setPitch(1);

  }


  setSourceAndDestinationIcons() async {
    bitmapDescriptorRed =  await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0 ), 'assets/images/flag.png');
    bitmapDescriptorBlue = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0), 'assets/images/truck.png');
  }

  // Future getCurrentLocation() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   //print(permission);
  //   if (permission != PermissionStatus.granted) {
  //     LocationPermission permission = await Geolocator.requestPermission();
  //     if (permission != PermissionStatus.granted)
  //       getLocation();
  //     return;
  //   }
  //   getLocation();
  // }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   //print(position.latitude);
  //   //     //print('lat position${position?.latitude}, ${position?.longitude}');
  //
  //   setState(() {
  //     _center = new LatLng(position.latitude, position.longitude);
  //     _cameraPosition = CameraPosition(
  //         zoom: cameraZoom,
  //         tilt: cameraTilt,
  //         bearing: cameraBearing,
  //         target: _center);
  //     currentLocation = position;
  //     if(_controller != null)
  //       _controller.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition)));
  //
  //     _bloc.add(GetTripEvent());
  //   });
  // }

  getUserLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(currentLocation != null) {
      _center = LatLng(currentLocation?.latitude, currentLocation?.longitude);
      _cameraPosition = CameraPosition(
          zoom: cameraZoom,
          tilt: cameraTilt,
          bearing: cameraBearing,
          target: _center );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
    }
  }

  addNewRisk() {
    _bloc.add(AddHazarEvent());
  }

  removeRisk() {
    removeEnable = false;
    _bloc.add(RemoveHazarEvent(risk: currentTrip));
  }

  completeShipment() {
    _bloc.add(CompleteTripEvent());

  }

  startShipment() {
    _bloc.add(StartTripEvent());
  }
  Future _speak(_newVoiceText) async {
    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        for(int i = 0 ; i< 2 ;i++) {
          await flutterTts.awaitSpeakCompletion(true);
          await flutterTts.speak(_newVoiceText);
        }
      }
    }
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    if(currentLocation != null) {
      var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
      // add the initial source location pin
      markers.add(Marker(
        markerId: MarkerId('me'),
        position: pinPosition,
        icon: bitmapDescriptorBlue,
      ));
    }

  }

  show({String message, String title ,bool flag}) {
    AlertDialog alert = AlertDialog(
      title: Center(child: Text( translator.translate(title),style: TextStyle(fontSize: 20 ,fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600, color: flag? Colors.green : Colors.red),)),
      content: Text(translator.translate(message), style: TextStyle(fontSize: 16,fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
    );
    showDialog( context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3),(){
          Navigator.of(context).pop();
        });
        return  alert;
      },);
  }
  moveCamera() async{
    _center = LatLng(currentLocation?.latitude, currentLocation?.longitude);
    _cameraPosition = CameraPosition(
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing,
        target: _center );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));

  }

  _launchCaller() {
    _bloc.add(SupportMobileEvent());
  }

  _callSupport (mobile) async{
    final url = "tel:$mobile";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void runRisk(RiskModel risk) async{
    // final GoogleMapController controller = await _controller.future;
    // print(risk.toJson());
    // controller.animateCamera(CameraUpdate.newLatLng(LatLng(double.parse(risk.lat), double.parse(risk.long))));
    _blocRisk.add(RunRiskEvent(risk: risk));

    removeEnable = true;
    var riskText = (translator.currentLanguage == 'en')? risk.riskEn : risk.riskAr;
    currentTrip = risk;

    // showInfo = true;
    _speak(riskText);
    Future.delayed(const Duration(seconds: 20), () async {

      runRisks.removeWhere((elRisk) => elRisk.riskId == risk.riskId);
      markers.removeWhere((el) => el.markerId.value == risk.riskId.toString());
      markerRed = new RippleMarker(
          markerId: MarkerId('risk'),
          position: LatLng(double.parse(risk.lat), double.parse(risk.long)),
          ripple: false,  //Ripple state
          infoWindow: InfoWindow(
              title: risk.riskAr,
              snippet: risk.riskAr
          ),
          icon: bitmapDescriptorRed,
          onTap: null,
          consumeTapEvents: true
      );
      markersRed[MarkerId('risk')] = markerRed;
      _blocRisk.add(DoneRiskEvent(risk: risk));
    });

  }

  updateRiskData(RiskModel risk) async {
    await DBHelper.updateWhere(done: 0,distance: risk.distance,riskId:  risk.riskId);
  }

  calculateRisks() {
    // runRisks

    if(currentTrip.riskId == null && runRisks.isEmpty) {
      isFirstTime = true;
    }
    validRisks.forEach((element) {
      final exitRisk = runRisks.indexWhere((el) => el.riskId == element.riskId);
      print(exitRisk);
      if(exitRisk != -1 && currentTrip.riskId != element.riskId) {
        runRisks[exitRisk] = element;
      }
      if(exitRisk == -1) {
        runRisks.add(element);
        final Marker marker = Marker(
           markerId: MarkerId(element.riskId.toString()),
           position: LatLng(double.parse(element.lat), double.parse(element.long)),
           icon: bitmapDescriptorRed,
          consumeTapEvents: true,
          onTap: null,
         );
         markers.add(marker);
      }
    });
    print(runRisks.toList());
    if(currentTrip.riskId == null && isFirstTime) {
      currentRisk();
    }
  }

  currentRisk() {
    runRisks.sort((a,b)=> a.distance.compareTo(b.distance));

    if(runRisks.length != 0) Future.delayed(const Duration(seconds: 5), () {

      print(runRisks.first);
      // var rippleMarker =  new RippleMarker(
      //     markerId: MarkerId(runRisks.first.riskId.toString()),
      //     position: LatLng(double.parse(runRisks.first.lat), double.parse(runRisks.first.long)),
      //     ripple: true,  //Ripple state
      //     infoWindow: InfoWindow(
      //         title: runRisks.first.riskAr,
      //         snippet: runRisks.first.riskAr
      //     ),
      //     icon: bitmapDescriptorRed,
      //     onTap: null,
      //     consumeTapEvents: true
      // );
      //
      // markersRed[MarkerId(runRisks.first.riskId.toString())] = rippleMarker

      if(runRisks.isNotEmpty) runRisk(runRisks.first);

    });
  }
  //End Functions

  @override
  void dispose() {
    _bloc.close();
    positionStream.cancel();
    flutterTts.stop();
    super.dispose();
  }


  @override
  Widget  build(BuildContext context) {
    print("build Context");
    final arg = ModalRoute.of(context).settings.arguments as UserModel;
    if (arg != null) userData = arg;
    //  initialCameraPosition = CameraPosition(
    //     zoom: cameraZoom,
    //     tilt: cameraTilt,
    //     bearing: cameraBearing,
    //     target: _center
    // );

    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child:BlocListener<TripBloc, BaseTripState>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is TripSuccessState) {
                    validRisks.clear();
                    final tripData = state.trips.data;
                    tripData.forEach((element) {
                      double distanceInMeters = Geolocator.distanceBetween(currentLocation?.latitude, currentLocation?.longitude, double.parse(element.lat), double.parse(element.long));
                      print('Distance${element.riskId}:=>> $distanceInMeters, Done ${element.done}');

                      element.distance = distanceInMeters;

                      if(distanceInMeters < 2500 && (element.done == 0 || element.done == null)  ) {
                        print('Distance Lower${element.riskId}:=>> $distanceInMeters');
                        validRisks.add(element);
                      }
                      else if (distanceInMeters > 3000 && element.done == 1) {
                        updateRiskData(element);
                      }
                    });
                    calculateRisks();


                    print (validRisks);
                  }
                  if (state is TripLoadingState ) loadingAlertDialog(context);
                  if (state is TripStartState) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(LoginWidget.routeName, (Route<dynamic> route) => false);
                  }
                  if (state is TripFailedState) {
                    Navigator.of(context).pop();
                    show(title: "errorTitle", flag: false, message: "errorMessage");
                  }
                  if (state is RemoveRiskSaveState) {
                    Navigator.of(context).pop();
                    show(message: "removeHazarMessage", flag: true, title: "successTitle");
                  }
                  if (state is AddRiskSaveState) {
                    Navigator.of(context).pop();
                    show(message: "addHazarMessage", flag: true, title: "successTitle");
                  }
                  if (state is TripCompletedState) {
                    userData = state.userData;
                    Navigator.of(context).pop();
                    show(title: "successTitle", flag: true, message: "tripCompletedMessage");
                    _bloc.add(GetTripEvent());
                  }
                  if (state is GetSupportNumberSuccessState) {
                    var mobile = state.supportNumber;
                    Navigator.of(context).pop();
                    _callSupport(mobile);
                  }
                },
              child: BlocConsumer<RiskBloc, RiskState>(
                bloc: _blocRisk,
                builder: (context, state) {
                  if (state is RunRiskState) {
                    // markersRed.add( new RippleMarker(
                    //       markerId: MarkerId(state.risk.riskId.toString()),
                    //       position: LatLng(double.parse(state.risk.lat), double.parse(state.risk.long)),
                    //       ripple: true,  //Ripple state
                    //       infoWindow: InfoWindow(
                    //           title: state.risk.riskAr,
                    //           snippet: state.risk.riskAr
                    //       ),
                    //       icon: bitmapDescriptorRed,
                    //       onTap: null,
                    //       consumeTapEvents: true
                    //   ));
                    markerRed = new RippleMarker(
                        markerId: MarkerId('risk'),
                        position: LatLng(double.parse(state.risk.lat), double.parse(state.risk.long)),
                        ripple: true,  //Ripple state
                        infoWindow: InfoWindow(
                            title: state.risk.riskAr,
                            snippet: state.risk.riskAr
                        ),
                        icon: bitmapDescriptorRed,
                        onTap: null,
                        consumeTapEvents: true
                    );
                    markersRed[MarkerId('risk')] = markerRed;
                    _center = LatLng(double.parse(state.risk.lat), double.parse(state.risk.long));
                    _controller.future.then((controller) => controller.animateCamera(CameraUpdate.newLatLng( _center)));
                  }
                  else {
                    if (currentLocation != null) {
                      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
                    _controller.future.then((controller) => controller.animateCamera(CameraUpdate.newLatLng(_center)));
                  }
                  }
                  print('mmmmmmmmmmmmmmm ${context.watch<TripBloc>().userData?.toJson()}');
                  return Stack(
                      children: <Widget>[
                        Animarker(
                          mapId: _controller.future.then((value) => value.mapId), //Grab Google Map Id
                          rippleRadius: 0.5,  //[0,1.0] range, how big is the circle
                          rippleColor: Colors.red, // Color of fade ripple circle
                          rippleDuration: Duration(seconds: 20), //Pulse ripple duration
                          useRotation: false,
                          markers:  markersRed.values.toSet(),
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            markers: markers.toSet(),
                            initialCameraPosition:  CameraPosition(
                              zoom: cameraZoom,
                              tilt: cameraTilt,
                              bearing: cameraBearing,
                              target: _center,
                            ),
                            indoorViewEnabled: true,
                            trafficEnabled: true,
                            mapType: _currentMapType,
                            myLocationEnabled: true,
                            tiltGesturesEnabled: true,
                            compassEnabled: true,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(() =>
                                  PanGestureRecognizer()))..add(
                                  Factory<ScaleGestureRecognizer>(() =>
                                      ScaleGestureRecognizer()))..add(
                                  Factory<TapGestureRecognizer>(() =>
                                      TapGestureRecognizer()))..add(
                                  Factory<VerticalDragGestureRecognizer>(() =>
                                      VerticalDragGestureRecognizer()))..add(
                                  Factory<HorizontalDragGestureRecognizer>(() =>
                                      HorizontalDragGestureRecognizer())),
                          ),
                          // Other properties
                        ),
                        Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(5),
                              height: 60,
                              alignment: AlignmentDirectional.topCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [// TODO Check IT
                                  (context.watch<TripBloc>().userData != null || userData != null)? (userData?.shipmentId != null) ? Expanded(child: Material(
                                          elevation: 5,
                                          borderRadius: BorderRadius.circular(4),
                                          color: Colors.green,
                                          child: InkWell(
                                              borderRadius: BorderRadius.circular(4),
                                              radius: 25,
                                              onTap: startShipment,
                                              splashColor: Colors.lightGreen.withOpacity(0.6),
                                              highlightColor: Colors.lightGreen.withOpacity(0.6),
                                              child: Container(
                                                child:
                                                TextButton.icon(onPressed: completeShipment,
                                                  icon: Icon(Icons.done_all,color: Colors.white,)
                                                  ,label: Text(translator.translate('endTrip'),
                                                    style: TextStyle(color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                              ))
                                      )) :
                                  Expanded(child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.orange,
                                      child: InkWell(
                                          borderRadius: BorderRadius.circular(4),
                                          radius: 25,
                                          onTap: startShipment,
                                          splashColor: Colors.deepOrange.withOpacity(0.6),
                                          highlightColor: Colors.deepOrange.withOpacity(0.6),
                                          child: Container(
                                            child:
                                            TextButton.icon(onPressed: startShipment,
                                              icon: Icon(Icons.local_shipping,color: Colors.white,)
                                              ,label: Text(translator.translate('startTrip'),
                                                style: TextStyle(color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                          ))
                                  ))
                                      : Expanded(child: Material(
                                          elevation: 5,
                                          borderRadius: BorderRadius.circular(4),
                                          color: Colors.grey,
                                          child: InkWell(
                                              borderRadius: BorderRadius.circular(4),
                                              radius: 25,
                                              onTap: null,
                                              splashColor: Colors.grey.withOpacity(0.6),
                                              highlightColor: Colors.grey.withOpacity(0.6),
                                              child: Container(
                                                child:
                                                TextButton.icon(onPressed: startShipment,
                                                  icon: Icon(Icons.refresh ,color: Colors.white,)
                                                  ,label: Text(translator.translate('loading'),
                                                    style: TextStyle(color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                              ))
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: Material(
                                        borderRadius: BorderRadius.circular(4),
                                        elevation: 5,
                                        color: Colors.red,
                                        child: TextButton.icon(onPressed: addNewRisk,
                                          icon: Icon(Icons.add_circle_outline,color: Colors.white,)
                                          ,label: Text(translator.translate('addHazar'),
                                            style: TextStyle( color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          style:  ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                              if (states.contains(MaterialState.disabled)) {
                                                return Colors.grey[200];
                                              }
                                              return Colors.red;
                                            }),
                                            overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                                              if (states.contains(MaterialState.pressed)) {
                                                return Colors.redAccent;
                                              }
                                              return Colors.transparent;
                                            }),

                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        Container(
                          margin: EdgeInsets.only(top: 80,right: 10,left:10),
                          padding: EdgeInsets.all(5),
                          height: 60,
                          width:60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.teal,
                          ),
                          child: Material(
                            elevation: 6,
                            color: Colors.teal,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child:  IconButton(onPressed: _launchCaller,
                                icon: Icon(Icons.call,color: Colors.white, size:30)
                            ),
                          ),
                        ),
                        if (state is RunRiskState) Align(
                          alignment:Alignment.bottomCenter,
                          child: Container(
                              alignment:Alignment.bottomCenter,
                              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0,),
                              padding: EdgeInsets.all(5),
                              height: 150.0,
                              width: MediaQuery.of(context).size.width -40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [ BoxShadow( color: Colors.black54, offset: Offset(0.0, 4.0), blurRadius: 10.0,),]
                              ),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 60.0,
                                          width: 60.0,
                                          child:  Material(
                                              elevation: 6,
                                              borderRadius: BorderRadius.all(Radius.circular(50)),
                                              child: Icon(Icons.play_circle_outline,color:Colors.teal,size: 40,)),
                                        ),
                                        SizedBox(width: 6.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
//                                mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                (translator.currentLanguage == 'en')? state.risk.riskEn : state.risk.riskAr,
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 6.0),
                                              Text('${(state.risk.distance/1000).toString().substring(0,3)} Km',
                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                            ],
                                          ),),
                                      ]),
                                  OutlinedButton.icon(
                                    onPressed:removeEnable ? removeRisk : null,
                                    icon: Icon(Icons.delete,color: Colors.red,)
                                    ,label: Text(translator.translate('removeHazar'),
                                    style: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
                                  ),
                                    style: ButtonStyle(

                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                                        side: BorderSide(color: Colors.red,width:2),

                                      )),
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                        if (states.contains(MaterialState.disabled)) {
                                          return Colors.grey[200];
                                        }
                                        return Colors.white;
                                      }),
                                      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                                        if (states.contains(MaterialState.pressed)) {
                                          return Colors.red;
                                        }
                                        return Colors.transparent;
                                      }),

                                    ),
                                  ),
                                ],
                              )),
                        ),
                        ]);
                  },
                  listener:  (context, state) {
                    if (state is RiskLoadingState ) loadingAlertDialog(context);
                    if (state is DoneRiskState) {
                      Navigator.of(context).pop();
                      currentTrip = new RiskModel();
                      currentRisk();
                    }
                    // if (state is RunRiskState) {
                    //   var rippleMarker =  new RippleMarker(
                    //       markerId: MarkerId(state.risk.riskId.toString()),
                    //       position: LatLng(double.parse(state.risk.lat), double.parse(state.risk.long)),
                    //       ripple: true,  //Ripple state
                    //       infoWindow: InfoWindow(
                    //           title: state.risk.riskAr,
                    //           snippet: state.risk.riskAr
                    //       ),
                    //       icon: bitmapDescriptorRed,
                    //       onTap: null,
                    //       consumeTapEvents: true
                    //   );
                    //
                    //   markersRed[MarkerId(state.risk.riskId.toString())] = rippleMarker;
                    //   print(markersRed);
                    // }
                  }
              ),
//               child:  Stack(
//                 children: <Widget>[
//                   Animarker(
//                     mapId: _controller.future.then((value) => value.mapId), //Grab Google Map Id
//                     rippleRadius: 0.5,  //[0,1.0] range, how big is the circle
//                     rippleColor: Colors.red, // Color of fade ripple circle
//                     rippleDuration: Duration(seconds: 20), //Pulse ripple duration
//                     markers: Set<Marker>.of(markersRed.values),
//                     child: GoogleMap(
//                       onMapCreated: _onMapCreated,
//                       markers: markers.toSet(),
//                       initialCameraPosition:  CameraPosition(
//                         zoom: cameraZoom,
//                         tilt: cameraTilt,
//                         bearing: cameraBearing,
//                         target: _center,
//                       ),
//                       indoorViewEnabled: true,
//                       trafficEnabled: true,
//                       mapType: _currentMapType,
//                       myLocationEnabled: true,
//                       tiltGesturesEnabled: true,
//                       compassEnabled: true,
//                       rotateGesturesEnabled: true,
//                       scrollGesturesEnabled: true,
//                       zoomGesturesEnabled: true,
//                       zoomControlsEnabled: true,
//                       gestureRecognizers: Set()
//                         ..add(Factory<PanGestureRecognizer>(() =>
//                             PanGestureRecognizer()))..add(
//                             Factory<ScaleGestureRecognizer>(() =>
//                                 ScaleGestureRecognizer()))..add(
//                             Factory<TapGestureRecognizer>(() =>
//                                 TapGestureRecognizer()))..add(
//                             Factory<VerticalDragGestureRecognizer>(() =>
//                                 VerticalDragGestureRecognizer()))..add(
//                             Factory<HorizontalDragGestureRecognizer>(() =>
//                                 HorizontalDragGestureRecognizer())),
//                     ),
//                     // Other properties
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: 5),
//                     padding: EdgeInsets.all(5),
//                     height: 60,
//                     alignment: AlignmentDirectional.topCenter,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [// TODO Check IT
//                         (userData != null)? (userData?.shipmentId != null) ? Expanded(
//                             child: Material(
//                                 elevation: 5,
//                                 borderRadius: BorderRadius.circular(4),
//                                 color: Colors.green,
//                                 child: InkWell(
//                                     borderRadius: BorderRadius.circular(4),
//                                     radius: 25,
//                                     onTap: startShipment,
//                                     splashColor: Colors.lightGreen.withOpacity(0.6),
//                                     highlightColor: Colors.lightGreen.withOpacity(0.6),
//                                     child: Container(
//                                       child:
//                                       TextButton.icon(onPressed: completeShipment,
//                                         icon: Icon(Icons.done_all,color: Colors.white,)
//                                         ,label: Text(translator.translate('endTrip'),
//                                           style: TextStyle(color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//                                         ),
//                                       ),
//                                     ))
//                             )
//                         ) :
//                         Expanded(child: Material(
//                             elevation: 5,
//                             borderRadius: BorderRadius.circular(4),
//                             color: Colors.orange,
//                             child: InkWell(
//                                 borderRadius: BorderRadius.circular(4),
//                                 radius: 25,
//                                 onTap: startShipment,
//                                 splashColor: Colors.deepOrange.withOpacity(0.6),
//                                 highlightColor: Colors.deepOrange.withOpacity(0.6),
//                                 child: Container(
//                                   child:
//                                   TextButton.icon(onPressed: startShipment,
//                                     icon: Icon(Icons.local_shipping,color: Colors.white,)
//                                     ,label: Text(translator.translate('startTrip'),
//                                       style: TextStyle(color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//                                     ),
//                                   ),
//                                 ))
//                         )) : Expanded(
//                             child: Material(
//                                 elevation: 5,
//                                 borderRadius: BorderRadius.circular(4),
//                                 color: Colors.grey,
//                                 child: InkWell(
//                                     borderRadius: BorderRadius.circular(4),
//                                     radius: 25,
//                                     onTap: null,
//                                     splashColor: Colors.grey.withOpacity(0.6),
//                                     highlightColor: Colors.grey.withOpacity(0.6),
//                                     child: Container(
//                                       child:
//                                       TextButton.icon(onPressed: startShipment,
//                                         icon: Icon(Icons.refresh ,color: Colors.white,)
//                                         ,label: Text(translator.translate('loading'),
//                                           style: TextStyle(color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//                                         ),
//                                       ),
//                                     ))
//                             )
//                         ),
//                         SizedBox(width: 5,),
//                         Expanded(
//                           child: Material(
//                               borderRadius: BorderRadius.circular(4),
//                               elevation: 5,
//                               color: Colors.red,
//                               child: TextButton.icon(onPressed: addNewRisk,
//                                 icon: Icon(Icons.add_circle_outline,color: Colors.white,)
//                                 ,label: Text(translator.translate('addHazar'),
//                                   style: TextStyle( color: Colors.white, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//                                   maxLines: 3,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 style:  ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
//                                     if (states.contains(MaterialState.disabled)) {
//                                       return Colors.grey[200];
//                                     }
//                                     return Colors.red;
//                                   }),
//                                   overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
//                                     if (states.contains(MaterialState.pressed)) {
//                                       return Colors.redAccent;
//                                     }
//                                     return Colors.transparent;
//                                   }),
//
//                                 ),
//                               )
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: 80,right: 10,left:10),
//                     padding: EdgeInsets.all(5),
//                     height: 60,
//                     width:60,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.teal,
//                     ),
//                     child: Material(
//                       elevation: 6,
//                       color: Colors.teal,
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                       child:  IconButton(onPressed: _launchCaller,
//                           icon: Icon(Icons.call,color: Colors.white, size:30)
//                       ),
//                     ),
//                   ),
//                   BlocConsumer<RiskBloc, RiskState>(
//                     bloc: _blocRisk,
//                       builder: (context, state) {
//                        if (state is RunRiskState) {
//                           _controller.future.then((controller) => controller.animateCamera(CameraUpdate.newLatLng(LatLng(double.parse(state.risk.lat), double.parse(state.risk.long)))));
//                          return Align(
//                            alignment:Alignment.bottomCenter,
//                            child: Container(
//                                alignment:Alignment.bottomCenter,
//                                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0,),
//                                padding: EdgeInsets.all(10),
//                                height: 150.0,
//                                width: MediaQuery.of(context).size.width -40,
//                                decoration: BoxDecoration(
//                                    color: Colors.white,
//                                    borderRadius: BorderRadius.circular(10.0),
//                                    boxShadow: [ BoxShadow( color: Colors.black54, offset: Offset(0.0, 4.0), blurRadius: 10.0,),]
//                                ),
//                                child: Column(
//                                  children: [
//                                    Row(
//                                        mainAxisAlignment: MainAxisAlignment.start,
//                                        children: [
//                                          Container(
//                                            height: 60.0,
//                                            width: 60.0,
//                                            child:  Material(
//                                                elevation: 6,
//                                                borderRadius: BorderRadius.all(Radius.circular(50)),
//                                                child: Icon(Icons.play_circle_outline,color:Colors.teal,size: 40,)),
//                                          ),
//                                          SizedBox(width: 10.0),
//                                          Expanded(
//                                            child: Column(
//                                              crossAxisAlignment: CrossAxisAlignment.start,
// //                                mainAxisSize: MainAxisSize.min,
//                                              children: [
//                                                Text(
//                                                  (translator.currentLanguage == 'en')? state.risk.riskEn : state.risk.riskAr,
//                                                  style: TextStyle(
//                                                      fontSize: 14,
//                                                      fontWeight: FontWeight.bold),
//                                                  maxLines: 4,
//                                                ),
//                                              ],
//                                            ),),
//                                        ]),
//                                    OutlinedButton.icon(
//                                      onPressed:removeEnable ? removeRisk : null,
//                                      icon: Icon(Icons.delete,color: Colors.red,)
//                                      ,label: Text(translator.translate('removeHazar'),
//                                      style: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),
//                                    ),
//                                      style: ButtonStyle(
//
//                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
//                                          side: BorderSide(color: Colors.red,width:2),
//
//                                        )),
//                                        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
//                                          if (states.contains(MaterialState.disabled)) {
//                                            return Colors.grey[200];
//                                          }
//                                          return Colors.white;
//                                        }),
//                                        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
//                                          if (states.contains(MaterialState.pressed)) {
//                                            return Colors.red;
//                                          }
//                                          return Colors.transparent;
//                                        }),
//
//                                      ),
//                                    ),
//                                  ],
//                                )),
//                          );
//
//                        } else
//                          {
//                            return Container();
//                          }
//                       },
//                     listener:  (context, state) {
//                       if (state is RiskLoadingState ) loadingAlertDialog(context);
//
//                       if (state is DoneRiskState) {
//                         Navigator.of(context).pop();
//                         currentTrip = new RiskModel();
//                         currentRisk();
//                       }
//                       if (state is RunRiskState) {
//                         var rippleMarker =  new RippleMarker(
//                             markerId: MarkerId(state.risk.riskId.toString()),
//                             position: LatLng(double.parse(state.risk.lat), double.parse(state.risk.long)),
//                             ripple: true,  //Ripple state
//                             infoWindow: InfoWindow(
//                                 title: state.risk.riskAr,
//                                 snippet: state.risk.riskAr
//                             ),
//                             icon: bitmapDescriptorRed,
//                             onTap: null,
//                             consumeTapEvents: true
//                         );
//
//                         markersRed[MarkerId(state.risk.riskId.toString())] = rippleMarker;
//                         print(markersRed);
//                       }
//
//
//
//                     }
//                   )
//                 ],
//               ),
            ),



          ),
        ),
      ),
    );

  }


}

