//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//


// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:moralpainapi/api.dart';
import 'package:test/test.dart';

// tests for SurveyOption
void main() {
  final json = '''
    {
      "id": "Philip J. Fry",
      "description": "Human"
    }
  ''';
  final instance = SurveyOption.fromJson(jsonDecode(json));

  group('test SurveyOption', () {
    // String id
    test('to test the property `id`', () async {
      expect("Philip J. Fry", instance!.id);
    });

    // String description
    test('to test the property `description`', () async {
      expect("Human", instance!.description);
    });
  });
}
