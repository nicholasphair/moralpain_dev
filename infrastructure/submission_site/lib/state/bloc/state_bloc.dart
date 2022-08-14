import 'package:bloc/bloc.dart';
import 'package:submission_site/state/bloc/state_event.dart';
import 'package:submission_site/state/bloc/state_state.dart';
import 'package:submission_site/state_repository.dart';
import 'state.dart';

/*
Take events in response to UI clicks and return states
*/

class StateBloc<T> extends Bloc<StateEvent, StateState<T>> {
  final StateRepository<T> repository;
  State<T> u = State<T>();

  StateBloc({required this.repository}) : super(UnknownState<T>()) {
    on<FetchStateEvent>(_fetchState);
    on<StoreStateEvent>(_storeState);
  }

  void _fetchState(FetchStateEvent event, Emitter<StateState> emit) async {
    emit(StateFetched<T>(u..fetchStatus = FetchStatus.loading));
    u = await repository.fetchState();
    emit(StateFetched<T>(u));
  }

  void _storeState(StoreStateEvent event, Emitter<StateState> emit) async {
    emit(StateStored<T>(u..storeStatus = StoreStatus.uploading));
    StoreStatus status = await repository.storeState(u)
        ? StoreStatus.success
        : StoreStatus.failure;
    emit(StateStored<T>(u..storeStatus = status));
  }
}
