part of 'job_site_bloc.dart';

@immutable
abstract class JobSiteEvent {}

class ChangeJobSiteEvent extends JobSiteEvent{
 final JobSite jobSite;
  ChangeJobSiteEvent({this.jobSite});
}

class ChangeJobSiteRiskEvent extends JobSiteEvent{
 final int index;
 ChangeJobSiteRiskEvent({this.index});
}