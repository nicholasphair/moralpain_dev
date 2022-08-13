part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeTimestampChanged extends HomeEvent {
  final int timestamp;

  const HomeTimestampChanged(this.timestamp);

  @override
  List<Object> get props => [timestamp];
}

class HomeScoreChanged extends HomeEvent {
  final int score;

  const HomeScoreChanged(this.score);

  @override
  List<Object> get props => [score];
}

class HomeSelectionsChanged extends HomeEvent {
  final List<String> selections;

  const HomeSelectionsChanged(this.selections);

  @override
  List<Object> get props => [selections];
}

class HomeSubmissionRequested extends HomeEvent {
  final String submissionId;

  const HomeSubmissionRequested(this.submissionId);

  @override
  List<Object> get props => [submissionId];
}

class HomeSurveyRequested extends HomeEvent {
  const HomeSurveyRequested();
}

class HomeChangesReverted extends HomeEvent {
  const HomeChangesReverted();
}

class HomeChangesSubmitted extends HomeEvent {
  const HomeChangesSubmitted();
}
