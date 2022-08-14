import 'package:equatable/equatable.dart';

enum FetchStatus { initial, loading, success, failure }
enum StoreStatus { initial, uploading, success, failure }

// GUI will read and display a value of this type from a bloc
class State<T> extends Equatable {
  // implements underlying concept
  final T? conceptStateRep;

  // supports GUI display behavior
  FetchStatus fetchStatus; // determine what GUI displays
  StoreStatus storeStatus; // enables result status popup

  // supports "revertibility" of changes
  final T? revertCopy; // enable revert to original

  // constructor, sets initial state
  State({
    // underlying concept state
    this.conceptStateRep,

    // supports revert concept
    this.revertCopy,

    // support GUI display of status
    this.fetchStatus = FetchStatus.initial,
    this.storeStatus = StoreStatus.initial,
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
