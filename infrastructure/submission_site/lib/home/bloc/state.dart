import 'package:equatable/equatable.dart';

enum FetchStatus { initial, loading, success, failure }

enum StoreStatus { none, success, failure }
// enum SurveyStatus { initial, loading, success, failure }

// GUI will read and display a value of this type from a bloc
class State<T> extends Equatable {
  // implements underlying concept
  final T? conceptStateRep;

  // supports GUI display behavior
  final FetchStatus fetchStatus; // determine what GUI displays
  final StoreStatus storeStatus; // enables result status popup

  // supports "revertibility" of changes
  final T? revertCopy; // enable revert to original

  // constructor, sets initial state
  const State({
    // underlying concept state
    this.conceptStateRep,

    // supports revert concept
    this.revertCopy,

    // support GUI display of status
    this.fetchStatus = FetchStatus.initial,
    this.storeStatus = StoreStatus.none,
  });

  // Supports equality comparison
  @override
  List<Object?> get props =>
      [conceptStateRep, revertCopy, fetchStatus, storeStatus];

  State copyWith({
    T? conceptStateRep,
    T? revertCopy,
    FetchStatus? fetchStatus,
    StoreStatus? storeStatus,
  }) {
    return State(
      conceptStateRep: conceptStateRep ?? this.conceptStateRep,
      revertCopy: revertCopy ?? this.revertCopy,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      storeStatus: storeStatus ?? this.storeStatus,
    );
  }
}
