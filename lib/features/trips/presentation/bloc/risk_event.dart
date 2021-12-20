part of 'risk_bloc.dart';

abstract class RiskEvent extends Equatable {
  const RiskEvent();
}
class RunRiskEvent extends RiskEvent{
  final RiskModel risk;
  RunRiskEvent({this.risk});

  @override
  List<Object> get props => [risk];
}


class DoneRiskEvent extends RiskEvent{
  final RiskModel risk;
  DoneRiskEvent({this.risk});

  @override
  List<Object> get props => [risk];
}

class RunRepeatRiskEvent extends RiskEvent{
  final RiskModel risk;
  RunRepeatRiskEvent({this.risk});

  @override
  List<Object> get props => [risk];
}
class DoneRepeatRiskEvent extends RiskEvent{
  DoneRepeatRiskEvent();
  @override
  List<Object> get props => [];
}