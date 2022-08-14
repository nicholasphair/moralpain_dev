import 'package:bloc/bloc.dart';
import 'package:submission_site/state/bloc/state_event.dart';
import 'package:submission_site/state/bloc/state_state.dart';
import 'package:submission_site/state_repository.dart';
import 'state.dart';

/*
Take events in response to UI clicks and return states
*/

class StateBloc<T> extends Bloc<StateEvent, StateState> {
  final StateRepository<T> repository;

  StateBloc({required this.repository}) : super(UnknownState<State<T>>()) {
    on<FetchStateEvent>(_fetchState);
    //on<HomeScoreChanged>(_onScoreChanged);
    //on<HomeSelectionsChanged>(_onSelectionsChanged);
    //on<HomeSubmissionRequested>(_onSubmissionRequested);
    //on<HomeSurveyRequested>(_onSurveyRequested);
    //on<HomeChangesReverted>(_onChangesReverted);
    //on<HomeChangesSubmitted>(_onChangesSubmitted);
  }

  void _fetchState(FetchStateEvent event, Emitter<StateState> emit) async {
    State<T> state = await repository.fetchState();
    emit(StateFetched<State<T>>(state));
  }
}
