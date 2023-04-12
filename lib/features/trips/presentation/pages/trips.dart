import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:io' show Directory, Platform;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:journeyhazard/core/eventsTypes.dart';
import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/login/presentation/pages/login-page.dart';
import 'package:journeyhazard/features/mobile/presentation/pages/safety_distnarions_page.dart';
import 'package:journeyhazard/features/share/loading-dialog.dart';
import 'package:journeyhazard/features/trips/data/models/jobsite.dart';
import 'package:journeyhazard/features/trips/data/models/jobsitelist.dart';
import 'package:journeyhazard/features/trips/data/models/risk.dart';
import 'package:journeyhazard/features/trips/presentation/bloc/job_site_bloc.dart';
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
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:journeyhazard/features/trips/presentation/bloc/trip-events.dart';
import 'package:journeyhazard/features/trips/presentation/bloc/trip-state.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter_sound_lite/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';

class TripsWidget extends StatefulWidget {
  static const routeName = 'TripsWidget';

  TripsWidgetState createState() => TripsWidgetState();
}

enum TtsState { playing, stopped, paused, continued }

class TripsWidgetState extends State<TripsWidget> {
  Completer<GoogleMapController> _controller = Completer();
  TripBloc _bloc = TripBloc();
  RiskBloc _blocRisk = RiskBloc();
  JobSiteBloc _blocJobSite = JobSiteBloc();
  FlutterTts flutterTts;

  LatLng _center = LatLng(0.5937, 0.9629);
  LatLng _currentRiskPosition = LatLng(27.2134, 31.4456);
  MapType _currentMapType = MapType.normal;
  // Position currentLocation;
  final double cameraZoom = 15;
  final double cameraTilt = 80;
  final double cameraBearing = 30;
  final double cameraZoomIn = 15;
  CameraPosition initialCameraPosition;
// the user's initial location and current location
// as it moves
  Position currentLocation;
// wrapper around the location API
  Position lastLocation;
  CameraPosition _cameraPosition =
      CameraPosition(zoom: 15, target: LatLng(0.5937, 0.9629));
  bool addEnable = true;
  bool removeEnable = true;
  String currentLang = translator.currentLanguage;

  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Set<Marker> markers = Set<Marker>();
  // Set<Marker> markersRed = Set<RippleMarker>();
  RippleMarker markerRed;
  final markersRed = <MarkerId, Marker>{};

  // Map<MarkerId, Marker> markersRed = <MarkerId, Marker>{};

  String googleAPiKey = MAP_API_KEY;
  List<RiskModel> allLocations = [];
  List<RiskModel> validRisks = [];
  List<RiskModel> repeatRisks = [];
  List<RiskModel> runRisks = [];
  RiskModel currentTrip = new RiskModel();
  RiskModel newRisk = new RiskModel();

  bool showInfo = false;
  BitmapDescriptor bitmapDescriptorRed;
  BitmapDescriptor bitmapDescriptorGreen;
  BitmapDescriptor bitmapDescriptorBlue;
  UserModel userData;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  StreamSubscription<Position> positionStream;

  String resultText = "";
  bool isFirstTime = false;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> polyline = Set<Polyline>();
  String filePath;
  static const eventChannel = EventChannel('com.cemex.hazar/gamepad_channel');
  StreamSubscription _eventChannel;
  int index = 0;

  List<JobSite> imgList = [];
  List<Widget> imageSliders = [];
  List<JobSite> jobSitesData = [];
  List<JobSite> itemsOfJobSites = [];
  JobSite selectedJobSite;
  int initPage = 0;
  int lastIndex = 0;
  CarouselController buttonCarouselController = CarouselController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // method for convert assets
    setSourceAndDestinationIcons();
    setInitialLocation();
    initializeTts();
    _eventChannel = eventChannel.receiveBroadcastStream().listen(
      (event) {
        print('eventChannel ::$event');
        final eventParameters = <String, dynamic>{};

        if (event != null && event is String) {
          event.split(',~').forEach((e) {
            var createPairList = e.split('=');
            eventParameters[createPairList[0]] = createPairList[1];
          });
        }

        if (eventParameters[EventTypes.androidType] == EventTypes.button &&
            (eventParameters['keyCode'] != '25' &&
                eventParameters['keyCode'] != '24')) {
          print('BUTTON: ${eventParameters['keyCode']}');
          if (index == 0) {
            addNewRisk();
            index++;
          } else {
            index = 0;
          }
        } else if (eventParameters[EventTypes.androidType] == EventTypes.axis) {
          print('AXIS: $eventParameters');
        } else if (eventParameters[EventTypes.androidType] == EventTypes.dpad) {
          print('DPAD: $eventParameters');
        }
      },
    );
    _bloc.add(GetTripEvent());
    super.initState();

