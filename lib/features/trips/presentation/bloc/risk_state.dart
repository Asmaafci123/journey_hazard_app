part of 'risk_bloc.dart';

abstract class RiskState extends Equatable {
  const RiskState();
}

class RiskInitial extends RiskState {
  @override
  List<Object> get props => [];
}
class RiskLoadingState extends RiskState {
  @override
  List<Object> get props => [];
}

class RunRiskState extends RiskState {
  final RiskModel risk;
  RunRiskState({this.risk});
  @override
  List<Object> get props => [risk];
}
class DoneRiskState extends RiskState {
  @override
  List<Object> get props => [];
}
class RiskFailedState extends RiskState {
  final dynamic error;
  RiskFailedState(this.error);
  @override
  // TODO: implement props
  List<Object> get props => [error];
}