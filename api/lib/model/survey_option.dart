//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//


// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SurveyOption {
  /// Returns a new [SurveyOption] instance.
  SurveyOption({
    this.id,
    this.description,
  });

  String? id;

  String? description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SurveyOption &&
     other.id == id &&
     other.description == description;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (id == null ? 0 : id.hashCode) +
    (description == null ? 0 : description.hashCode);

  @override
  String toString() => 'SurveyOption[id=$id, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) {
      json[r'id'] = id;
    }
    if (description != null) {
      json[r'description'] = description;
    }
    return json;
  }

  /// Returns a new [SurveyOption] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SurveyOption? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return SurveyOption(
        id: mapValueOfType<String>(json, r'id'),
        description: mapValueOfType<String>(json, r'description'),
      );
    }
    return null;
  }

  static List<SurveyOption?>? listFromJson(dynamic json, {bool? emptyIsNull, bool? growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(SurveyOption.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <SurveyOption>[];

  static Map<String, SurveyOption?> mapFromJson(dynamic json) {
    final map = <String, SurveyOption?>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = SurveyOption.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of SurveyOption-objects as value to a dart map
  static Map<String, List<SurveyOption?>?> mapListFromJson(dynamic json, {bool? emptyIsNull, bool? growable,}) {
    final Map<String, List<SurveyOption?>?> map = <String, List<SurveyOption>?>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = SurveyOption.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

