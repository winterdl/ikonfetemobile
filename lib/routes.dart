import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/screens/login/login_screen.dart';
import 'package:ikonfete/screens/pending_verification/pending_verification_screen.dart';
import 'package:ikonfete/screens/reset_password/reset_password_screen.dart';
import 'package:ikonfete/screens/signup/signup_main_screen.dart';
import 'package:ikonfete/screens/team_selection/team_selection_screen.dart';
import 'package:ikonfete/screens/verification/verification_screen.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold_screen.dart';

final registry = Registry();
final router = Router();

void defineRoutes(Router router) {
  router.define(
    Routes.login,
    handler: Handler(
      handlerFunc: (ctx, params) => loginScreen(ctx),
    ),
  );

  router.define(
    Routes.signup,
    handler: Handler(
      handlerFunc: (ctx, params) => signupMainScreen(ctx),
    ),
  );

  router.define(
    Routes.resetPassword,
    handler: Handler(
      handlerFunc: (ctx, params) => resetPasswordScreen(ctx),
    ),
  );

  router.define(
    Routes.teamSelection(),
    handler: Handler(
      handlerFunc: (ctx, params) {
        final uid = params["uid"][0];
        return teamSelectionScreen(ctx, uid);
      },
    ),
  );

  router.define(
    Routes.verificationScreenRoute(),
    handler: Handler(handlerFunc: (ctx, params) {
      final uid = params["uid"][0];
      return verificationScreen(ctx, uid);
    }),
  );

  router.define(
    Routes.pendingVerificationScreenRoute(),
    handler: Handler(handlerFunc: (ctx, params) {
      final uid = params["uid"][0];
      return pendingVerificationScreen(ctx, uid);
    }),
  );

  router.define(
    Routes.artistHomeScreenRoute(),
    handler: Handler(handlerFunc: (ctx, params) {
      final uid = params["uid"][0];
      return zoomScaffoldScreen(ctx, true, uid, 'home');
    }),
  );

  router.define(
    Routes.fanHomeScreenRoute(),
    handler: Handler(handlerFunc: (ctx, params) {
      final uid = params["uid"][0];
      return zoomScaffoldScreen(ctx, false, uid, 'home');
    }),
  );
}

class Routes {
  static final String login = "/login";
  static final String signup = "/signup";
  static final String resetPassword = "/reset_password";

  static String teamSelection({String uid}) {
    return "/team_selection/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }

  static String verificationScreenRoute({String uid}) {
    return "/verification/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }

  static String pendingVerificationScreenRoute({String uid}) {
    return "/peding_verification/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }

  static String artistHomeScreenRoute({String uid}) {
    return "/artist_home/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }

  static String fanHomeScreenRoute({String uid}) {
    return "/fan_home/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }

  static Widget getHomePage(
      BuildContext context, AppBloc appBloc, CurrentUserHolder currentUser) {
    if (currentUser == null || !currentUser.isEmailActivated) {
      return loginScreen(context);
    }

    if (currentUser.isArtist) {
      if (currentUser.isArtistVerified) {
        // to artist home screen
        return BlocBuilder<AppEvent, AppState>(
          bloc: appBloc,
          builder: (ctx, appState) {
            return zoomScaffoldScreen(
                ctx, currentUser.isArtist, currentUser.uid, 'home');
//            return ZoomScaffoldScreen(
//              screenId: 'home',
//              uid: currentUser.uid,
//              isArtist: currentUser.isArtist,
//              params: <String, String>{},
//            );
          },
        );
      } else if (currentUser.isArtistPendingVerification) {
        // to pending verification screen
        return pendingVerificationScreen(context, currentUser.uid);
      } else {
        // to verification screen
        return verificationScreen(context, currentUser.uid);
      }
    } else {
      if (currentUser.isFanInTeam) {
        // to fan home screen
        return BlocBuilder<AppEvent, AppState>(
          bloc: appBloc,
          builder: (ctx, appState) {
            return zoomScaffoldScreen(
                ctx, currentUser.isArtist, currentUser.uid, 'home');
//            return ZoomScaffoldScreen(
//              screenId: 'home',
//              uid: currentUser.uid,
//              isArtist: currentUser.isArtist,
//              params: <String, String>{},
//            );
          },
        );
      } else {
        // to team selection screen
        return teamSelectionScreen(context, currentUser.uid);
      }
    }
  }
}
