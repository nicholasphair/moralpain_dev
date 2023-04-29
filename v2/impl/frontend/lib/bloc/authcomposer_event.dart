part of 'authcomposer_bloc.dart';

abstract class AuthComposerEvent {
  const AuthComposerEvent();
}

class AuthComposerStartEvent extends AuthComposerEvent {
  const AuthComposerStartEvent();
}