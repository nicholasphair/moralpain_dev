part of 'authcomposer_bloc.dart';

abstract class AuthComposerState { }

class AuthComposerInitialState extends AuthComposerState { }

abstract class AuthComposerSyncState extends AuthComposerState {
  final String trigger;

  AuthComposerSyncState({required this.trigger});
}

class AuthComposerSyncStartState extends AuthComposerSyncState {
  AuthComposerSyncStartState({required super.trigger});
}

class AuthComposerSyncEndState extends AuthComposerSyncState {
  AuthComposerSyncEndState({required super.trigger});
}