    // startIt();
    // positionStream = Geolocator.getPositionStream(distanceFilter: 100).listen((Position position) {
    //       print("location in 500m: $position");
    //       // points.clear();
    //       if(position != null) {
    //         if(currentLocation != null) {
    //           lastLocation = currentLocation;
    //           var lastPosition = LatLng(lastLocation.latitude, lastLocation.longitude);
    //         }
    //         currentLocation = position;
    //         _center = LatLng(currentLocation?.latitude, currentLocation?.longitude);
    //         // updatePinOnMap();
    //         print('new location ${currentLocation?.latitude}, ${currentLocation?.longitude}');
    //         var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    //
    //         // polyline.add(truckCar);
    //         // the trick is to remove the marker (by id)
    //         // and add it again at the updated location
    //         // markers.removeWhere((marker) => marker.markerId.value == "me");
    //         // markers.add(Marker(
    //         //     markerId: MarkerId('me'),
    //         //     position: pinPosition, // updated position
    //         //     icon: bitmapDescriptorBlue
    //         // ));
    //         // print(markers);
    //       }
    //       _bloc.add(GetTripEvent());
    //     });
    // _myRecorder.openAudioSession().then((value) {
    //  print("value sound: $value");
    // });
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
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    // the trick is to remove the marker (by id)
    // and add it again at the updated location
    // markers.removeWhere((marker) => marker.markerId.value == "me");
    // markers.add(Marker(
    //     markerId: MarkerId('me'),
    //     position: pinPosition, // updated position
    //     icon: bitmapDescriptorBlue
    // ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    positionStream = Geolocator.getPositionStream(distanceFilter: 500)
        .listen((Position position) {
      print('position::$position');
      if (position != null) {
        currentLocation = position;
        print('$currentLocation');
        _center = LatLng(currentLocation?.latitude, currentLocation?.longitude);
        //updatePinOnMap();
        var pinPosition =
            LatLng(currentLocation.latitude, currentLocation.longitude);
        // the trick is to remove the marker (by id)
        // and add it again at the updated location
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
    flutterTts.setStartHandler(
      () {
        ttsState = TtsState.playing;
      },
    );

    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      ttsState = TtsState.stopped;
    });
    flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stopped;
    });

    setTtsLanguage();
    flutterTts.setVolume(1);
    flutterTts.setSpeechRate(0.6);
    flutterTts.setPitch(1);
  }

  void setTtsLanguage() async {
    // flutterTts.getLanguages.then((value) => print(value));
    var lang = currentLang == 'fil'
        ? "fil-PH"
        : currentLang == 'en'
            ? "en-US"
            : currentLang == 'hi'
                ? "hi-IN"
                : currentLang == 'ur'
                    ? "ur-PK"
                    : currentLang == 'es'
                        ? "es-ES"
                        : "ar";
    print(lang);
    flutterTts.setLanguage(lang);
  }

// convert asset images to BitmapDescriptor
  setSourceAndDestinationIcons() async {
    bitmapDescriptorRed = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0),
      'assets/images/flag.png',
    );
    bitmapDescriptorGreen = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0),
      'assets/images/green-flag.png',
    );
    bitmapDescriptorBlue = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0),
      'assets/images/truck.png',
    );
  }

