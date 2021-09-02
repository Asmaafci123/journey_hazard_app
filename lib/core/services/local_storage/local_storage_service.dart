import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class LocalStorageService {

  /// set and get fro truckData
  getTruckModel() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> truckMap;
    final String truckStr = prefs.getString('truckNumber');
    if (truckStr != null) {
      truckMap = jsonDecode(truckStr);
    }
    if (truckMap != null) {
//      final TruckNumberModel truckNumberData = TruckNumberModel.fromJson(truckMap);
      return ;
    }
//    TruckNumberModel truckNumberModel = TruckNumberModel(TruckNumber:"ي ب ر 5612",
//        SapTruckNumber: "RNT-ي ب ر 5612",FirebaseToken: "ftHoN_SzRh6KEWjxs1Lzv9:APA91bGFavBqizKYdAoQ1Xk0uGy8JaK80Bkb3hzl0kBAaj5IV_Hgh01RZvkDlc57AjBSNb7gzHv_HMVueVuTiYa_ZTTW6eNSvmbeJ4VHer2H9DgmL7t-jFH3aC4CmvAcJ-rYAqI_tS7c");
//    return truckNumberModel;
    return null;
  }

  setTruckModel({ truckNumberModel}) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String,dynamic> truckNumberMap = truckNumberModel.toJson();
    await prefs.setString('truckNumber',json.encode(truckNumberMap));

  }
  /// set and get fro ShipmentID
  getShipmentID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String shipmentIDStr = prefs.getString('shipmentID');
    if (shipmentIDStr != null) {
      return shipmentIDStr;
    }
    return null;
  }

  setShipmentID(String id) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('shipmentID',id);
  }

  removeShipmentID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('shipmentID');
  }
  /// set and get fro Token
  getToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String tokenStr = prefs.getString('token');
    if (tokenStr != null) {
      return tokenStr;
    }
    return null;
  }

  setToken(String token) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token',token);
  }

  removeToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
/// set and get fro TripData Object
  getCurrentTrip() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> currentTripMap;
    final String currentTripStr = prefs.getString('currentTrip');
    if (currentTripStr != null) {
      currentTripMap = jsonDecode(currentTripStr);
    }

    if (currentTripMap != null) {
//      final  currentTripData = NotificationModel.fromJson(currentTripMap);
      return ;
    }
    return null;
  }

  setCurrentTrip({ tripModel}) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String,dynamic> tripMap = tripModel.toJson();
    await prefs.setString('currentTrip',json.encode(tripMap));
  }

  removeCurrentTrip() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('currentTrip');
  }
/// set and get fro TripStatus
  getTripStatus() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String tripStatus = prefs.getString('status');
    if (tripStatus != null) {
      return tripStatus;
    }
    return null;
  }

 setTripStatus(String status) async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString('status', status);
}

  /// set and get fro DriverID
  getDriverID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String driverId = prefs.getString('driverId');
    if (driverId != null) {
      return driverId;
    }
    return null;
  }

  setDriverID(String driverId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('driverId', driverId);
  }

  removeDriverID( ) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('driverId');
  }

  setSeenToTrue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setBool('seen', true);
  }

   fitchSeen() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool value = (prefs.getBool('seen') ?? false) ;
    return value;
  }

}
