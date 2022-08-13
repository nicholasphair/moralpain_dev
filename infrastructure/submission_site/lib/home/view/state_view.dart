import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_site/home/home.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        switch (state.submissionStatus) {
          case SubmissionStatus.initial:
          case SubmissionStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case SubmissionStatus.success:
            switch (state.surveyStatus) {
              case SurveyStatus.initial:
              case SurveyStatus.loading:
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              case SurveyStatus.success:
                final areChanges =
                    state.timestamp != state.submission!.timestamp ||
                        state.score != state.submission!.score ||
                        !areListsEqual(
                          state.selections!,
                          state.submission!.selections!.toList(),
                        );
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => showSubmitStatusDialog(context, state));
                return Scaffold(
                  appBar: AppBar(title: Text('Submission ID ${state.id}')),
                  body: Center(
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FieldList(),
                                const SizedBox(height: 50.0),
                                RevertSubmitChangesWidget(enabled: areChanges),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              case SurveyStatus.failure:
                return Scaffold(
                  appBar: AppBar(title: Text('Submission ID ${state.id}')),
                  body: const Center(
                    child: Text(
                      'Error fetching information about contributing factors.',
                    ),
                  ),
                );
            }
          case SubmissionStatus.failure:
            return const Scaffold(
              body: Center(child: Text('Error fetching submission.')),
            );
        }
      },
    );
  }

  @visibleForTesting
  static bool areListsEqual(List a, List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @visibleForTesting
  static void showSubmitStatusDialog(BuildContext context, HomeState state) {
    AlertDialog alert;
    switch (state.submitStatus) {
      case SubmitStatus.none:
        return;
      case SubmitStatus.success:
        alert = AlertDialog(
          title: const Text('Changes submitted!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
        break;
      case SubmitStatus.failure:
        alert = AlertDialog(
          title: const Text('Error submitting changes.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
    }
    showDialog(context: context, builder: (_) => alert);
  }
}
