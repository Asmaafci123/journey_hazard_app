import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:journeyhazard/core/errors/custom_error.dart';
import 'package:journeyhazard/core/errors/error_helper.dart';
import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/trips/data/models/trips.dart';
import 'package:journeyhazard/features/trips/data/repositories/trips-repository-implementation.dart';
import 'package:journeyhazard/features/trips/presentation/bloc/trip-events.dart';
import 'package:journeyhazard/features/trips/presentation/bloc/trip-state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripBloc extends Bloc<BaseTripEvent, BaseTripState> {
  TripBloc() : super(BaseTripState());
  TripsModel newData;
  UserModel userData;
  bool showInfo;

  @override
  Stream<BaseTripState> mapEventToState(BaseTripEvent event) async* {
    TripRepositoryImplementation repo = new TripRepositoryImplementation();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final driverDataDB =  await DBHelper.getData('driver_data');
    if(driverDataDB.isNotEmpty) userData=  UserModel.fromJson(driverDataDB.first);

    if(event is GetTripEvent){
//      yield TripLoadingState();
      var dataDB =  await DBHelper.getData('cemex_risk');
      newData=  TripsModel.fromJson({"data":dataDB});

        yield TripSuccessState(trips:newData);
    }
    else if(event is AddHazarEvent) { //AddHazarEvent
        yield TripLoadingState();
        final res = await repo.addHazarData(position);
        if (res.hasErrorOnly) {
          final  error = ErrorHelper().getErrorMessage(res.error) ;
          yield TripFailedState(error);
        } else {
          yield AddRiskSaveState();
      }
    }
    else if(event is DoneHazarEvent) { //DoneHazarEvent
      showInfo = false;
      yield TripLoadingState();
      final res = await repo.doneHazarData(event.risk);
      // ToDo Update Done Colunm In DB
        await DBHelper.updateWhere(done: 1,distance: event.risk.distance,riskId:event.risk.riskId);
        yield TripDoneState();
    }
    else if(event is RemoveHazarEvent) { //RemoveHazarEvent
      yield TripLoadingState();
      final res = await repo.removeHazarData(event.risk);
      // ToDo Check IF Should Remove IT From DB
     await DBHelper.deleteRisk('cemex_risk',event.risk.riskId);
      if (res.hasErrorOnly) {
        // final CustomError error = res.error ;
        final  error = ErrorHelper().getErrorMessage(res.error) ;
        yield TripFailedState(error);
      } else {
        yield RemoveRiskSaveState();
      }
    }
    else if(event is CompleteTripEvent) {
      yield TripLoadingState();
      // Position currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
       final res = await repo.completeShipment(position, userData);
       if (res.hasErrorOnly) {
         // final CustomError error = res.error ;
         final  error = ErrorHelper().getErrorMessage(res.error) ;
         yield TripFailedState(error);
        } else {

          yield TripCompletedState(userData: userData);
        }
    }
    else if(event is StartTripEvent) {
    yield TripLoadingState();
    await DBHelper.deleteAll('cemex_risk');
    await DBHelper.deleteAll('trip_risk');
    await DBHelper.update('driver_data', null , 'shipmentId');
    yield TripStartState();
    }

    else if (event is SupportMobileEvent) {
      yield TripLoadingState();
      final res = await repo.mobileSupport();
      final driverDataDB =  await DBHelper.getData('driver_data');
      if(driverDataDB.isNotEmpty) userData=  UserModel.fromJson(driverDataDB.first);
        yield GetSupportNumberSuccessState(supportNumber: userData.supportNo);
    } else if (event is ShowRiskInfoEvent) {
      showInfo = true;
      yield StartShowRiskInfoState(showInfo: true);
    }

  }
}
