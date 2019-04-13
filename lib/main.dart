import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/routes.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IkonfeteApp extends StatefulWidget {
  final SharedPreferences preferences;
  final FirebaseUser currentUser;
  final ExclusivePair<Artist, Fan> currentArtistOrFan;

  IkonfeteApp(
      {@required this.preferences,
      @required this.currentUser,
      @required this.currentArtistOrFan});

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
      initialCurrentArtistOrFan: widget.currentArtistOrFan,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          builder: (context, _) {
            ScreenUtil.instance =
                ScreenUtil(width: 375, height: 812, allowFontScaling: true)
                  ..init(context);

            return BlocBuilder<AppEvent, AppState>(
              bloc: _appBloc,
              builder: (context, appState) {
                return FutureBuilder<Widget>(
                  builder: (context, snapshot) => snapshot.data,
                  future: _getHomeScreen(_appBloc),
                  initialData: LoadingScreen(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<Widget> _getHomeScreen(AppBloc appBloc) async {
    final emailAuthRepo = Registry().emailAuthRepository();
    final currentUser = await emailAuthRepo.getCurrentUser();
    return Routes.getHomePage(context, appBloc, currentUser);
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
