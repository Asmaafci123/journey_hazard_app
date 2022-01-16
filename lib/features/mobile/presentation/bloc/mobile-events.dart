import 'package:journeyhazard/core/base_bloc/base_bloc.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';


class BaseMobileEvent{}

class GetCountriesEvent extends BaseMobileEvent{}

class  SendMobileEvent extends BaseMobileEvent {
  final UserModel userModel;
  SendMobileEvent({this.userModel});
}

class ChangeMobileEvent extends BaseMobileEvent{}
