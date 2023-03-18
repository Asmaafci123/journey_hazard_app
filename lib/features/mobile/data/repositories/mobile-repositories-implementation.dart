import 'dart:convert';

import 'package:journeyhazard/core/constants.dart';
import 'package:journeyhazard/core/errors/bad_request_error.dart';
import 'package:journeyhazard/core/errors/custom_error.dart';
import 'package:journeyhazard/core/errors/error_helper.dart';
import 'package:journeyhazard/core/repositories/core_repository.dart';
import 'package:journeyhazard/core/results/result.dart';
import 'package:journeyhazard/core/models/empty_response_model.dart';
import 'package:journeyhazard/features/mobile/data/models/countries.dart';
import 'package:journeyhazard/features/mobile/domain/repositories/mobile-repositories.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/core/services/http_service/http_service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

// TODO: I comment this class , till the API is ready @azhar
class MobileRepositoryImplementation implements MobileRepository {
  final  httpCall = HttpService();

  @override
  Future<Result<RemoteResultModel<String>>> sendMobileUser (UserModel userModel) async {
//    print( userModel.toJson());
    var userData = {
      "MobileNumber": userModel.mobile,
    };
//    print(userData);
    // TODO: implement  ForgotPassword
    final response = await CoreRepository.request(url: loginUrl, method: HttpMethod.POST, converter: null, data:userData);
    if (response.hasDataOnly) {
//      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<String>.fromJson(res);
      if (_data.flag) {
        return Result(data: _data);
      } else {
        final msg = _data.message;
        return Result(error: CustomError(message: msg));
      }
    }
    if (response.hasErrorOnly) {
      return Result(error: response.error);
    }
   // return Result(data: EmptyResultModel());
  }

  @override
  Future<Result<dynamic>> getCountries() async{
    final response = await CoreRepository.request(url: allCountriesUrl, method: HttpMethod.GET, converter: null,);
    if (response.hasDataOnly) {
     print('${response.data} 99999999999999999999999');
      final res = response.data;

      final _data = RemoteResultModel.fromJson(res);
      if (_data.flag) {
        final res = _data.data;
//        print(res);
        CountriesModel newData=  CountriesModel.fromJson({"data":res});
        return Result(data: newData.data);
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
      return Result(error: CustomError(message: ErrorHelper().getErrorMessage(response.error)));
    }
  }

  @override
  Future<Result> getAllDestinations() async{
    final response = await CoreRepository.request(url: destinationsUrl, method: HttpMethod.GET, converter: null,);
    if (response.hasDataOnly) {
     //  print(destinationsUrl);
     //  print("hhhhhhhhhhhhhhhh");
     // print(response.data);
     //  print("hhhhhhhhhhhhhhhh");
      final res = response.data;
      final _data = RemoteResultModel.fromJson(res);
      if (_data.flag) {
        final res = _data.data;
       print(res);
        //CountriesModel newData=  CountriesModel.fromJson({"data":res});
        return Result(data: res);
      }else {
        final msg = _data.message;
        return Result(error: CustomError(message: msg));
      }
    }
    if (response.hasErrorOnly) {
      if(response.error is BadRequestError) {
        BadRequestError error=  response.error ;
        return Result(error: CustomError(message:error.message));
      }
      return Result(error: CustomError(message: ErrorHelper().getErrorMessage(response.error)));
    }
  }
}
