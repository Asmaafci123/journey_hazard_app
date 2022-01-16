import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:journeyhazard/core/constants.dart';
import 'package:journeyhazard/core/errors/bad_request_error.dart';
import 'package:journeyhazard/core/errors/custom_error.dart';
import 'package:journeyhazard/core/repositories/core_repository.dart';
import 'package:journeyhazard/core/results/result.dart';
import 'package:journeyhazard/core/models/empty_response_model.dart';
import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/login/domain/repositories/user-repositories.dart';
import 'package:journeyhazard/core/services/http_service/http_service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:journeyhazard/features/trips/data/models/trips.dart';

// TODO: I comment this class , till the API is ready @AzharOmar
class SplashRepositoryImplementation {
  final  httpCall = HttpService();

  @override
  Future<Result<RemoteResultModel<dynamic>>> allRisk () async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final driverDataDB =  await DBHelper.getData('driver_data');
    UserModel userMobileData;
//    print(driverDataDB);
    if(driverDataDB.isNotEmpty) {
      userMobileData=  UserModel.fromJson(driverDataDB.first);
    }
    var lat = '';
    var long = '';
    if(position != null) {
      lat = position?.latitude.toString();
      long = position?.longitude.toString();
    }
    var userData =
    {"Risk_ID": 0,
      "Risk_AR": "2344",
      "Risk_EN": "nohaaaaaaa",
      "Lat": lat,
      "Long": long,
      "Comment": "01-02-3009",
      "Active": "false",
      "Shipment_ID" :  '0',
      "MobileNumber" : userMobileData.mobile.toString(),
      "Country": userMobileData.country,
      "Company": userMobileData.company,
    };
//    print(userData);
    // TODO: implement LoginUser
    final response = await CoreRepository.request(url: allRiskUrl, method: HttpMethod.POST, converter: null, data:userData);
    if (response.hasDataOnly) {
//      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel.fromJson(res);
      if (_data.flag) {
        final res = _data.data;
        TripsModel newData=  TripsModel.fromJson({"data":res});
        if ( newData.data.isNotEmpty) {
          await DBHelper.deleteAll('cemex_risk');
          newData.data.forEach((element) {
            var newElement = element.toJson();
            // newElement.remove('distance');
            DBHelper.insert('cemex_risk', newElement);
          });
        }
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
      return Result(error: CustomError(message:response.error.toString()));
    }
  }
}
