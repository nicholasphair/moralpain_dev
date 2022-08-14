import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_site/state/bloc/state_event.dart';
import 'package:submission_site/state/view/state_view.dart';

import '../bloc/state_bloc.dart';
import '../../state_repository.dart';

class StateRoute<T> extends StatelessWidget {
  final StateRepository<T> repository; // (1) INTERFACE TO BACK END

  const StateRoute({required this.repository, Key? key}) : super(key: key);

  @override
  // Creates bloc and activates it to do an initial fetch
  Widget build(BuildContext context) {
    // (2) Bloc
    return BlocProvider<StateBloc>(
      create: (_) => StateBloc(repository: repository)..add(FetchStateEvent()),
      child: const StateView(), // (3) GUI
    );
  }
}
