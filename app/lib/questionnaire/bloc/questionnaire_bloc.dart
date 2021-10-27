import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moralpain/survey_repository.dart';
import 'package:moralpainapi/api.dart';

part 'questionnaire_state.dart';
part 'questionnaire_event.dart';

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  final SurveyRepository repository;

  QuestionnaireBloc({required this.repository})
      : super(QuestionnaireLoading()) {
    on<QuestionnaireLoadEvent>(_onLoad);
    on<QuestionnaireSubmitEvent>(_onSubmit);
  }

  void _onLoad(
      QuestionnaireLoadEvent event, Emitter<QuestionnaireState> emit) async {
    emit(QuestionnaireLoading());
    try {
      final data = await repository.fetchDefaultSurvey();
      emit(QuestionnaireLoaded(data!));
    } catch (error) {
      // Fail hard if we can't load the questionnaire.
      assert(false);
    }
  }

  void _onSubmit(
      QuestionnaireSubmitEvent event, Emitter<QuestionnaireState> emit) {
    emit(QuestionnaireComplete());
  }
}
