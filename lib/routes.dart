import 'package:fluro/fluro.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/screens/activation/activation_screen.dart';
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
    Routes.verificationScreen(),
    handler: Handler(handlerFunc: (ctx, params) {
      final uid = params["uid"][0];
      return verificationScreen(ctx, uid);
    }),
  );

  router.define(
    Routes.pendingVerificationScreen(),
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

  static String verificationScreen({String uid}) {
    return "/verification/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }

  static String pendingVerificationScreen({String uid}) {
    return "/peding_verification/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }
}
