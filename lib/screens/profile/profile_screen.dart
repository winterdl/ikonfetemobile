import 'package:flutter/material.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';

final Screen profileScreen = Screen(
  title: "Profile",
  contentBuilder: (ctx) {
    return Container(
      color: Colors.white,
    );
//    final appBloc = BlocProvider.of<AppBloc>(ctx);
//    return BlocBuilder<AppEvent, AppState>(
//      bloc: appBloc,
//      builder: (BuildContext appCtx, AppState appState) {
//        final profileScreenBloc =
//        ProfileScreenBloc(appConfig: AppConfig.of(ctx));
//        return ProfileScreen(appState: appState, bloc: profileScreenBloc);
//      },
//    );
  },
);
