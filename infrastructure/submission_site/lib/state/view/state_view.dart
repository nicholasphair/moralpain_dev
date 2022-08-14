import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_site/state/bloc/state.dart';
import 'package:submission_site/state/bloc/state_bloc.dart';
import 'package:submission_site/state/bloc/state_event.dart';
import 'package:submission_site/state/bloc/state_state.dart';

class StateView<T> extends StatelessWidget {
  const StateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StateBloc<T>, StateState<T>>(
      builder: (context, state) {
        if (state is UnknownState<T>) {
          return UnknownStateWidget(context);
        } else if (state is StateFetched<T>) {
          return FetchStateWidget(context, state);
        } else if (state is StateStored<T>) {
          return Text("StateStored");
        } else {
          return ErrorWidget("error");
        }
      },
    );
  }

  Widget UnknownStateWidget(BuildContext context) {
    return Row(children: [
      const Text("UnknownState"),
      ElevatedButton(
          onPressed: () =>
              {BlocProvider.of<StateBloc<T>>(context).add(FetchStateEvent())},
          child: const Text("Fetch the State"))
    ]);
  }

  Widget FetchStateWidget(BuildContext context, StateFetched<T> state) {
    if (state.state.fetchStatus == FetchStatus.initial) {
      return Text("Initial State...");
    } else if (state.state.fetchStatus == FetchStatus.loading) {
      return LinearProgressIndicator();
    } else if (state.state.fetchStatus == FetchStatus.success) {
      return Row(children: [
        Text("Successfully Fetched State of type: ${state.state.runtimeType}"),
        ElevatedButton(
            onPressed: () =>
                {BlocProvider.of<StateBloc<T>>(context).add(StoreStateEvent())},
            child: const Text("Store Updates to the State"))
      ]);
    } else if (state.state.fetchStatus == FetchStatus.failure) {
      return ErrorWidget("failed fetching status");
    } else {
      return ErrorWidget("unknown state");
    }
  }
}
