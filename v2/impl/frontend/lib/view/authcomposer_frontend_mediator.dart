import 'package:authcompose/bloc/authcomposer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:auth/auth/view/auth_signin_layout.dart';
import 'package:sequentialcompose/view/sequentialcomposer_frontend_mediator.dart';
import 'package:thermometer/thermometer/view/thermometer_layout.dart'; // COMPOSE.

// This is the ui for our composition.

class AuthComposerFrontendMediator extends StatelessWidget {
  const AuthComposerFrontendMediator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthComposerBloc, AuthComposerState>(
        buildWhen: shouldBuild,
        builder: buildHandler,
        listenWhen: shouldListen,
        listener: listenHandler);
  }

  bool shouldBuild(AuthComposerState previous, AuthComposerState current) {
    if (current is! AuthComposerSyncState) {
      assert(false);
      return false;
    }

    if (previous == current) {
      return false;
    }

    if (current.trigger == "signedInSuccess") {
      return true;
    }

    return false;
  }

  Widget buildHandler(BuildContext context, AuthComposerState state) {
    if (state is AuthComposerInitialState || (
      state is AuthComposerSyncStartState && !state.trigger.startsWith('signedInSuccess')
    )) {
      return AuthSignInLayout();
    } else if (state is AuthComposerSyncState) {
      return SequentialComposerFrontendMediator();
    } else {
      return ErrorWidget("Should not be here.");
    }
  }

  bool shouldListen(AuthComposerState previous, AuthComposerState current) {
    return true;
  }

  void listenHandler(BuildContext context, AuthComposerState state) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('received event $state'),
    ));
  }
}
