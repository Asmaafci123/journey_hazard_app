import 'package:geolocator/geolocator.dart';
import 'package:journeyhazard/core/results/result.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/trips/data/models/jobsite.dart';
import 'package:journeyhazard/features/trips/data/models/risk.dart';

abstract class TripRepository {
  Future<Result<dynamic>> completeShipment(Position loc,  UserModel userData);
  Future<Result<dynamic>> addHazarData(Position newRisk);
  Future<Result<dynamic>> doneHazarData(RiskModel risk);
  Future<Result<dynamic>> removeHazarData(RiskModel risk);
  Future<Result<dynamic>> mobileSupport();
  Future<Result<dynamic>> getJobSiteRisks(Position loc,  UserModel userData);
  Future<Result<dynamic>> getRisksByJobSite(Position loc,  UserModel userData,JobSite jobSite);

}
