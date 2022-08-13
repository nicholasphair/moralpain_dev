import 'package:equatable/equatable.dart';

// Use api-generated class rather than this one.

// final Survey? survey; // to map reason codes to strings

class ModReportRep extends Equatable {
  final String? id;
  final int? score;
  final int? timestamp;
  final List<String>? selections;

  const ModReportRep({
    this.id,
    this.score,
    this.timestamp,
    this.selections,
  });

  @override
  List<Object?> get props => [id, score, timestamp, selections];

  ModReportRep copyWith(
      {String? id, int? score, int? timestamp, List<String>? selections}) {
    return ModReportRep(
      id: id ?? this.id,
      score: score ?? this.score,
      timestamp: timestamp ?? this.timestamp,
      selections: selections ?? this.selections,
    );
  }
}
