import 'package:fluro/fluro.dart';
import 'package:ikonfete/di.dart';
import 'package:ikonfete/screens/activation/activation_screen.dart';
import 'package:ikonfete/screens/login/login.dart';
import 'package:ikonfete/screens/signup/signup_main_screen.dart';
import 'package:ikonfete/screens/team_selection/team_selection_screen.dart';

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

//  router.define(
//    Routes.activation(),
//    handler: Handler(handlerFunc: (ctx, params) {
//      final uid = params["uid"][0];
//      return activationScreen(ctx, uid, activationRepository);
//    }),
//  );

  router.define(
    Routes.teamSelection(),
    handler: Handler(
      handlerFunc: (ctx, params) {
        final uid = params["uid"][0];
        return teamSelectionScreen(ctx, uid);
      },
    ),
  );
}

class Routes {
  static final String login = "/login";
  static final String signup = "/signup";

//  static String activation({String uid}) {
//    return "/activation/${uid == null || uid.isEmpty ? ":uid" : uid}";
//  }

  static String teamSelection({String uid}) {
    return "/team_selection/${uid == null || uid.isEmpty ? ":uid" : uid}";
  }
}
