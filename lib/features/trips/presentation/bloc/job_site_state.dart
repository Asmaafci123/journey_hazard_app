part of 'job_site_bloc.dart';

@immutable
abstract class JobSiteState {}

class JobSiteInitial extends JobSiteState {}

class ChangeJobSiteState  extends JobSiteState {
  final JobSiteList jobSiteRiskList;
  ChangeJobSiteState({this.jobSiteRiskList});
}

class LoadingJobSiteState extends JobSiteState {}

class ChangeJobSiteRiskState  extends JobSiteState {
  final int indexList;
  ChangeJobSiteRiskState({this.indexList});
}

class JobSiteFailedState extends JobSiteState {
  final dynamic error;
  JobSiteFailedState(this.error);
}