import 'dart:async';

import 'package:cognito_authentication_repository/cognito_authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:moraldistress/api_repository.dart';
import 'package:moralpainapi/moralpainapi.dart';
import 'package:uuid/uuid.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';

part 'survey_state.dart';
part 'survey_event.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final log = Logger('SurveyBloc');
  final uuid = Uuid();

  final ApiRepository repository;
  final CognitoAuthenticationRepository authRepository;
  StreamSubscription<AWSCredentials>? credentialsStream;

  final options = Map<String, bool>();
  final score;

  SurveyBloc(
      {required this.repository, required this.authRepository, this.score})
      : super(SurveyLoading()) {
    on<SurveyLoadEvent>(_onLoad);
    on<SurveySubmitEvent>(_onSubmit);
    on<SurveyUpdateEvent>(_onUpdate);

    credentialsStream =
        authRepository.latestCredentialGenerator().listen(refreshCredentials);
  }

  void refreshCredentials(AWSCredentials credentials) {
    repository.credentialRefresh(credentials);
  }

  @override
  Future<void> close() async {
    await credentialsStream?.cancel();
    await super.close();
  }

  void _onLoad(SurveyLoadEvent event, Emitter<SurveyState> emit) async {
    emit(SurveyLoading());

    if (!await repository.isSigning()) {
      var creds = await authRepository.fetchUserCredentials();
      refreshCredentials(creds);
    }

    final data = await repository.fetchSurvey();
    emit(SurveyLoaded(data));
  }

  void _onSubmit(SurveySubmitEvent event, Emitter<SurveyState> emit) async {
    final selected =
        options.entries.where((x) => x.value).map((x) => x.key).toList();

    final builder = SubmissionBuilder();
    builder.id = uuid.v4().replaceAll("-", "");
    builder.score = score;
    builder.selections.addAll(selected);
    builder.timestamp = _secondsSinceEpoch();

    emit(SurveySubmitting());
    final success = await repository.submitSurvey(builder.build());
    emit(SurveyComplete(success));
  }

  void _onUpdate(SurveyUpdateEvent event, Emitter<SurveyState> emit) {
    options[event.optionId] = event.value;

    emit(SurveyUpdated(options));
  }

  /**
   * UTC Seconds since epoch.
   */
  int _secondsSinceEpoch() {
    final utcNow = DateTime.now().toUtc();
    return utcNow.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
  }
}
