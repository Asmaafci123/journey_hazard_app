import 'package:flutter/material.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';

const String TAG = 'azhar >>>>>>';
const APP_NAME = 'journeyhazard';
// URL
const String baseUrl = "http://20.86.97.165/hazard/api";
const String loginUrl = baseUrl + '/Shipment/Update';
const String addHazard = baseUrl +'/DriverFeedback/Add';
const String doneHazard = baseUrl + '/ShipmentRisk/Update';
const String completeShipmentUrl = baseUrl +'/Shipment/Complete';
const String allRiskUrl = baseUrl +'/Shipment/AllRisk';
const String allCountriesUrl = baseUrl +'/risk/CountryList';
const String MobileSupportUrl = baseUrl +'/Risk/SupportByCountry';



const FONT_FAMILY = 'Almarai';
const MAP_API_KEY = 'AIzaSyBVZcghBdxyoRcpEIJ69V5uOfn_nK2kKSY';
const KEY_FIRST_START = '${APP_NAME}KEY_FIRST_START';
const KEY_FIRE_BASE_TOKEN = '${APP_NAME}KEY_FIRE_BASE_TOKEN';
const KEY_CALENDAR_ID = '${APP_NAME}CALENDAR_ID';


// ignore: non_constant_identifier_names
final HORIZONTAL_PADDING = ScreensHelper.fromWidth(4.5);

const SESSION_STATUS_DRAFT = 'Draft';
const SESSION_STATUS_CONFIRMED = 'Draft';
const SESSION_STATUS_CANCELLED = 'Draft';
const SESSION_STATUS_PENDING = 'Pending';
const SHHNATY_BACK_GROUND = 'assets/images/splash.png';
const SHHNATY_LOGO = 'assets/images/cemex.jpg';
const EDIT_MODE = 'edit';
const ADD_MODE = 'add';

const USER_TYPE_PT = 'PT';
const USER_TYPE_CLIENT = 'Client';

// ignore: non_constant_identifier_names
final double GENERAL_HORIZONTAL_PADDING = ScreensHelper.fromWidth(4.5);
// ignore: non_constant_identifier_names
final BorderRadius GLOBAL_BORDER_RADIUS =
    BorderRadius.circular(ScreensHelper.fromWidth(1.5));

const int MIN_PASSWORD_LENGTH = 6;
const int CODE_LENGTH = 5;

 const _kFontFam = 'MyFlutterApp';
 const String _kFontPkg = null;

 const IconData whatsapp = IconData(0xf232, fontFamily: _kFontFam, fontPackage: _kFontPkg);


 String shipmentId = '';
 UserModel userDataRef;
