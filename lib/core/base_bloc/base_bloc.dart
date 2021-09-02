import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journeyhazard/core/errors/base_error.dart';
import 'package:journeyhazard/core/errors/error_helper.dart';
import 'package:journeyhazard/core/models/base_model.dart';

abstract class BaseState {}

abstract class BaseEvent {
  BuildContext context;
  BaseEvent({this.context});
}

class Yield extends BaseEvent {
  final BaseState state;
  Yield(this.state);
}

abstract class BaseSuccessState extends BaseState {
  final dataEntity;
  bool cacheThisData;
  bool saveThisState;

  BaseSuccessState(
      {this.dataEntity, this.cacheThisData = false, this.saveThisState = true});
}

class BaseLoadingState extends BaseState {
  final bool getFromLocal;

  BaseLoadingState({this.getFromLocal = false});
}

class BaseFailedState extends BaseState {
  final error;

  BaseFailedState(this.error);
}

class BaseToastState extends BaseState {
  String message;

  BaseToastState(obj) {
    if (obj is String) {
      this.message = obj;
    }
    if (obj is BaseError) {
      ErrorHelper().getErrorMessage(obj);
    }
  }
}

class BaseInitialState extends BaseState {}

abstract class BaseBLoc extends Bloc<BaseEvent, BaseState> {
  BaseModel lastSuccessStateData;

  BaseBLoc(BaseState initialState) : super(initialState);

//  BaseBLoc init();

  ///
  @override
  void onTransition(Transition<BaseEvent, BaseState> transition) async {
//    (this as ProfileInfoBloc).add(event);

    if (transition.nextState is BaseSuccessState &&
        (transition.nextState as BaseSuccessState).dataEntity != null &&
        (transition.nextState as BaseSuccessState).saveThisState) {
      this.lastSuccessStateData =
          (transition.nextState as BaseSuccessState).dataEntity;
    }

    /// CACHING WILL BE HERE
    if (transition.nextState is BaseLoadingState) {
      final loadingState = transition.nextState as BaseLoadingState;

      /// if(hasLocalData){ // accor
      ///
      ///
      /// }

      if (loadingState.getFromLocal) {
//        print('GETTING FROM LOCAL...........');
      }
    }

    super.onTransition(transition);
  }

  ///
  @override
  BaseState get initialState {
//    this.childBloc = init();
    return BaseInitialState();
  }

//  @override
//  Future<Function> close() {
//    try {
//      this.childBloc.close();
//    } catch (e,s) {
//      print(e);
//      print(s);
//    }
//    return super.close();
//  }

  ///

//  yieldState(BaseState state) {
//    this.add(Yield(state));
//  }
}