// get current location and update camera position
  void setInitialLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (currentLocation != null) {
      _center = LatLng(currentLocation?.latitude, currentLocation?.longitude);
      _cameraPosition = CameraPosition(
        zoom: cameraZoom,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
      );
      CameraUpdate update = CameraUpdate.newCameraPosition(_cameraPosition);
      // _mapController.moveCamera(update);
      // _cameraPosition = CameraPosition(
      //   zoom: cameraZoomIn,
      //   target: _center,
      // );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(update);
    }
  }

  addNewRisk() {
    // await record();
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
    print(_newVoiceText);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        for (int i = 0; i < 2; i++) {
          await flutterTts.awaitSpeakCompletion(true);
          await flutterTts.speak(_newVoiceText);
        }
      }
    }
  }

  Future _speakSlider(_newVoiceText) async {
    print(_newVoiceText);
    flutterTts.stop();
    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(_newVoiceText);
      }
    }
  }

  String distanceText(distance) {
    final di = (distance / 1000).toString().substring(0, 3);
    var record = '';
    if (currentLang == 'ar') {
      record = " على بُعد $di كيلو متر";
    } else if (currentLang == 'fil') {
      record = "$di kilometers ang layo";
    } else if (currentLang == 'hi') {
      record = " $di किमी दूर";
    } else if (currentLang == 'ur') {
      record = " $di کلومیٹر دور ";
    } else {
      record = " $di kilometers away";
    }
    return record;
  }

  show({String message, String title, bool flag}) {
    AlertDialog alert = AlertDialog(
      title: Center(
          child: Text(
        translator.translate(title),
        style: TextStyle(
            fontSize: 20,
            fontFamily: FONT_FAMILY,
            fontWeight: FontWeight.w600,
            color: flag ? Colors.green : Colors.red),
      )),
      content: Text(
        translator.translate(message),
        style: TextStyle(
            fontSize: 16, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w400),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return alert;
      },
    );
  }

  moveCamera() async {
    _center = LatLng(currentLocation?.latitude, currentLocation?.longitude);
    _cameraPosition = CameraPosition(zoom: cameraZoom, target: _center);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  _launchCaller() {
    _bloc.add(SupportMobileEvent());
  }

  _callSupport(mobile) async {
    final url = "tel:$mobile";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void runRisk(RiskModel risk) async {
    await _getPolyline(
        originLatitude: currentLocation?.latitude,
        originLongitude: currentLocation?.longitude,
        destLatitude: double.parse(risk.lat),
        destLongitude: double.parse(risk.long),
        riskID: risk.riskId.toString());
    _blocRisk.add(RunRiskEvent(risk: risk));
    removeEnable = true;
    var riskText = (currentLang == 'en') ? risk.riskEn : risk.riskAr;
    currentTrip = risk;
    var record = distanceText(risk.distance);
    riskText = '$riskText $record';
    _speak(riskText);
    Future.delayed(const Duration(seconds: 20), () async {
      runRisks.removeWhere((elRisk) => elRisk.riskId == risk.riskId);
      markers.removeWhere((el) => el.markerId.value == risk.riskId.toString());
      setInitialLocation();
      var id = 'risk${risk.riskId}';
      markerRed = new RippleMarker(
          // visible: false,
          markerId: MarkerId(id),
          position: LatLng(double.parse(risk.lat), double.parse(risk.long)),
          ripple: false, //Ripple state
          infoWindow: InfoWindow(title: risk.riskAr, snippet: risk.riskAr),
          icon: bitmapDescriptorGreen,
          onTap: null,
          consumeTapEvents: true);
      // final Marker marker = Marker(
      //   markerId: MarkerId(id),
      //   position: LatLng(double.parse(risk.lat), double.parse(risk.long)),
      //   icon: bitmapDescriptorGreen,
      //   consumeTapEvents: true,
      //   onTap: null,
      // );
      markersRed[MarkerId(id)] = markerRed;
      // final Marker marker = Marker(
      //   markerId: MarkerId(risk.riskId.toString()),
      //   position: LatLng(double.parse(risk.lat), double.parse(risk.long)),
      //   icon: bitmapDescriptorGreen,
      //   consumeTapEvents: true,
      //   onTap: null,
      // );
      // markers.add(marker);
      // markers.add(marker);
      repeatRisks.add(risk);
      polyline.removeWhere(
          (element) => element.polylineId.value == risk.riskId.toString());
      _blocRisk.add(DoneRiskEvent(risk: risk));
    });
  }

  updateRiskData(RiskModel risk) async {
    await DBHelper.updateWhere(
        done: 0, distance: risk.distance, riskId: risk.riskId);
  }

  void runRepeatRisk(RiskModel risk) async {
    await _getPolyline(
        originLatitude: currentLocation?.latitude,
        originLongitude: currentLocation?.longitude,
        destLatitude: double.parse(risk.lat),
        destLongitude: double.parse(risk.long),
        riskID: risk.riskId.toString());
    _blocRisk.add(RunRepeatRiskEvent(risk: risk));
    removeEnable = true;
    var riskText = (currentLang == 'en') ? risk.riskEn : risk.riskAr;
    newRisk = risk;
    var record = distanceText(risk.distance);
    riskText = '$riskText $record';
    _speak(riskText);
    Future.delayed(const Duration(seconds: 20), () async {
      repeatRisks.removeWhere((elRisk) => elRisk.riskId == risk.riskId);
      setInitialLocation();

      // var id = 'repeatRisk${risk.riskId}';
      var id = 'risk${risk.riskId}';

      markerRed = new RippleMarker(
          markerId: MarkerId(id),
          position: LatLng(double.parse(risk.lat), double.parse(risk.long)),
          ripple: false, //Ripple state
          infoWindow: InfoWindow(title: risk.riskAr, snippet: risk.riskAr),
          icon: bitmapDescriptorGreen,
          onTap: null,
          consumeTapEvents: true);
      markersRed[MarkerId(id)] = markerRed;
      polyline.removeWhere(
          (element) => element.polylineId.value == risk.riskId.toString());
      _blocRisk.add(DoneRepeatRiskEvent());
    });
  }

  repeatRisk() {
    if (runRisks.length == 0) {
      repeatRisks.forEach((element) {
        double distanceInMeters = Geolocator.distanceBetween(
            currentLocation?.latitude,
            currentLocation?.longitude,
            double.parse(element.lat),
            double.parse(element.long));
        // print('Distance for repeat ${element.riskId}::=> $distanceInMeters, Done ${element.done}');
        element.distance = distanceInMeters;
        repeatRisks.firstWhere((el) => el.riskId == element.riskId).distance =
            distanceInMeters;
        if (distanceInMeters > 3000) {
          repeatRisks.removeWhere((el) => el.riskId == element.riskId);
        }
      });
      print(repeatRisks);
      currentRepeatRisk();
    }
  }

  currentRepeatRisk() {
    repeatRisks.sort((a, b) => a.distance.compareTo(b.distance));
    if (repeatRisks.length != 0)
      Future.delayed(const Duration(seconds: 5), () {
        if (repeatRisks.isNotEmpty) runRepeatRisk(repeatRisks.first);
      });
  }

  calculateRisks() {
    // runRisks
    if (currentTrip.riskId == null && runRisks.isEmpty) {
      isFirstTime = true;
    }
    validRisks.forEach((element) {
      final exitRisk = runRisks.indexWhere((el) => el.riskId == element.riskId);
      print(exitRisk);
      if (exitRisk != -1 && currentTrip.riskId != element.riskId) {
        runRisks[exitRisk] = element;
      }

      if (exitRisk == -1) {
        runRisks.add(element);
        final Marker marker = Marker(
          markerId: MarkerId(element.riskId.toString()),
          position:
              LatLng(double.parse(element.lat), double.parse(element.long)),
          icon: bitmapDescriptorRed,
          consumeTapEvents: true,
          onTap: null,
        );
        markers.add(marker);
      }
    });
    print(runRisks.toList());
    if (currentTrip.riskId == null && isFirstTime) {
      currentRisk();
    }
  }

  currentRisk() {
    runRisks.sort((a, b) => a.distance.compareTo(b.distance));
    if (runRisks.length != 0)
      Future.delayed(const Duration(seconds: 10), () {
        print(runRisks.first);
        if (runRisks.isNotEmpty) runRisk(runRisks.first);
      });
  }

  showAsBottomSheet() {
    print("here ${runRisks.length}");
    if (runRisks.length == 0) _bloc.add(GetJobSiteRisksEvent());
  }

  void runBottomSheetContainer(context) async {
    return showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return Container(
            height: 800,
            padding: EdgeInsetsDirectional.only(start: 5, end: 5),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    translator.translate('selectJobSite'),
                    style: TextStyle(
                        fontFamily: FONT_FAMILY,
                        fontWeight: FontWeight.w400,
                        color: Colors.teal,
                        fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Form(
                  key: _formKey,
                  child: Material(
                    child: DropdownSearch<JobSite>(
                      label: translator.translate('jobSites'),
                      items: itemsOfJobSites,
                      selectedItem: selectedJobSite,
                      itemAsString: (JobSite u) =>
                          (currentLang == 'en') ? u.jobsiteEn : u.jobsiteAr,
                      onChanged: (JobSite data) {
                        print(data);
                        selectedJobSite = new JobSite.fromJson(data.toJson());
                        _blocJobSite
                            .add(ChangeJobSiteEvent(jobSite: selectedJobSite));
                      },
                      mode: Mode.DIALOG,
                      showSearchBox: true,
                      showAsSuffixIcons: true,
                      enabled: true,
                      popupTitle: Center(
                        child: Text(
                          translator.translate('jobSites'),
                          style: TextStyle(
                              fontFamily: FONT_FAMILY,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black45),
                        ),
                      ),
                      // onFind: (text) async {
                      //   print("(text) $text");
                      //   return await itemsOfJobSites;
                      // },
                      filterFn: (item, filter) {
                        print("filter$filter");
                        return item.userFilterByJobSiteName(filter);
                      },
                    ),
//                         DropdownButtonFormField<JobSite>(
//                     decoration: InputDecoration(
//                              hintText: translator.translate('jobSites') ,
// //                          contentPadding: EdgeInsets.only(top: 1.0,bottom: 0.0),
//                              hintStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),
//                              prefixIcon: const Icon( Icons.home , color: Colors.teal, ),
//                              border: InputBorder.none
//                          ),
//                          style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600, color: Colors.black45),
//                           value: selectedJobSite,
//                           items: itemsOfJobSites.map((JobSite item) => DropdownMenuItem(
//                             child: Text((currentLang == 'en')?item.jobsiteEn : item.jobsiteAr,
//                               style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black54, fontFamily: FONT_FAMILY),
//                             ),
//                             value: item,
//                           )).toList(),
//                           onChanged: (value) {
//                         selectedJobSite = new JobSite.fromJson(value.toJson());
//                         // imgList = jobSitesData.where((e) => e.jobsiteId == selectedJobSite.jobsiteId ).toList();
//                         // imageSliders = imgList.map((JobSite item) => Container(
//                         //   child: Container(
//                         //     child: ClipRRect(
//                         //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                         //         child: Stack(
//                         //           children: <Widget>[
//                         //             Image.network('${item.image}', fit: BoxFit.cover, width: 1000.0),
//                         //             Positioned(
//                         //               bottom: 0.0,
//                         //               left: 0.0,
//                         //               right: 0.0,
//                         //               child: Container(
//                         //                 decoration: BoxDecoration(
//                         //                   gradient: LinearGradient(
//                         //                     colors: [
//                         //                       Color.fromARGB(200, 0, 0, 0),
//                         //                       Color.fromARGB(0, 0, 0, 0)
//                         //                     ],
//                         //                     begin: Alignment.bottomCenter,
//                         //                     end: Alignment.topCenter,
//                         //                   ),
//                         //                 ),
//                         //                 padding: EdgeInsets.symmetric(
//                         //                     vertical: 10.0, horizontal: 20.0),
//                         //                 child: Text((currentLang == 'en')? item.riskEn : item.riskAr,
//                         //                   style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),
//                         //                 ),
//                         //               ),
//                         //             ),
//                         //           ],
//                         //         )),
//                         //   ),
//                         // )).toList();
//                         // buttonCarouselController.jumpToPage(initPage);
//                         _blocJobSite.add(ChangeJobSiteEvent(jobSite: selectedJobSite));
//                           },
//                         ),
                  ),
                ),
                BlocBuilder<JobSiteBloc, JobSiteState>(
                    bloc: _blocJobSite,
                    builder: (context, state) {
                      // return widget here based on BlocA's state
                      print(state);
                      if (state is ChangeJobSiteRiskState) {
                        lastIndex = state.indexList;
                      }
                      if (state is ChangeJobSiteState) {
                        lastIndex = 0;
                        imgList = state.jobSiteRiskList.data;
                        if (imgList.length > 0) {
                          imageSliders = state.jobSiteRiskList.data
                              .map((JobSite item) => Container(
                                    child: Container(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          child: Stack(
                                            children: <Widget>[
                                              Image.network('${item.image}',
                                                  fit: BoxFit.cover,
                                                  width: 1000.0),
                                              Positioned(
                                                bottom: 0.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            200, 0, 0, 0),
                                                        Color.fromARGB(
                                                            0, 0, 0, 0)
                                                      ],
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                                  child: Text(
                                                    (currentLang == 'en')
                                                        ? item.riskEn
                                                        : item.riskAr,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ))
                              .toList();
                          var text = (currentLang == 'en')
                              ? imgList.first.riskEn
                              : imgList.first.riskAr;
                          _speakSlider(text);
                        }
                      }
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              if (state is LoadingJobSiteState)
                                CircularProgressIndicator(),
                              (imgList.length > 0)
                                  ? Column(
                                      children: [
                                        CarouselSlider(
                                          carouselController:
                                              buttonCarouselController,
                                          items: imageSliders,
                                          options: CarouselOptions(
                                            enlargeCenterPage: true,
                                            // height: 350,
                                            aspectRatio: 16 / 9,
                                            viewportFraction: 0.8,
                                            initialPage: initPage,
                                            enableInfiniteScroll: false,
                                            reverse: false,
                                            autoPlay: true,
                                            autoPlayInterval:
                                                Duration(seconds: 10),
                                            autoPlayAnimationDuration:
                                                Duration(milliseconds: 800),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            onPageChanged: (index, reason) {
                                              print('$index,$reason');
                                              var text = '';
                                              if (reason ==
                                                      CarouselPageChangedReason
                                                          .timed &&
                                                  index < lastIndex) {
                                                // _speak('risk 0');
                                                text = (currentLang == 'en')
                                                    ? imgList.first.riskEn
                                                    : imgList.first.riskAr;
                                                _speakSlider(text);
                                              } else {
                                                text = (currentLang == 'en')
                                                    ? imgList[index].riskEn
                                                    : imgList[index].riskAr;
                                                _speakSlider(text);
                                              }
                                              lastIndex = index;
                                              _blocJobSite.add(
                                                  ChangeJobSiteRiskEvent(
                                                      index: index));
                                            },
                                            pageSnapping: true,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    buttonCarouselController
                                                        .previousPage(),
                                                child: Text('←'),
                                              ),
                                            ),
                                            Center(
                                                child: Text(
                                              "${lastIndex + 1} /${imgList.length}",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                            Flexible(
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    buttonCarouselController
                                                        .nextPage(),
                                                child: Text('→'),
                                              ),
                                            ),
                                            //   imgList.asMap().entries.map((entry) {
                                            //   return GestureDetector(
                                            //     // onTap: () => buttonCarouselController.animateToPage(entry.key),
                                            //     child: Container(
                                            //       width: 15.0,
                                            //       height: 15.0,
                                            //       margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                            //       decoration: BoxDecoration(
                                            //           shape: BoxShape.rectangle,
                                            //           color: (Theme.of(context).brightness == Brightness.dark
                                            //               ? Colors.white
                                            //               : Colors.teal)
                                            //               .withOpacity(1)),
                                            //       child: Center(
                                            //         child: Text("${state.indexList +1}",style: TextStyle(
                                            //           color: Colors.white
                                            //         ),),
                                            //       ),
                                            //     ),
                                            //   );
                                            // }).toList()
                                          ],
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: <Widget>[
                                        Text(translator.translate('noData')),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            height: 200,
                                            child: SvgPicture.asset(
                                              "assets/images/empty1.svg",
                                            )),
                                      ],
                                    )
                            ],
                          ),
                        ),
                      );
                      //
                    }),
              ],
            ),
          );
        });
  }
  //End Functions

  @override
  void dispose() {
    _bloc.close();
    _blocJobSite.close();
    _blocRisk.close();
    positionStream.cancel();
    flutterTts.stop();
    // _myRecorder.closeAudioSession();
    // _myRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build Context");
    final arg = ModalRoute.of(context).settings.arguments as UserModel;
    if (arg != null) userData = arg;

    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: BlocListener<TripBloc, BaseTripState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is TripSuccessState) {
                  validRisks.clear();
                  final tripData = state.trips.data;
                  tripData.forEach((element) {
                    double distanceInMeters = Geolocator.distanceBetween(
                        currentLocation?.latitude,
                        currentLocation?.longitude,
                        double.parse(element.lat),
                        double.parse(element.long));
                    // print('Distance${element.riskId}:=>> $distanceInMeters, Done ${element.done}');
                    element.distance = distanceInMeters;
                    if (distanceInMeters < 2500 &&
                        (element.done == 0 || element.done == null)) {
                      // print('Distance Lower${element.riskId}:=>> $distanceInMeters');
                      validRisks.add(element);
                    } else if (distanceInMeters > 5000 && element.done == 1) {
                      updateRiskData(element);
                    }
                  });
                  calculateRisks();
                  print("validRisks$validRisks");
                  if (currentTrip.riskId == null && newRisk.riskId == null) {
                    setState(() {
                      _cameraPosition = CameraPosition(
                        zoom: cameraZoom,
                        target: _center,
                      );
                      _controller.future.then((controller) =>
                          controller.animateCamera(
                              CameraUpdate.newCameraPosition(_cameraPosition)));
                    });
                  }
                }
                if (state is GetJobSiteRisksSuccessState) {
                  itemsOfJobSites.clear();
                  selectedJobSite = null;
                  if (imgList.isNotEmpty) imgList.clear();
                  if (imageSliders != null) imageSliders.clear();
                  //    jobSitesData = state.jobSiteList.data;
                  //   final Map<String, JobSite> jobSiteMap = new Map();
                  //   jobSitesData.forEach((JobSite item) {
                  //     jobSiteMap[item.jobsiteId] = item;
                  //   });

                  // itemsOfJobSites = jobSiteMap.values.toList();
                  final jobSiteData = state.jobSiteList.data;
                  jobSiteData.forEach((element) {
                    double distanceInMeters = Geolocator.distanceBetween(
                        currentLocation?.latitude,
                        currentLocation?.longitude,
                        double.parse(element.jobsiteLat),
                        double.parse(element.jobsiteLong));
                    if (distanceInMeters < 2000) {
                      itemsOfJobSites.add(element);
                    }
                  });
                  itemsOfJobSites = itemsOfJobSites.length > 0
                      ? itemsOfJobSites
                      : jobSiteData;
                  runBottomSheetContainer(context);
                }
                if (state is TripLoadingState) loadingAlertDialog(context);
                if (state is TripStartState) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginWidget.routeName, (Route<dynamic> route) => false);
                }
                if (state is TripFailedState) {
                  Navigator.of(context).pop();
                  show(
                      title: "errorTitle",
                      flag: false,
                      message: "errorMessage");
                }
                if (state is RemoveRiskSaveState) {
                  Navigator.of(context).pop();
                  show(
                      message: "removeHazarMessage",
                      flag: true,
                      title: "successTitle");
                }
                if (state is AddRiskSaveState) {
                  Navigator.of(context).pop();
                  show(
                      message: "addHazarMessage",
                      flag: true,
                      title: "successTitle");
                }
                if (state is TripCompletedState) {
                  userData = state.userData;
                  Navigator.of(context).pop();
                  show(
                      title: "successTitle",
                      flag: true,
                      message: "tripCompletedMessage");
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
                    print("rebuild");
                    if (state is RunRiskState) {
                      print("RunRiskState");
                      var id = 'risk${state.risk.riskId}';
                      markerRed = new RippleMarker(
                          visible: true,
                          markerId: MarkerId(id),
                          position: LatLng(double.parse(state.risk.lat),
                              double.parse(state.risk.long)),
                          ripple: true, //Ripple state
                          infoWindow: InfoWindow(
                              title: state.risk.riskAr,
                              snippet: state.risk.riskAr),
                          icon: bitmapDescriptorRed,
                          onTap: null,
                          consumeTapEvents: true);
                      markersRed[MarkerId(id)] = markerRed;
                      _cameraPosition = CameraPosition(
                        zoom: cameraZoom,
                        target: LatLng(double.parse(state.risk.lat),
                            double.parse(state.risk.long)),
                      );
                      _controller.future.then((controller) =>
                          controller.animateCamera(
                              CameraUpdate.newCameraPosition(_cameraPosition)));
                    } else if (state is RunRepeatRiskState) {
                      print("RunRepeatRiskState");
                      var id = 'risk${state.risk.riskId}';
                      markerRed = new RippleMarker(
                          visible: true,
                          markerId: MarkerId(id),
                          position: LatLng(double.parse(state.risk.lat),
                              double.parse(state.risk.long)),
                          ripple: true, //Ripple state
                          infoWindow: InfoWindow(
                              title: state.risk.riskAr,
                              snippet: state.risk.riskAr),
                          icon: bitmapDescriptorGreen,
                          onTap: null,
                          consumeTapEvents: true);
                      markersRed[MarkerId(id)] = markerRed;
                      // _center = LatLng(double.parse(state.risk.lat), double.parse(state.risk.long));
                      _cameraPosition = CameraPosition(
                        zoom: cameraZoom,
                        target: LatLng(double.parse(state.risk.lat),
                            double.parse(state.risk.long)),
                      );
                      _controller.future.then((controller) =>
                          controller.animateCamera(
                              CameraUpdate.newCameraPosition(_cameraPosition)));
                    } else {
                      print('currentLocation');
                      // if (currentLocation != null) {
                      //   _center = LatLng(currentLocation.latitude, currentLocation.longitude);
                      //   CameraPosition cPosition = CameraPosition(
                      //     zoom: cameraZoom,
                      //     // tilt: cameraTilt,
                      //     // bearing: cameraBearing,
                      //     target: _center,
                      //   );
                      //   _controller.future.then((controller) => controller.animateCamera(CameraUpdate.newCameraPosition(cPosition)));                    }

                    }
                    return Stack(children: <Widget>[
                      Animarker(
                        mapId: _controller.future
                            .then((value) => value.mapId), //Grab Google Map Id
                        rippleRadius:
                            0.5, //[0,1.0] range, how big is the circle
                        rippleColor: Colors.red, // Color of fade ripple circle
                        rippleDuration:
                            Duration(seconds: 20), //Pulse ripple duration
                        useRotation: false,
                        shouldAnimateCamera: false,
                        markers: markersRed.values.toSet(),
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          markers: markers.toSet(),
                          polylines: polyline.toSet(),
                          buildingsEnabled: true,
                          initialCameraPosition: _cameraPosition,
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
                            ..add(Factory<PanGestureRecognizer>(
                                () => PanGestureRecognizer()))
                            ..add(Factory<ScaleGestureRecognizer>(
                                () => ScaleGestureRecognizer()))
                            ..add(Factory<TapGestureRecognizer>(
                                () => TapGestureRecognizer()))
                            ..add(Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer()))
                            ..add(Factory<HorizontalDragGestureRecognizer>(
                                () => HorizontalDragGestureRecognizer())),
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
                          children: [
                            // TODO Check IT
                            (shipmentId != null)
                                ? Expanded(
                                    child: Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.green,
                                        child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            radius: 25,
                                            onTap: startShipment,
                                            splashColor: Colors.lightGreen
                                                .withOpacity(0.6),
                                            highlightColor: Colors.lightGreen
                                                .withOpacity(0.6),
                                            child: Container(
                                              child: TextButton.icon(
                                                onPressed: completeShipment,
                                                icon: Icon(
                                                  Icons.done_all,
                                                  color: Colors.white,
                                                ),
                                                label: Text(
                                                  translator
                                                      .translate('endTrip'),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: FONT_FAMILY,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ))))
                                : Expanded(
                                    child: Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.orange,
                                        child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            radius: 25,
                                            onTap: startShipment,
                                            splashColor: Colors.deepOrange
                                                .withOpacity(0.6),
                                            highlightColor: Colors.deepOrange
                                                .withOpacity(0.6),
                                            child: Container(
                                              child: TextButton.icon(
                                                onPressed: startShipment,
                                                icon: Icon(
                                                  Icons.local_shipping,
                                                  color: Colors.white,
                                                ),
                                                label: Text(
                                                  translator
                                                      .translate('startTrip'),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: FONT_FAMILY,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            )))),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Material(
                                  borderRadius: BorderRadius.circular(4),
                                  elevation: 5,
                                  color: Colors.red,
                                  child: TextButton.icon(
                                    onPressed: addNewRisk,
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      translator.translate('addHazar'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: FONT_FAMILY,
                                          fontWeight: FontWeight.w400),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey[200];
                                        }
                                        return Colors.red;
                                      }),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Colors.redAccent;
                                        }
                                        return Colors.transparent;
                                      }),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          top: 80,
                          left: 20,
                          right: 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                padding: EdgeInsets.all(3),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: Material(
                                  elevation: 6,
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  child: IconButton(
                                      onPressed: _launchCaller,
                                      icon: Icon(Icons.call,
                                          color: Colors.green, size: 30)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.all(3),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: Material(
                                  elevation: 6,
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  child: IconButton(
                                      onPressed: showAsBottomSheet,
                                      icon: Icon(Icons.home,
                                          color: Colors.orange, size: 30)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.all(3),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: Material(
                                  elevation: 6,
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  child: IconButton(
                                      onPressed: repeatRisk,
                                      icon: Icon(Icons.refresh,
                                          color: Colors.blue, size: 30)),
                                ),
                              ),
                              if(userData.company=="Safety")Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.all(3),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: Material(
                                  elevation: 6,
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                                  child: IconButton(
                                      onPressed: ()
                                      {
                                        (shipmentId != null)?
                                        show(
                                            title: "You must ent trip",
                                            flag: false,
                                            message: "You must ent trip"):Navigator.pushReplacementNamed(
                                            context, SafetyDestinationsPage.routeName,
                                            arguments: userData);
                                      },
                                      icon: Icon(Icons.arrow_back,
                                          color: Colors.blue, size: 30)),
                                ),
                              ),
                            ],
                          )),
                      if (state is RunRiskState)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 20.0,
                              ),
                              padding: EdgeInsets.all(5),
                              height: 150.0,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black54,
                                      offset: Offset(0.0, 4.0),
                                      blurRadius: 10.0,
                                    ),
                                  ]),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Container(
                                        //   height: 60.0,
                                        //   width: 60.0,
                                        //   child:  Material(
                                        //       elevation: 6,
                                        //       borderRadius: BorderRadius.all(Radius.circular(50)),
                                        //       child: Icon(Icons.play_circle_outline,color:Colors.teal,size: 40,)),
                                        // ),
                                        // SizedBox(width: 6.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  (currentLang == 'en')
                                                      ? state.risk.riskEn
                                                      : state.risk.riskAr,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 6.0),
                                              Text(
                                                '${(state.risk.distance / 1000).toString().substring(0, 3)} Km',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                  OutlinedButton.icon(
                                    onPressed: removeEnable ? removeRisk : null,
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      translator.translate('removeHazar'),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: FONT_FAMILY,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color: Colors.red, width: 2),
                                      )),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey[200];
                                        }
                                        return Colors.white;
                                      }),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Colors.red;
                                        }
                                        return Colors.transparent;
                                      }),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      if (state is RunRepeatRiskState)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 20.0,
                              ),
                              padding: EdgeInsets.all(5),
                              height: 150.0,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black54,
                                      offset: Offset(0.0, 4.0),
                                      blurRadius: 10.0,
                                    ),
                                  ]),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Container(
                                        //   height: 60.0,
                                        //   width: 60.0,
                                        //   child:  Material(
                                        //       elevation: 6,
                                        //       borderRadius: BorderRadius.all(Radius.circular(50)),
                                        //       child: Icon(Icons.play_circle_outline,color:Colors.teal,size: 40,)),
                                        // ),
                                        // SizedBox(width: 6.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  (currentLang == 'en')
                                                      ? state.risk.riskEn
                                                      : state.risk.riskAr,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 6.0),
                                              Text(
                                                '${(state.risk.distance / 1000).toString().substring(0, 3)} Km',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                  OutlinedButton.icon(
                                    onPressed: removeEnable ? removeRisk : null,
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      translator.translate('removeHazar'),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: FONT_FAMILY,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color: Colors.red, width: 2),
                                      )),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return Colors.grey[200];
                                        }
                                        return Colors.white;
                                      }),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
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
                  listener: (context, state) {
                    // if (state is RiskLoadingState ) loadingAlertDialog(context);
                    if (state is DoneRiskState) {
                      currentTrip = new RiskModel();
                      currentRisk();
                    }
                    if (state is DoneRepeatRiskState) {
                      newRisk = new RiskModel();
                      repeatRisk();
                    }
                  }),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            highlightElevation: 20,
            tooltip: 'Current Location',
            elevation: 10,
            onPressed: setInitialLocation,
            child: Icon(Icons.gps_fixed, color: Colors.white, size: 25)),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  _addPolyLine(riskID) {
    PolylineId id = PolylineId(riskID);
    Polyline newPolyline = Polyline(
        polylineId: id,
        color: Colors.orange,
        width: 4,
        points: polylineCoordinates);
    polylines[id] = newPolyline;
    print(polylines);
    Polyline currentRisk = polylines[PolylineId(riskID)];
    polyline.add(currentRisk);
  }

  _getPolyline(
      {originLatitude,
      originLongitude,
      destLatitude,
      destLongitude,
      riskID}) async {
    polylineCoordinates.clear();
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(originLatitude, originLongitude),
        PointLatLng(destLatitude, destLongitude),
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
      _addPolyLine(riskID);
    } catch (e) {}
  }
}
