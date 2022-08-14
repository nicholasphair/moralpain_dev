import 'package:built_collection/built_collection.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:moralpainapi/moralpainapi.dart';

import 'state/bloc/state.dart';

class StateRepository<T> {
  const StateRepository();

  // TODO (nphair): I think we are going to need to either pass in an Api
  // implementationn or have a factory for creating apis from types...

  //final Moralpainapi mapi = Moralpainapi(
  //    basePathOverride:
  //        'https://0rl322u1u8.execute-api.us-east-1.amazonaws.com/v1');

  //StateRepository() {
  //  mapi.dio.options.connectTimeout = 30 * 1000;
  //  mapi.dio.options.receiveTimeout = 30 * 1000;
  //  mapi.dio.options.sendTimeout = 30 * 1000;
  //}

  /// Fetches the submission with the given ID.
  Future<State<T>> fetchState() async {
    await Future.delayed(const Duration(seconds: 2));
    return State<T>()..fetchStatus = FetchStatus.success;
  }

  Future<bool> storeState(State<T> state) async {
    Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
