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

// tests for Survey
void main() {
  final json = '''{
	  "version": "0.0.1",
	  "sections": [
	  	{
	  		"sectionId": "001",
	  		"title": "King of the Hill",
	  		"subtitle": "",
	  		"options": [
	  			{
	  				"id": "Hank Hill",
	  				"description": "Propane and Propane Accessories Salesman"
	  			}
	  		]
      }
	  ]
  }''';
  final instance = Survey.fromJson(jsonDecode(json));

  group('test Survey', () {
    // String version
    test('to test the property `version`', () async {
      expect("0.0.1", instance!.version);
    });

    // List<SurveySection> sections (default value: const [])
    test('to test the property `sections`', () async {
      expect(1, instance!.sections!.length);
      expect("King of the Hill", instance.sections!.first!.title);
      expect(1, instance.sections!.first!.options!.length);
      expect("Hank Hill", instance.sections!.first!.options!.first!.id);
    });
  });
}
