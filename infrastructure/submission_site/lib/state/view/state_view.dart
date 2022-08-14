import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_site/state/bloc/state_bloc.dart';
import 'package:submission_site/state/bloc/state_state.dart';

class StateView<T> extends StatelessWidget {
  const StateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StateBloc<T>, StateState<T>>(
      builder: (context, state) {
        if (state is UnknownState) {
          return Text("UnknownState");
        } else if (state is StateFetched) {
          return Text("StateFetched");
        } else if (state is StateStored) {
          return Text("StateStored");
        } else {
          return ErrorWidget("error");
        }
      },
    );
  }
}
