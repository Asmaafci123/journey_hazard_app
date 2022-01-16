
import 'package:geolocator/geolocator.dart';
import 'package:journeyhazard/features/trips/data/models/risk.dart';

class BaseTripEvent{}

class GetTripEvent extends BaseTripEvent{}

class AddHazarEvent extends BaseTripEvent{}

class DoneHazarEvent extends BaseTripEvent{
  final RiskModel risk;
  DoneHazarEvent({this.risk});
}

class RemoveHazarEvent extends BaseTripEvent{
  final RiskModel risk;
  RemoveHazarEvent({this.risk});
}

class CompleteTripEvent extends BaseTripEvent{
}

class StartTripEvent extends BaseTripEvent{}

class SupportMobileEvent extends BaseTripEvent{}

class ShowRiskInfoEvent extends BaseTripEvent{}

class GetJobSiteRisksEvent extends BaseTripEvent{
}