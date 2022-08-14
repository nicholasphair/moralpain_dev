import 'package:submission_site/state/bloc/state.dart';

abstract class StateState<T extends State> {}

class UnknownState<T extends State> extends StateState<T> {}

class StateFetched<T extends State> extends StateState<T> {
  final T u;

  StateFetched(this.u);
}

class StateStored<T extends State> extends StateState<T> {}
