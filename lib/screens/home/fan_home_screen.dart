import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';

Widget fanHomeScreen(BuildContext context, String uid) {
  return FanHomeScreen();
}

class FanHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    return BlocBuilder<AppEvent, AppState>(
      bloc: appBloc,
      builder: (ctx, appState) {
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: FlatButton(
            onPressed: () {
              appBloc.dispatch(Signout());
            },
            child: Text("FAN HOME: LOGOUT"),
          ),
        );
      },
    );
  }
}
