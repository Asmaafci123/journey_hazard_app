import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:journeyhazard/core/errors/error_helper.dart';
import 'package:journeyhazard/core/sqllite/sqlite_api.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/trips/data/models/jobsite.dart';
import 'package:journeyhazard/features/trips/data/models/jobsitelist.dart';
import 'package:journeyhazard/features/trips/data/repositories/trips-repository-implementation.dart';
import 'package:meta/meta.dart';

part 'job_site_event.dart';
part 'job_site_state.dart';

class JobSiteBloc extends Bloc<JobSiteEvent, JobSiteState> {
  JobSiteBloc() : super(JobSiteInitial());
  UserModel userData;

  @override
  Stream<JobSiteState> mapEventToState(
    JobSiteEvent event,
  ) async* {
    TripRepositoryImplementation repo = new TripRepositoryImplementation();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final driverDataDB =  await DBHelper.getData('driver_data');
    if(driverDataDB.isNotEmpty) userData=  UserModel.fromJson(driverDataDB.first);
    // TODO: implement mapEventToState
    if(event is ChangeJobSiteEvent) {
      yield LoadingJobSiteState();
      final res = await repo.getRisksByJobSite(position, userData,event.jobSite);
      if (res.hasErrorOnly) {
        final  error = ErrorHelper().getErrorMessage(res.error) ;
        yield JobSiteFailedState(error);
      } else {

        yield ChangeJobSiteState(jobSiteRiskList:  res.data );
      }

    }
    if(event is ChangeJobSiteRiskEvent) {
      yield ChangeJobSiteRiskState(indexList: event.index);
    }
    }
}
