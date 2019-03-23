import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/screens/home/artist_home_screen.dart';
import 'package:ikonfete/screens/home/fan_home_screen.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';

Screen homeScreen() {
  return Screen(
    title: "HOME",
    contentBuilder: (BuildContext context) {
      final appBloc = BlocProvider.of<AppBloc>(context);
      return BlocBuilder<AppEvent, AppState>(
        bloc: appBloc,
        builder: (BuildContext ctx, AppState appState) {
          if (appState.isArtist) {
            return artistHomeScreen(ctx, null);// todo
          } else {
            return fanHomeScreen(ctx, null); // todo
          }
        },
      );
    },
  );
}
