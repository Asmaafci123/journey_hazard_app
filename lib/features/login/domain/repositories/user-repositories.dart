import 'package:journeyhazard/core/models/empty_response_model.dart';
import 'package:journeyhazard/core/results/result.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
// TODO: I comment this class , till the API is ready @Abeer

abstract class UserRepository {
  Future<Result<RemoteResultModel<dynamic>>> loginUser(UserModel userModel);
}
