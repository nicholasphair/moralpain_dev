import 'package:submission_site/state/bloc/state.dart';

abstract class StateState<T> {}

class UnknownState<T> extends StateState<T> {}

class StateFetched<T> extends StateState<T> {
  final State<T> state;

  StateFetched(this.state);
}

class StateStored<T> extends StateState<T> {}
