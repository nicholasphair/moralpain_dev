import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_site/api_repository.dart';
import 'package:submission_site/home/home.dart';

class HomeRoute extends StatelessWidget {
  final ApiRepository? repository; // (1) INTERFACE TO BACK END

  const HomeRoute({this.repository, Key? key}) : super(key: key);

  @override
  // Creates bloc and activates it to do an initial fetch
  Widget build(BuildContext context) {
    // (2) Bloc
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(
        repository: repository ?? ApiRepository(),
      )..add(const HomeSubmissionRequested()),
      child: const HomeView(), // (3) GUI
    );
  }
}
