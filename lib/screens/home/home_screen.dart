import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/screens/home/artist_home_screen.dart';
import 'package:ikonfete/screens/home/fan_home/fan_home_screen.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';

Screen homeScreen(String uid) {
  return Screen(
    title: "HOME",
    contentBuilder: (BuildContext context) {
      final appBloc = BlocProvider.of<AppBloc>(context);
      return BlocBuilder<AppEvent, AppState>(
        bloc: appBloc,
        builder: (BuildContext ctx, AppState appState) {
          if (appState.isArtist) {
            return artistHomeScreen(ctx, uid); // todo
          } else {
            return fanHomeScreen(ctx, uid); // todo
          }
        },
      );
    },
  );
}
