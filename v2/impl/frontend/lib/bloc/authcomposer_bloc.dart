import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

// From composer.
// import 'package:survey/api_repository.dart' as srepo;
// import 'package:thermometer/api_repository.dart' as trepo;

import 'package:auth/api_repository.dart' as auth_repo;
import 'package:survey/api_repository.dart' as other_repo;

part 'authcomposer_state.dart';
part 'authcomposer_event.dart';

class AuthComposerBloc extends Bloc<AuthComposerEvent, AuthComposerState> {
  final auth_repo.ApiRepository authRepo;
  final other_repo.ApiRepository otherRepo;

  AuthComposerBloc(this.authRepo, this.otherRepo)
      : super(AuthComposerInitialState()) {
    on<AuthComposerStartEvent>(_onStart);
  }

  void _onStart(
      AuthComposerStartEvent event, Emitter<AuthComposerState> emit) async {
    await emit.forEach(
      authRepo.stream,
      onData: (String data) {
        print('got data into the bloc ${data}');
        return AuthComposerSyncStartState(trigger: data);
        // Do any processing we need.
      },
    );
  }
}
