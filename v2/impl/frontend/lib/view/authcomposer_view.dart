import 'package:authcompose/view/authcomposer_frontend_mediator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sequentialcompose/bloc/sequentialcomposer_bloc.dart';

// __COMPOSE_IMPORTS__

class AuthComposerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: const Text(">"),
        onPressed: () {
          BlocProvider.of<SequentialComposerBloc>(context)
              .add(const SequentialComposerNextEvent());
        },
      ),
      body: const AuthComposerFrontendMediator(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Composition is Fun'),
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                // __COMPOSE_SIGNOUT__
              },
            ),
          ],
        ),
      ),
    );
  }
}
