import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_site/api_repository.dart';
import 'package:submission_site/home/home.dart';

import '../bloc/state.dart' as state;
import '../../state_repository.dart';
import '../bloc/state_bloc.dart';
import '../bloc/state_event.dart';

class StateRoute<T extends state.State> extends StatelessWidget {
  final StateRepository<T> repository; // (1) INTERFACE TO BACK END

  const StateRoute({required this.repository, Key? key}) : super(key: key);

  @override
  // Creates bloc and activates it to do an initial fetch
  Widget build(BuildContext context) {
    // (2) Bloc
    return BlocProvider<StateBloc>(
      create: (_) => StateBloc(
        repository: repository,
      )..add(FetchStateEvent()),
      child: const HomeView(), // (3) GUI
    );
  }
}
