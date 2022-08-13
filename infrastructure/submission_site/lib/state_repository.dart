import 'package:built_collection/built_collection.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:moralpainapi/moralpainapi.dart';

import 'home/bloc/state.dart';

// TODO: Generalize from moralpain api to state api.
class StateRepository<T extends State> {
  final Logger log = Logger('StateRepository');
  final Moralpainapi mapi = Moralpainapi(
      basePathOverride:
          'https://0rl322u1u8.execute-api.us-east-1.amazonaws.com/v1');

  StateRepository() {
    mapi.dio.options.connectTimeout = 30 * 1000;
    mapi.dio.options.receiveTimeout = 30 * 1000;
    mapi.dio.options.sendTimeout = 30 * 1000;
  }

  Future<State<T>> fetchState() async {
    final SubmissionApi sapi = mapi.getSubmissionApi();

    try {
      final response = await sapi.getSubmission();
      return response.data!;
    } catch (err) {
      throw SubmissionFetchFailure(err.toString());
    }
  }
}
