import 'package:flutter/material.dart';
import 'package:submission_site/state/view/view.dart';
import 'package:submission_site/state_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'State Concept',
      home: StateRoute(
        repository: StateRepository<int>(),
      ),
    );
  }
}
