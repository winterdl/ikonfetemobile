import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/screens/login/login.dart';
import 'package:ikonfete/screens/pending_verification/pending_verification_screen.dart';
import 'package:ikonfete/screens/signup/signup_main_screen.dart';
import 'package:ikonfete/screens/team_selection/team_selection_screen.dart';
import 'package:ikonfete/screens/verification/verification_screen.dart';

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
}

class Routes {
  static final String login = "/login";
  static final String signup = "/signup";

  static String teamSelection({String uid}) {
    return "/team_selection/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }

  static String verificationScreenRoute({String uid}) {
    return "/verification/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }

  static String pendingVerificationScreenRoute({String uid}) {
    return "/peding_verification/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }

  static Widget getHomePage(
      BuildContext context, CurrentUserHolder currentUser) {
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
}
