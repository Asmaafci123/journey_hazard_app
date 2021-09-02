import 'package:flutter/foundation.dart';
import 'package:journeyhazard/core/errors/base_error.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/trips/data/models/trips.dart';

class BaseTripState {
}

class TripSuccessState extends BaseTripState {
  TripsModel trips;
  TripSuccessState({this.trips});
}

class TripLoadingState extends BaseTripState {}

class TripInitLoading extends BaseTripState {}
class TripFailedState extends BaseTripState {
  final dynamic error;
  TripFailedState(this.error);
}
class TripSaveState extends BaseTripState {}

class TripDoneState extends BaseTripState {}

class TripCompletedState extends BaseTripState {
  final UserModel userData;
  TripCompletedState({this.userData});
}

class TripStartState extends BaseTripState {}

class RemoveRiskSaveState extends BaseTripState {}

class AddRiskSaveState extends BaseTripState {}

class GetSupportNumberSuccessState extends BaseTripState {
  final String supportNumber;
  GetSupportNumberSuccessState({this.supportNumber});
}

class StartShowRiskInfoState extends BaseTripState {
  final bool showInfo;
  StartShowRiskInfoState({this.showInfo});
}