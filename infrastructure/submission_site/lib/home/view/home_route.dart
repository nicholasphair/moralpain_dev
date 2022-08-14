import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_site/api_repository.dart';
import 'package:submission_site/home/home.dart';

class HomeRoute extends StatelessWidget {
  final ApiRepository? repository;

  const HomeRoute({this.repository, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(
        repository: repository ?? ApiRepository(),
      )..add(const HomeSubmissionRequested(
          '119ada26a0ba499182f4d6aa7c73c503',
        )),
      child: const HomeView(),
    );
  }
}
