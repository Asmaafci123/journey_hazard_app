import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/splsh/presentation/bloc/splash-state.dart';
import 'package:journeyhazard/features/splsh/presentation/bloc/splash-event.dart';
import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
import 'package:journeyhazard/features/splsh/presentation/repositories/splsh-repositories-implementation.dart';


class SplashBloc extends Bloc<BaseSplashEvent, BaseSplashState> {
  SplashBloc(BaseSplashState initialState) : super(initialState);

  @override
  Stream<BaseSplashState> mapEventToState(BaseSplashEvent event) async* {
    SplashRepositoryImplementation res = new SplashRepositoryImplementation();
    // TODO: implement mapEventToState
//    final dataDB =  await DBHelper.getData('cemex_risk');
    final driverDataDB =  await DBHelper.getData('driver_data');
    UserModel userData;
//    print(driverDataDB);
    if(driverDataDB.isNotEmpty) userData=  UserModel.fromJson(driverDataDB.first);


    try {

       if(event is GetSplashEvent){
        yield SplashLoadingState();
        if(userData != null && userData.mobile.isNotEmpty){
          if(userData.company=="Safety")
            {
              yield SplashSuccessState(goToLoginPage: false,goToSafetDestinationsPage: true, goToHomePage: false, goToMobilePage: false, userData: userData);
            }
          else
            {
              res.allRisk();
              yield SplashSuccessState(goToLoginPage: false, goToSafetDestinationsPage: false,goToHomePage: true, goToMobilePage: false, userData: userData);
            }
       } else {
         yield SplashSuccessState(goToLoginPage: false,goToSafetDestinationsPage: false, goToHomePage: false, goToMobilePage: true);
       }
      }
    } catch (e, s) {
//      print(e);
//      print(s);
    }
  }
}
