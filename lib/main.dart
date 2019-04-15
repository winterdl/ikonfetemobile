import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/routes.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IkonfeteApp extends StatefulWidget {
  final SharedPreferences preferences;

//  final FirebaseUser currentUser;
  final CurrentUserHolder currentUser;

  IkonfeteApp({
    @required this.preferences,
//    @required this.currentUser,
    @required this.currentUser,
  });

  @override
  IkonfeteAppState createState() {
    return IkonfeteAppState();
  }
}

class IkonfeteAppState extends State<IkonfeteApp> {
  AppBloc _appBloc;

  @override
  void initState() {
    super.initState();
    defineRoutes(router);

    _appBloc = AppBloc(
      preferences: widget.preferences,
      initialCurrentUser: widget.currentUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return IkTheme(
          child: BlocProvider<AppBloc>(
            bloc: _appBloc,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                // primarySwatch: primaryColor,
                fontFamily: "SanFranciscoDisplay",
              ),
              onGenerateRoute: (settings) {
                final routeMatch = router.match(settings.name);
                final params = routeMatch.parameters;
                Handler handler = routeMatch.route.handler;
                return CupertinoPageRoute(
                  builder: (ctx) {
                    return handler.handlerFunc(ctx, params);
                  },
                  settings: settings,
                );
              },
              home: BlocBuilder<AppEvent, AppState>(
                bloc: _appBloc,
                builder: (context, appState) {
                  ScreenUtil.instance = ScreenUtil(
                      width: 375, height: 812, allowFontScaling: true)
                    ..init(context);
                  return FutureBuilder<Widget>(
                    builder: (context, snapshot) => snapshot.data,
                    future: _getHomeScreen(_appBloc),
                    initialData: LoadingScreen(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Widget> _getHomeScreen(AppBloc appBloc) async {
    final emailAuthRepo = Registry().authRepository();
    final currentUser = await emailAuthRepo.getCurrentUser();
    return Routes.getHomePage(context, appBloc, currentUser, false);
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bodyColor,
        alignment: Alignment.center,
        child: HudOverlay.dotsLoadingIndicator(),
      ),
    );
  }
}
