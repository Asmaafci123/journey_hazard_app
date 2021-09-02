import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:journeyhazard/core/constants.dart';
import 'package:journeyhazard/core/errors/bad_request_error.dart';
import 'package:journeyhazard/core/errors/custom_error.dart';
import 'package:journeyhazard/core/errors/error_helper.dart';
import 'package:journeyhazard/core/repositories/core_repository.dart';
import 'package:journeyhazard/core/results/result.dart';
import 'package:journeyhazard/core/models/empty_response_model.dart';
import 'package:journeyhazard/core/services/http_service/http_service.dart';
import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/trips/data/models/addRisk.dart';
import 'package:journeyhazard/features/trips/data/models/risk.dart';
import 'package:journeyhazard/features/trips/data/models/trips.dart';
import 'package:journeyhazard/features/trips/domain/repositories/trip-repositories.dart';

class TripRepositoryImplementation implements TripRepository {
  final  httpCall = HttpService();

  @override
  Future<Result<RemoteResultModel<dynamic>>> completeShipment (Position currentPosition,  UserModel userData) async {
    // UserModel userData;
    // final driverDataDB =  await DBHelper.getData('driver_data');
    // if(driverDataDB.isNotEmpty) {
    //   userData = UserModel.fromJson(driverDataDB.first);
    // }

    var newRisk =
    {
      "Risk_ID": 0,
      "Risk_AR": "2344",
      "Risk_EN": "complete",
      "Lat": currentPosition.latitude.toString(),
      "Long": currentPosition.longitude.toString(),
      "Comment": "01-02-3009",
      "Active": "false",
      "Shipment_ID" :  userData.shipmentId,
      "MobileNumber" : userData.mobile,
      "country": userData.country,
    };

    final response = await CoreRepository.request(url: completeShipmentUrl, method: HttpMethod.POST, converter: null, data: newRisk);
    if (response.hasDataOnly) {
      final res = response.data;
      final _data = RemoteResultModel.fromJson(res);
      if (_data.flag) {
        final res = _data.data;
        DBHelper.update('driver_data', null , 'shipmentId');
        await DBHelper.deleteAll('cemex_risk');
        TripsModel newData =  TripsModel.fromJson({"data":res});
        newData.data.forEach((element) {
          DBHelper.insert('cemex_risk', element.toJson());
        });
        return Result(data: _data);
      } else {
        final msg = _data.message;
        return Result(error: CustomError(message: msg));
      }
    }
    if (response.hasErrorOnly) {
      if(response.error is BadRequestError) {
        BadRequestError error=  response.error ;
        return Result(error: CustomError(message:error.message));
      }
      return Result(error: CustomError(message:ErrorHelper().getErrorMessage(response.error)));
      // return Result(error: response.error);

    }  }

  @override
  Future<Result<RemoteResultModel<dynamic>>> addHazarData(Position newPosition) async {
    UserModel userData;
//    var dataDB =  await DBHelper.getData('trip_risk');
    final driverDataDB =  await DBHelper.getData('driver_data');
    if(driverDataDB.isNotEmpty) {
      userData = UserModel.fromJson(driverDataDB.first);
    }

    RiskAddModel newRisk = new RiskAddModel(
        riskId: 0,
        lat: newPosition.latitude.toString(),
        long: newPosition.longitude.toString(),
        mobileNumber: userData.mobile,
        shipmentId: userData.shipmentId,
        country: userData.country
    );

//    print(driverDataDB);


//    List list = List();
//    dataDB.map((risk) async{
//      if (risk['status'] == 'New' ) list.add(RiskAddModel.fromJson(risk).toSendJson());
//    }).toList();

//    list.add(newRisk.toSendJson());
//    print(newRisk.toSendJson());
    final response = await CoreRepository.request(url: addHazard,
        method: HttpMethod.POST, converter: null, data: newRisk.toSendJson());
    if (response.hasDataOnly) {
//      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<int>.fromJson(res);

      if (_data.flag) {
        // await DBHelper.deleteByStatus('trip_risk','New');
        return Result(data: _data);

      } else {
//        newRisk.status = "New";
//        DBHelper.insert('trip_risk', newRisk.toSqlJson());
        return Result(error: CustomError(message: _data.message));
      }
    }
    if (response.hasErrorOnly) {
//      print("internet Error Azhar");
//      newRisk.status = "New";
//      DBHelper.insert('trip_risk', newRisk.toSqlJson());
      if(response.error is BadRequestError) {
        BadRequestError error=  response.error ;
        return Result(error: CustomError(message:error.message));
      }
//
      return Result(error: CustomError(message:ErrorHelper().getErrorMessage(response.error)));
//       return Result(error: response.error);

    }
  }

