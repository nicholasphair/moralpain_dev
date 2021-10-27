//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//


// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SurveySection {
  /// Returns a new [SurveySection] instance.
  SurveySection({
    this.sectionId,
    this.title,
    this.subtitle,
    this.options = const [],
  });

  String? sectionId;

  String? title;

  String? subtitle;

  List<SurveyOption?>? options;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SurveySection &&
     other.sectionId == sectionId &&
     other.title == title &&
     other.subtitle == subtitle &&
     other.options == options;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (sectionId == null ? 0 : sectionId.hashCode) +
    (title == null ? 0 : title.hashCode) +
    (subtitle == null ? 0 : subtitle.hashCode) +
    (options == null ? 0 : options.hashCode);

  @override
  String toString() => 'SurveySection[sectionId=$sectionId, title=$title, subtitle=$subtitle, options=$options]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (sectionId != null) {
      json[r'sectionId'] = sectionId;
    }
    if (title != null) {
      json[r'title'] = title;
    }
    if (subtitle != null) {
      json[r'subtitle'] = subtitle;
    }
    if (options != null) {
      json[r'options'] = options;
    }
    return json;
  }

  /// Returns a new [SurveySection] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SurveySection? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return SurveySection(
        sectionId: mapValueOfType<String>(json, r'sectionId'),
        title: mapValueOfType<String>(json, r'title'),
        subtitle: mapValueOfType<String>(json, r'subtitle'),
        options: SurveyOption.listFromJson(json[r'options']),
      );
    }
    return null;
  }

  static List<SurveySection?>? listFromJson(dynamic json, {bool? emptyIsNull, bool? growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(SurveySection.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <SurveySection>[];

  static Map<String, SurveySection?> mapFromJson(dynamic json) {
    final map = <String, SurveySection?>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = SurveySection.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of SurveySection-objects as value to a dart map
  static Map<String, List<SurveySection?>?> mapListFromJson(dynamic json, {bool? emptyIsNull, bool? growable,}) {
    final Map<String, List<SurveySection?>?> map = <String, List<SurveySection>?>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = SurveySection.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

