//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//


// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:math';

import 'package:moralpainapi/api.dart';
import 'package:test/test.dart';

// tests for SurveySection
void main() {
  final json = '''{ 
    "sectionId": "123", 
    "title": "Star Wars: Episode IV",
    "subtitle": "A New Hope",
    "options": [
      {
        "id": "foo",
        "description": "foo"
      },
      {
        "id": "bar",
        "description": "bar"
      }
    ]
  }''';
  final instance = SurveySection.fromJson(jsonDecode(json));

  group('test SurveySection', () {
    // String sectionId
    test('to test the property `sectionId`', () async {
      expect("123", instance!.sectionId);
    });

    // String title
    test('to test the property `title`', () async {
      expect("Star Wars: Episode IV", instance!.title);
    });

    // String subtitle
    test('to test the property `subtitle`', () async {
      expect("A New Hope", instance!.subtitle);
    });

    // List<SurveyOption> options (default value: const [])
    test('to test the property `options`', () async {
      expect(2, instance!.options!.length);
      expect("foo", instance.options!.first!.id);
    });
  });
}
