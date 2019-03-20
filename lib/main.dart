import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:ikonfete/localization.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/routes.dart';
import 'package:ikonfete/screens/login/login.dart';
import 'package:ikonfete/screens/pending_verification/pending_verification_screen.dart';
import 'package:ikonfete/screens/team_selection/team_selection_screen.dart';
import 'package:ikonfete/screens/verification/verification_screen.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
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
      initialCurrentUser: widget.currentUser,
      initialCurrentArtistOrFan: widget.currentArtistOrFan,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      bloc: _appBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
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
            return FutureBuilder<Widget>(
              builder: (context, snapshot) => snapshot.data,
              future: _getHomeScreen(),
              initialData: LoadingScreen(),
            );
          },
        ),
      ),
    );
  }

  Future<Widget> _getHomeScreen() async {
    final emailAuthRepo = Registry().emailAuthRepository();
    final currentUser = await emailAuthRepo.getCurrentUser();
    if (currentUser == null || !currentUser.isEmailActivated) {
      return loginScreen(context);
    }

//    if (!currentUser.isEmailActivated) {
//      return activationScreen(context, currentUser.uid, activationRepository);
//    }

    if (currentUser.isArtist) {
      if (currentUser.isArtistVerified) {
        // todo: to artist home screen
      } else if (currentUser.isArtistPendingVerification) {
        // to pending verification screen
        return pendingVerificationScreen(context, currentUser.uid);
      } else {
        // to verification screen
        return verificationScreen(context, currentUser.uid);
      }
    } else {
      if (currentUser.isFanInTeam) {
        // todo: fan home screen
      } else {
        return teamSelectionScreen(context, currentUser.uid);
      }
    }

    return loginScreen(context);
  }

//  static Widget getInitialScreen(BuildContext context, AppState state) {
//    if (!state.isOnBoarded) {
//      return OnBoardingScreen();
//    } else if (state.isLoggedIn) {
//      if (!state.isProfileSetup) {
//        return userSignupProfileScreen(context, state.uid);
//      } else if (state.isArtist) {
//        if (state.artistOrFan.first.isVerified) {
//          return ZoomScaffoldScreen(
//            screenId: 'home',
//            appState: state,
//          );
//        } else if (state.artistOrFan.first.isPendingVerification) {
//          return pendingVerificationScreen(context, state.uid);
//        } else {
//          return artistVerificationScreen(context, state.uid);
//        }
//      } else {
//        // check if fan team is setup
//        if (state.isFanTeamSetup) {
//          return ZoomScaffoldScreen(
//            screenId: 'home',
//            appState: state,
//          );
//        } else {
//          return teamSelectionScreen(context, state.uid);
//        }
//      }
//    } else {
//      return loginScreen(context);
//    }
////    return loginScreen(context);
//  }
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
