import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';

Widget artistHomeScreen(BuildContext context, String uid) {
  return ArtistHomeScreen();
}

class ArtistHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    return BlocBuilder<AppEvent, AppState>(
      bloc: appBloc,
      builder: (ctx, appState) {
        return Container(
          alignment: Alignment.center,
          child: FlatButton(
            onPressed: () {
              appBloc.dispatch(Signout());
            },
            child: Text("ARTIST HOME: LOGOUT"),
          ),
        );
      },
    );
  }
}
