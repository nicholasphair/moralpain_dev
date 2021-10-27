import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:moralpain/assets/constants.dart' as Constants;
import 'package:moralpainapi/api.dart';

class SurveyRepository {
  Future<Survey?> fetchDefaultSurvey() async =>
      fetchSurvey(Constants.QUESTIONNAIRE_QUESTIONNAIRE_PATH);

  Future<Survey?> fetchSurvey(String path) async {
    var json = await rootBundle.loadString(path).then(jsonDecode);

    return Survey.fromJson(json);
  }
}
