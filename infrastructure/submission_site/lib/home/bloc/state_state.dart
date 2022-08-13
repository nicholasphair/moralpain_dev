import 'package:submission_site/home/bloc/state.dart';

abstract class StateState<T extends State> {}

class UnknownState<T> extends StateState {}

class StateFetched<T> extends StateState {
  final T u;

  StateFetched(this.u);
}

class StateStored<T> extends StateState {}
