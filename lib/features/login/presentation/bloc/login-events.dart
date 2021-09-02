import 'package:journeyhazard/core/base_bloc/base_bloc.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';

class LoginEvent extends BaseEvent {
  final UserModel userModel;
  LoginEvent({this.userModel});
}
