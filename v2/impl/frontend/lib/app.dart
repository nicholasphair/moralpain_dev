import 'package:auth/auth/view/auth_loading_layout.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:authcompose/bloc/authcomposer_bloc.dart';
import 'package:authcompose/view/authcomposer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auth/auth/view/auth_navigator.dart';
import 'package:auth/auth/bloc/auth_cubit.dart' as abloc;
import 'package:auth/auth/view/auth_loading_layout.dart';
import 'package:auth/auth/view/auth_signin_layout.dart';
import 'package:auth/api_repository.dart' as aapi;
import 'package:cognito_authentication_repository/cognito_authentication_repository.dart'
    as cognito;
import 'package:sequentialcompose/bloc/sequentialcomposer_bloc.dart';
import 'package:thermometer/api_repository.dart' as thermometerapi;
import 'package:thermometer/thermometer/view/thermometer_layout.dart'
    as thermometerview;
import 'package:thermometer/thermometer/cubit/thermometer_cubit.dart'
    as thermometerbloc;
import 'package:survey/api_repository.dart' as surveyapi;
import 'package:survey/survey/view/survey_layout.dart' as surveyview;
import 'package:survey/survey/bloc/survey_bloc.dart' as surveybloc;

class AuthWrappedApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthWrappedAppState();
}

class _AuthWrappedAppState extends State<AuthWrappedApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  //@override
  //void initState() {
  //  WidgetsBinding.instance.addPostFrameCallback((_) async {
  //    super.initState();
  //    await _configureAmplify();
  //    //setState(() { });
  //  });
  //}

  @override
  Widget build(BuildContext context) {
    if (!_amplifyConfigured) {
      return AuthLoadingLayout();
    }
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<cognito.CognitoAuthenticationRepository>(
              create: (context) => cognito.CognitoAuthenticationRepository()),
          RepositoryProvider<aapi.ApiRepository>(
              create: (context) => aapi.ApiRepository()),
          RepositoryProvider<thermometerapi.ApiRepository>(
              create: (context) => thermometerapi.ApiRepository()),
          RepositoryProvider<surveyapi.ApiRepository>(
              create: (context) => surveyapi.ApiRepository())
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  lazy: false,
                  create: (context) => abloc.AuthCubit(
                      RepositoryProvider.of<
                          cognito.CognitoAuthenticationRepository>(context),
                      RepositoryProvider.of<aapi.ApiRepository>(context))
                    ..attemptAutoSignIn()),
              BlocProvider(
                  lazy: false,
                  create: (context) => thermometerbloc.ThermometerCubit(
                      RepositoryProvider.of<thermometerapi.ApiRepository>(
                          context))),
              BlocProvider(
                  lazy: false,
                  create: (context) => surveybloc.SurveyBloc(
                      RepositoryProvider.of<surveyapi.ApiRepository>(context))),
              BlocProvider<SequentialComposerBloc>(
                  lazy: false,
                  create: (BuildContext context) => SequentialComposerBloc(
                      RepositoryProvider.of<thermometerapi.ApiRepository>(
                          context),
                      RepositoryProvider.of<surveyapi.ApiRepository>(context))
                    ..add(SequentialComposerStartEvent())),
              BlocProvider<AuthComposerBloc>(
                  lazy: false,
                  create: (BuildContext context) => AuthComposerBloc(
                      RepositoryProvider.of<aapi.ApiRepository>(context),
                      RepositoryProvider.of<surveyapi.ApiRepository>(context))
                    ..add(AuthComposerStartEvent()))
            ],
            child: MaterialApp(
              home:
                  _amplifyConfigured ? AuthComposerView() : AuthLoadingLayout(),
            )));
  }

  Future<void> _configureAmplify() async {
    try {
      await Future.wait([Amplify.addPlugin(AmplifyAuthCognito())]);
      var amplifyconfig =
          await rootBundle.loadString('assets/amplifyconfiguration.json');
      await Amplify.configure(amplifyconfig);
      setState(() => _amplifyConfigured = true);
    } catch (e) {
      print(e);
    }
  }
}
