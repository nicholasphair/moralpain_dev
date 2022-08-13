import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:moralpainapi/moralpainapi.dart';
import 'package:submission_site/api_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiRepository repository;

  HomeBloc({required this.repository})
      : super(
          const HomeState(),
        ) {
    on<HomeTimestampChanged>(_onTimestampChanged);
    on<HomeScoreChanged>(_onScoreChanged);
    on<HomeSelectionsChanged>(_onSelectionsChanged);
    on<HomeSubmissionRequested>(_onSubmissionRequested);
    on<HomeSurveyRequested>(_onSurveyRequested);
    on<HomeChangesReverted>(_onChangesReverted);
    on<HomeChangesSubmitted>(_onChangesSubmitted);
  }

  void _onTimestampChanged(
    HomeTimestampChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      timestamp: event.timestamp,
      submitStatus: SubmitStatus.none,
    ));
  }

  void _onScoreChanged(HomeScoreChanged event, Emitter<HomeState> emit) async {
    emit(state.copyWith(score: event.score));
  }

  void _onSelectionsChanged(
    HomeSelectionsChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      selections: event.selections,
      submitStatus: SubmitStatus.none,
    ));
  }

  void _onSubmissionRequested(
    HomeSubmissionRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.loading));
    try {
      Submission submission = await repository.fetchSubmission(
        event.submissionId,
      );
      print(submission);
      emit(state.copyWith(
        id: submission.id!,
        score: submission.score!,
        timestamp: submission.timestamp!,
        selections: submission.selections!.toList(),
        submission: submission,
        submissionStatus: SubmissionStatus.success,
      ));
      print('success state emitted');
      add(const HomeSurveyRequested());
      print('SurveyRequested event added');
    } catch (err) {
      print(err);
      emit(state.copyWith(submissionStatus: SubmissionStatus.failure));
      print('failure state emitted');
    }
  }

  void _onSurveyRequested(
    HomeSurveyRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(surveyStatus: SurveyStatus.loading));
    try {
      Survey survey = await repository.fetchSurvey();
      emit(state.copyWith(survey: survey, surveyStatus: SurveyStatus.success));
    } catch (err) {
      emit(state.copyWith(surveyStatus: SurveyStatus.failure));
    }
  }

  void _onChangesReverted(
    HomeChangesReverted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      timestamp: state.submission!.timestamp,
      score: state.submission!.score,
      selections: state.submission!.selections!.toList(),
      submitStatus: SubmitStatus.none,
    ));
  }

  void _onChangesSubmitted(
    HomeChangesSubmitted event,
    Emitter<HomeState> emit,
  ) async {
    final builder = SubmissionBuilder();
    builder.id = state.id!;
    builder.timestamp = state.timestamp!;
    builder.score = state.score!;
    builder.selections = ListBuilder(state.selections!);
    final newSubmission = builder.build();

    final success = await repository.submitSubmission(newSubmission);
    if (success) {
      emit(state.copyWith(
        submission: newSubmission,
        submitStatus: SubmitStatus.success,
      ));
    } else {
      emit(state.copyWith(submitStatus: SubmitStatus.failure));
    }
  }
}
