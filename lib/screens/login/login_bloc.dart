import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:ikonfete/app_config.dart';
import 'package:ikonfete/exceptions.dart';
import 'package:ikonfete/model/auth_type.dart';
import 'package:ikonfete/model/auth_utils.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent {}

class EmailEntered extends LoginEvent {
  final String email;

  EmailEntered(this.email);
}

class PasswordEntered extends LoginEvent {
  final String password;

  PasswordEntered(this.password);
}

class EmailLogin extends LoginEvent {
  final bool isArtist;

  EmailLogin({@required this.isArtist});
}

class _EmailLogin extends LoginEvent {
  final bool isArtist;

  _EmailLogin({@required this.isArtist});
}

class FacebookLoginEvent extends LoginEvent {
  final bool isArtist;

  FacebookLoginEvent({@required this.isArtist});
}

class LoginState {
  final bool isLoading;
  final String email;
  final String password;
  final EmailAuthResult emailAuthResult;

  LoginState({
    this.isLoading,
    this.email,
    this.password,
    this.emailAuthResult,
  });

  factory LoginState.initial() {
    return LoginState(
      isLoading: false,
      email: null,
      password: null,
      emailAuthResult: null,
    );
  }

  LoginState copyWith({
    bool isLoading,
    String email,
    String password,
    EmailAuthResult emailAuthResult,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      emailAuthResult: emailAuthResult,
    );
  }

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is LoginState &&
      runtimeType == other.runtimeType &&
      isLoading == other.isLoading &&
      email == other.email &&
      password == other.password &&
      emailAuthResult == other.emailAuthResult;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      email.hashCode ^
      password.hashCode ^
      emailAuthResult.hashCode;
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final EmailAuth emailAuthRepository;

  LoginBloc() : emailAuthRepository = Registry().emailAuthRepository();

  @override
  LoginState get initialState => LoginState.initial();

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    super.onTransition(transition);
    final event = transition.event;

    if (event is EmailLogin) {
      dispatch(_EmailLogin(isArtist: event.isArtist));
    }
  }

  @override
  Stream<LoginState> mapEventToState(
      LoginState state, LoginEvent event) async* {
    if (event is EmailEntered) {
      yield state.copyWith(email: event.email);
    }

    if (event is PasswordEntered) {
      yield state.copyWith(password: event.password);
    }

    if (event is EmailLogin) {
      yield state.copyWith(isLoading: true);
    }

    if (event is _EmailLogin) {
      final authResult = await emailAuthRepository.emailLogin(
          event.isArtist, state.email, state.password);
      yield state.copyWith(emailAuthResult: authResult, isLoading: false);
    }

//    if (event is FacebookLoginEvent) {
//      final authResult = await _facebookLogin(state, event.isArtist);
//      yield state.copyWith(loginResult: authResult);
//    }
  }

//  Future<LoginResult> _emailLogin(LoginState state, bool isArtist) async {
//    final authActionRequest = AuthActionRequest(
//        provider: AuthProvider.email,
//        userType: isArtist ? AuthUserType.artist : AuthUserType.fan);
//
//    final authResult = LoginResult(authActionRequest);
//    try {
//      final firebaseUser = await FirebaseAuth.instance
//          .signInWithEmailAndPassword(
//              email: state.email, password: state.password);
//      return authResult;
//    } on PlatformException catch (e) {
//      switch (e.code) {
//        case "Error 17020":
//          authResult.errorMessage = "Network Error.";
//          break;
//        case "Error 17009":
//        default:
//          authResult.errorMessage = "Invalid email or password.";
//          break;
//      }
//      return authResult;
//    } on AppException catch (e) {
//      authResult.errorMessage = e.message;
//      return authResult;
//    } on Exception {
//      authResult.errorMessage = "An unknown error occurred";
//      return authResult;
//    }
//  }
//
//  Future<LoginResult> _facebookLogin(LoginState state, bool isArtist) async {
//    final authRequest = AuthActionRequest(
//        provider: AuthProvider.facebook,
//        userType: isArtist ? AuthUserType.artist : AuthUserType.fan);
//    try {
//      final authResult = LoginResult(authRequest);
//
//      final facebookLogin = FacebookLogin();
//      facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
//      await facebookLogin.logOut();
//      final result = await facebookLogin.logInWithReadPermissions(
//        [
//          'email',
//          'public_profile',
//          'user_posts',
//          'user_events',
//        ],
//      );
//      if (result.status != FacebookLoginStatus.loggedIn) {
//        authResult.errorMessage =
//            result.status == FacebookLoginStatus.cancelledByUser
//                ? "Login Cancelled"
//                : result.errorMessage;
//        return authResult;
//      }
//
////      final firebaseUser = await FirebaseAuth.instance
////          .signInWithFacebook(accessToken: result.accessToken.token);
//      final facebookCredential = FacebookAuthProvider.getCredential(
//          accessToken: result.accessToken.token);
//      final firebaseUser =
//          await FirebaseAuth.instance.signInWithCredential(facebookCredential);
//
//      // find the user
////      if (authRequest.isArtist) {
////        final artistApi = ArtistApi(appConfig.serverBaseUrl);
////        final artist = await artistApi.findByUID(firebaseUser.uid);
////        authResult.artist = artist;
////      } else {
////        final fanApi = FanApi(appConfig.serverBaseUrl);
////        final fan = await fanApi.findByUID(firebaseUser.uid);
////        authResult.fan = fan;
////      }
////      authResult.firebaseUser = firebaseUser;
//      return authResult;
//    } on AppException catch (e) {
//      return LoginResult(authRequest)..errorMessage = e.message;
//    } on PlatformException catch (e) {
//      return LoginResult(authRequest)..errorMessage = e.message;
//    } on Exception catch (e) {
//      return LoginResult(authRequest)..errorMessage = e.toString();
//    }
//  }
}
