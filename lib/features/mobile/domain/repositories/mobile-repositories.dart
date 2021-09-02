import 'package:journeyhazard/core/models/empty_response_model.dart';
import 'package:journeyhazard/core/results/result.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
// TODO: I comment this class , till the API is ready @azhar

abstract class  MobileRepository {
  Future<Result<RemoteResultModel<String>>>  sendMobileUser(UserModel userModel);
  Future<Result<dynamic>>  getCountries();

}
