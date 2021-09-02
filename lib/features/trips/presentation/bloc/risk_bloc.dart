import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
import 'package:journeyhazard/features/trips/data/models/risk.dart';
import 'package:journeyhazard/features/trips/data/repositories/trips-repository-implementation.dart';

part 'risk_event.dart';
part 'risk_state.dart';

class RiskBloc extends Bloc<RiskEvent, RiskState> {

  RiskBloc() : super(RiskInitial());

  @override
  Stream<RiskState> mapEventToState(

    RiskEvent event,
  ) async* {
    TripRepositoryImplementation repo = new TripRepositoryImplementation();

    // TODO: implement mapEventToState
   if(event is DoneRiskEvent) {
    yield RiskLoadingState();
    final res = await repo.doneHazarData(event.risk);
    // ToDo Update Done Colunm In DB
    yield DoneRiskState();
    } else if (event is RunRiskEvent) {
     // ToDo Update Done Colunm In DB
     await DBHelper.updateWhere(done: 1,distance: event.risk.distance,riskId:event.risk.riskId);
     yield RunRiskState(risk: event.risk);
   }


  }
}
