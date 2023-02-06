import 'package:journeyhazard/core/errors/custom_error.dart';
import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journeyhazard/core/base_bloc/base_bloc.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/mobile/data/repositories/mobile-repositories-implementation.dart';
import 'package:journeyhazard/features/splsh/presentation/repositories/splsh-repositories-implementation.dart';
import 'mobile-events.dart';
import 'mobile-state.dart';

class SendMobileBloc extends Bloc<BaseMobileEvent, BaseSendMobileState> {
  SendMobileBloc(BaseSendMobileState initialState) : super(initialState);

  @override
  Stream<BaseSendMobileState> mapEventToState(BaseMobileEvent event) async* {
    SplashRepositoryImplementation res = new SplashRepositoryImplementation();
    MobileRepositoryImplementation countryRes = new MobileRepositoryImplementation();
    if (event is  GetCountriesEvent) {
      yield  SendMobileLoadingState();
      final result = await countryRes.getCountries();
      if(result.hasDataOnly){
        yield GetCountriesSuccessState(result.data);
      } else {
        final CustomError error = result.error;
        yield SendMobileFailedState(error);
      }
    }
    if(event is ChangeMobileEvent) {
      yield ChangeMobileSuccessState();
    }
    if (event is  SendMobileEvent) {
      yield  SendMobileLoadingState();
      print('hr${event.userModel.toJson()}');
      UserModel userData;
      final driverDataDB =  await DBHelper.getData('driver_data');
      if(driverDataDB.isEmpty)
        {
          DBHelper.insert('driver_data', event.userModel.toJson());
          final dt=await DBHelper.getData('driver_data');
          print(dt.length);
          userData = UserModel.fromJson(dt.first);
        }
      else
      {
        DBHelper.update('driver_data', event.userModel.destination, "destination");
        final dt=await DBHelper.getData('driver_data');
        print(dt.length);
        userData = UserModel.fromJson(dt.first);
      }
      await res.allRisk();
      yield  SendMobileSuccessState(userData: userData);

    }
    if (event is  GetAllDestinations) {
      yield  SendMobileLoadingState();
      final result = await countryRes.getAllDestinations();
      if(result.hasDataOnly){
        List<String> destinations=[];
        for(var element in result.data)
          {
           destinations.add(element.toString());
          }
        yield  GetDestinationsSuccessState(destinations);
      } else {
        final CustomError error = result.error;
        yield SendMobileFailedState(error);
      }
    }
  }
}
