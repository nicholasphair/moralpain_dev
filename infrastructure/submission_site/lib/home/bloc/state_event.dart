import 'package:equatable/equatable.dart';

abstract class StateEvent extends Equatable {
  const StateEvent();

  @override
  List<Object> get props => [];
}

class FetchStateEvent extends StateEvent {}

class StoreStateEvent extends StateEvent {}

class RevertStateEvent extends StateEvent {}