  @override
  Future<Result<RemoteResultModel<dynamic>>> doneHazarData(RiskModel risk) async {
    UserModel userData;
    var dataDB =  await DBHelper.getData('trip_risk');
    final driverDataDB =  await DBHelper.getData('driver_data');
    if(driverDataDB.isNotEmpty) {
      userData = UserModel.fromJson(driverDataDB.first);
    }

    RiskAddModel newRisk = new RiskAddModel(
        riskId: risk.riskId,
        lat: risk.lat,
        long: risk.long,
        mobileNumber: userData.mobile,
        shipmentId: userData.shipmentId,
        country: userData.country
    );

//    print(newRisk.toSqlJson());

    List list = List();
    dataDB.map((risk) async{
      // if (risk['status'] == 'Done' )
        list.add(RiskAddModel.fromJson(risk).toSendJson());
    }).toList();

    list.add(newRisk.toSendJson());
//    print(json.encode(list));
    final response = await CoreRepository.request(url: doneHazard,
        method: HttpMethod.POST, converter: null, data: json.encode(list));
    if (response.hasDataOnly) {
//      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<int>.fromJson(res);
      if (_data.flag) {
        await DBHelper.deleteAll('trip_risk');
        return Result(data: _data);
      } else {
        newRisk.status = 'Done';
        DBHelper.insert('trip_risk', newRisk.toSqlJson());
        return Result(error: CustomError(message: _data.message));
      }
    }
    if (response.hasErrorOnly) {
      newRisk.status = 'Done';
      DBHelper.insert('trip_risk', newRisk.toSqlJson());
      if(response.error is BadRequestError) {
        BadRequestError error=  response.error ;
        return Result(error: CustomError(message:error.message));
      }
      return Result(error: CustomError(message:ErrorHelper().getErrorMessage(response.error)));
    //   return Result(error: response.error);

    }
  }

  @override
  Future<Result<RemoteResultModel<dynamic>>> removeHazarData(RiskModel risk) async {
    UserModel userData;
    final driverDataDB =  await DBHelper.getData('driver_data');
    if(driverDataDB.isNotEmpty) {
      userData = UserModel.fromJson(driverDataDB.first);
    }

    RiskAddModel newRisk = new RiskAddModel(
      riskId: risk.riskId,
      lat: risk.lat,
      long: risk.long,
      mobileNumber: userData.mobile,
      shipmentId: userData.shipmentId,
      country: userData.country
    );

    final response = await CoreRepository.request(url: addHazard,
        method: HttpMethod.POST, converter: null, data: newRisk.toSendJson());
    if (response.hasDataOnly) {
//      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<int>.fromJson(res);

      if (_data.flag) {
        // await DBHelper.deleteByStatus('trip_risk','Remove');
        return Result(data: _data);
      } else {
        return Result(error: CustomError(message: _data.message));
      }
    }
    if (response.hasErrorOnly) {
//      print("internet Error Azhar");
//      newRisk.status = "Remove";
//      DBHelper.insert('trip_risk', newRisk.toSqlJson());
      if(response.error is BadRequestError) {
        BadRequestError error=  response.error ;
        return Result(error: CustomError(message:error.message));
      }
      return Result(error: CustomError(message: ErrorHelper().getErrorMessage(response.error)));
    }
  }

  @override
  Future<Result<dynamic>> mobileSupport() async {
    UserModel userData;
    final driverDataDB =  await DBHelper.getData('driver_data');
    if(driverDataDB.isNotEmpty) {
      userData = UserModel.fromJson(driverDataDB.first);
    }
    var data =
    {
      "Risk_ID": 0,
      "Risk_AR": "2344",
      "Risk_EN": "complete",
      "Lat": '',
      "Long": '',
      "Comment": "01-02-3009",
      "Active": "false",
      "Shipment_ID" :  userData.shipmentId,
      "MobileNumber" : userData.mobile,
      "country": userData.country,
    };
//    print(data);
    // TODO: implement  ForgotPassword
    final response = await CoreRepository.request(url: MobileSupportUrl, method: HttpMethod.POST, converter: null, data:data);
    if (response.hasDataOnly) {
//      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<String>.fromJson(res);
      if (_data.flag) {

      if(_data.data.length > 0)  await DBHelper.update('driver_data', _data.data , 'supportNo');

        return Result(data: _data.data);
      } else {
        final msg = _data.message;
        return Result(error: CustomError(message: msg));
      }
    }
    if (response.hasErrorOnly) {
      return Result(error: CustomError(message: ErrorHelper().getErrorMessage(response.error)));
    }
  }

}
