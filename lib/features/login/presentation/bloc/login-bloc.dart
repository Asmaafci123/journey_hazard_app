import 'package:journeyhazard/core/errors/custom_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journeyhazard/core/base_bloc/base_bloc.dart';
import 'package:journeyhazard/core/constants.dart';
import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/login/data/repositories/user-repositories-implementation.dart';
import 'package:journeyhazard/features/login/presentation/bloc/login-events.dart';
import 'package:journeyhazard/features/login/presentation/bloc/login-state.dart';

class LoginBloc extends Bloc<BaseEvent, BaseLoginState> {
  LoginBloc(BaseLoginState initialState) : super(initialState);

  @override
  Stream<BaseLoginState> mapEventToState(BaseEvent event) async* {
    // TODO: implement mapEventToState
    LoginRepositoryImplementation repo = new LoginRepositoryImplementation();

    if (event is LoginEvent) {
      yield LoginLoadingState();
      final res = await repo.loginUser(event.userModel);
      if (res.hasErrorOnly) {
//        print('${res.error}');
        final CustomError error = res.error ;
        yield LoginFailedState(error);
      } else {
        final driverDataDB =  await DBHelper.getData('driver_data');
        UserModel userMobileData;
        if(driverDataDB.isNotEmpty)  userMobileData=  UserModel.fromJson(driverDataDB.first);

        yield LoginSuccessState(userData: userMobileData);
      }
    }
  }
}
