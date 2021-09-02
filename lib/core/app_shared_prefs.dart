import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:journeyhazard/core/ui/widgets/snackbar_and_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AppSharedPreferences {
  static SharedPreferences __spf;

  bool _isInitialized = false;

  /// logging info
  String _firebaseToken;
  String calendarId;
  bool hasFirebaseToken;
  bool isGuest;
  bool isFirstRun;

  /// device info
  String currentAppVersion;
  int os;

  String get firebaseToken => _firebaseToken;

  set firebaseToken(String value) {
    if (value == null) {
      this._firebaseToken = null;
      this.hasFirebaseToken = false;
    } else {
      this._firebaseToken = value;
      this.hasFirebaseToken = true;
    }
  }

  AppSharedPreferences() {
    SharedPreferences.getInstance().then((value) {
      __spf = value;
    });
  }

  init() async {
    if (__spf == null) {
      __spf = await SharedPreferences.getInstance();
      await fitchAndAssignSPValues();
    }
  }

  fitchAndAssignSPValues() async {
    print(toString());

    /// fitch firebase token
    this.firebaseToken = this.fitchFirebaseToken();

    /// set if it is first time the user launch the app
    this.isFirstRun = fitchIsFirstRun();

    this.calendarId = fitchCalendarId();

    try {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        currentAppVersion = packageInfo.version;
      });
    } catch (e, s) {
      print(e);
      print(s);
    }

    _isInitialized = true;

    print('\nafter init .... \n');
    print(toString());
  }

  static bool _beforeInit() {
    if (__spf == null) {
      return true;
    }
    return false;
  }

  inValidateUserInfo(BuildContext context) async {
    /// TODO
    await this.deleteFirebaseToken();
  }

  /// -----------------------------TOKEN OPERATIONS----------------------------

  setFirstRunToFalse() async {
    bool done = await __spf.setBool(KEY_FIRST_START, false);
    this.isFirstRun = false;
    return done;
  }

  bool fitchIsFirstRun() {
    this.isFirstRun = (!(__spf.getBool(KEY_FIRST_START) == null) ||
            __spf.getBool(KEY_FIRST_START) == true) == true;
    return this.isFirstRun;
  }

  // -------------------------------------------------------------------------

  /// -----------------------------CALENDAR OPERATIONS----------------------------

  fitchCalendarId() {
    calendarId = __spf.getString(KEY_CALENDAR_ID);
    return calendarId;
  }

  Future<String> saveCalenderId(String calenderId) async {
    await __spf.setString(KEY_CALENDAR_ID, firebaseToken);
    this.calendarId = calenderId;
    print('$TAG saved calendarId: ${this.calendarId}');
    return this.calendarId;
  }

  Future<bool> deleteCalendarId() async {
    print('$TAG delete Calendar Id ...');
    bool done = await __spf.remove(KEY_CALENDAR_ID);
    return done;
  }
  // -------------------------------------------------------------------------

  /// -----------------------------TOKEN OPERATIONS----------------------------

  String fitchFirebaseToken() {
    firebaseToken = __spf.getString(KEY_FIRE_BASE_TOKEN);
    return firebaseToken;
  }

  Future<String> saveFirebaseToken(String firebaseToken) async {
    assert(firebaseToken != null && firebaseToken != '');
    await __spf.setString(KEY_FIRE_BASE_TOKEN, firebaseToken);
    this.firebaseToken = firebaseToken;
    print('$TAG saved Firebase token: ${this.firebaseToken}');
    return this.firebaseToken;
  }

  Future<bool> deleteFirebaseToken() async {
    print('$TAG delete Firebase Token ...');
    bool done = await __spf.remove(KEY_FIRE_BASE_TOKEN);
    return done;
  }

  /// ------------------------------PRIMARY OPERATIONS------------------------------

  bool hasKey(String key) {
    Set keys = getKeys();
    return keys.contains(key);
  }

  Set<String> getKeys() {
    if (_beforeInit()) return null;
    return __spf.getKeys();
  }

  bool isGuestUser(BuildContext context) {
    if (isGuest) {
      CustomSnackbar.showGuestSnackbar(context);
    }
    return isGuest;
  }
// ------------------------------END PRIMARY OPERATIONS-------------------------------------

}

/// Singleton instance of the Shred prefs.
AppSharedPreferences appSharedPrefs = AppSharedPreferences();
