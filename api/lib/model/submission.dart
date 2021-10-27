//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//


// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Submission {
  /// Returns a new [Submission] instance.
  Submission({
    this.score,
    this.selections = const [],
    this.timestamp,
    this.id,
  });

  int? score;

  List<String>? selections;

  int? timestamp;

  String? id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Submission &&
     other.score == score &&
     other.selections == selections &&
     other.timestamp == timestamp &&
     other.id == id;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (score == null ? 0 : score.hashCode) +
    (selections == null ? 0 : selections.hashCode) +
    (timestamp == null ? 0 : timestamp.hashCode) +
    (id == null ? 0 : id.hashCode);

  @override
  String toString() => 'Submission[score=$score, selections=$selections, timestamp=$timestamp, id=$id]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (score != null) {
      json[r'score'] = score;
    }
    if (selections != null) {
      json[r'selections'] = selections;
    }
    if (timestamp != null) {
      json[r'timestamp'] = timestamp;
    }
    if (id != null) {
      json[r'id'] = id;
    }
    return json;
  }

  /// Returns a new [Submission] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Submission? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return Submission(
        score: mapValueOfType<int>(json, r'score'),
        selections: json[r'selections'] is List
          ? (json[r'selections'] as List).cast<String>()
          : null,
        timestamp: mapValueOfType<int>(json, r'timestamp'),
        id: mapValueOfType<String>(json, r'id'),
      );
    }
    return null;
  }

  static List<Submission?>? listFromJson(dynamic json, {bool? emptyIsNull, bool? growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(Submission.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <Submission>[];

  static Map<String, Submission?> mapFromJson(dynamic json) {
    final map = <String, Submission?>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = Submission.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of Submission-objects as value to a dart map
  static Map<String, List<Submission?>?> mapListFromJson(dynamic json, {bool? emptyIsNull, bool? growable,}) {
    final Map<String, List<Submission?>?> map = <String, List<Submission>?>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = Submission.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

