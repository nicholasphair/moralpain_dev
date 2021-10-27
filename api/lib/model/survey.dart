//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//


// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Survey {
  /// Returns a new [Survey] instance.
  Survey({
    this.version,
    this.sections = const [],
  });

  String? version;

  List<SurveySection?>? sections;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Survey &&
     other.version == version &&
     other.sections == sections;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (version == null ? 0 : version.hashCode) +
    (sections == null ? 0 : sections.hashCode);

  @override
  String toString() => 'Survey[version=$version, sections=$sections]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (version != null) {
      json[r'version'] = version;
    }
    if (sections != null) {
      json[r'sections'] = sections;
    }
    return json;
  }

  /// Returns a new [Survey] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Survey? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return Survey(
        version: mapValueOfType<String>(json, r'version'),
        sections: SurveySection.listFromJson(json[r'sections']),
      );
    }
    return null;
  }

  static List<Survey?>? listFromJson(dynamic json, {bool? emptyIsNull, bool? growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(Survey.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <Survey>[];

  static Map<String, Survey?> mapFromJson(dynamic json) {
    final map = <String, Survey?>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = Survey.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of Survey-objects as value to a dart map
  static Map<String, List<Survey?>?> mapListFromJson(dynamic json, {bool? emptyIsNull, bool? growable,}) {
    final Map<String, List<Survey?>?> map = <String, List<Survey>?>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = Survey.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

