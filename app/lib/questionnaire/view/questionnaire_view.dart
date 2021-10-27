import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moralpain/assets/constants.dart' as Constants;
import 'package:expandable_text/expandable_text.dart';
import 'package:moralpainapi/api.dart';

import '../questionnaire.dart';

class QuestionnaireView extends StatefulWidget {
  @override
  QuestionnaireViewState createState() => QuestionnaireViewState();
}

class QuestionnaireViewState extends State<QuestionnaireView> {
  final controller = ScrollController();
  bool _show = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollHandler);
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(Constants.COLORS_UVA_BLUE),
        title: const Text(Constants.APPBAR_TEXT),
      ),
      body: Padding(
          padding: EdgeInsets.all(Constants.PADDING),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Constants.QUESTIONNAIRE_TITLE,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                ExpandableText(
                  Constants.QUESTIONNAIRE_INSTRUCTIONS,
                  expandText: Constants.QUESTIONNAIRE_EXPAND_TEXT,
                  collapseText: Constants.QUESTIONNAIRE_COLLAPSE_TEXT,
                  maxLines: 1,
                  linkEllipsis: false,
                  linkColor: Colors.blue,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<QuestionnaireBloc, QuestionnaireState>(
                    builder: (context, state) {
                  if (state is QuestionnaireLoading) {
                    return CircularProgressIndicator();
                  } else if (state is QuestionnaireLoaded) {
                    return Expanded(
                        child: ListView(
                            controller: controller,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: state.questionnaire.sections!
                                .map((q) => cardForSection(q!))
                                .toList()));
                  } else {
                    return ErrorWidget(
                        "ERROR"); // probably bad, questcomplete will trigger.
                  }
                })
              ])),
      floatingActionButton: Visibility(
        visible: _show,
        child: FloatingActionButton(
            onPressed: () {
              // TODO (nphair): Really should be going through the bloc.
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  Constants.QUESTIONNAIRE_TOASTER_MESSAGE,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Constants.QUESTIONNAIRE_TOASTER_FONT_SIZE),
                ),
                duration:
                    Duration(seconds: Constants.QUESTIONNAIRE_TOASTER_DURATION),
              ));

              Future.delayed(
                  const Duration(
                      seconds: Constants.QUESTIONNAIRE_TOASTER_DURATION), () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            child: Icon(Icons.send),
            backgroundColor: const Color(Constants.COLORS_UVA_BLUE)),
      ),
    );
  }

  void scrollHandler() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      showFloationButton();
    } else {
      hideFloationButton();
    }
  }

  Card cardForSection(SurveySection section) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title!,
                  ),
                  Text(section.subtitle!),
                ],
              )),
          QuestionOptionsWidget(section.options)
        ],
      ),
    );
  }
}

class QuestionOptionsWidget extends StatefulWidget {
  final List<SurveyOption?>? options;

  QuestionOptionsWidget(this.options);

  @override
  QuestionOptionsWidgetState createState() =>
      new QuestionOptionsWidgetState(options);
}

class QuestionOptionsWidgetState extends State<QuestionOptionsWidget> {
  final List<SurveyOption?>? options;
  final Map<String, bool> chosen;

  QuestionOptionsWidgetState(this.options)
      : this.chosen =
            Map.fromIterable(options!, key: (o) => o.id, value: (_) => false);

  @override
  Widget build(BuildContext context) {
    return new Column(
        children: this
            .options!
            .map((option) => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Color(Constants.COLORS_UVA_BLUE),
                  title: Text(option!.description!),
                  value: this.chosen[option.id],
                  onChanged: (bool? value) {
                    setState(() {
                      // TODO (nphair): Update the bloc too
                      this.chosen[option.id!] = value!;
                    });
                  },
                ))
            .toList());
  }
}
