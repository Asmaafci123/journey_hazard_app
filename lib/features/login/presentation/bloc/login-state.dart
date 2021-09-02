import 'package:journeyhazard/core/base_bloc/base_bloc.dart';
import 'package:journeyhazard/core/errors/base_error.dart';
import 'package:journeyhazard/core/errors/custom_error.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';

class BaseLoginState {}

class LoginSuccessState extends BaseLoginState {
  UserModel userData;
  LoginSuccessState({this.userData});
}

class LoginLoadingState extends BaseLoginState {}

class LoginFailedState extends BaseLoginState {
  final  error;
  LoginFailedState(this.error);
}