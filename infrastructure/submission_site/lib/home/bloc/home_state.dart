part of 'home_bloc.dart';

enum SubmissionStatus { initial, loading, success, failure }

enum SurveyStatus { initial, loading, success, failure }

enum SubmitStatus { none, success, failure }

class HomeState extends Equatable {
  final String? id;
  final int? score;
  final int? timestamp;
  final List<String>? selections;
  final Submission? submission;
  final SubmissionStatus submissionStatus;
  final Survey? survey;
  final SurveyStatus surveyStatus;
  final SubmitStatus submitStatus;

  const HomeState({
    this.id,
    this.score,
    this.timestamp,
    this.selections,
    this.submission,
    this.submissionStatus = SubmissionStatus.initial,
    this.survey,
    this.surveyStatus = SurveyStatus.initial,
    this.submitStatus = SubmitStatus.none,
  });

  @override
  List<Object?> get props => [
        id,
        score,
        timestamp,
        selections,
        submission,
        submissionStatus,
        survey,
        surveyStatus,
        submitStatus
      ];

  HomeState copyWith({
    String? id,
    int? score,
    int? timestamp,
    List<String>? selections,
    Submission? submission,
    SubmissionStatus? submissionStatus,
    Survey? survey,
    SurveyStatus? surveyStatus,
    SubmitStatus? submitStatus,
  }) {
    return HomeState(
      id: id ?? this.id,
      score: score ?? this.score,
      timestamp: timestamp ?? this.timestamp,
      selections: selections ?? this.selections,
      submission: submission ?? this.submission,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      survey: survey ?? this.survey,
      surveyStatus: surveyStatus ?? this.surveyStatus,
      submitStatus: submitStatus ?? this.submitStatus,
    );
  }
}
