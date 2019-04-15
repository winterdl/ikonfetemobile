import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/utils/facebook_auth.dart';
import 'package:meta/meta.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

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

class _FacebookLoginEvent extends LoginEvent {
  final bool isArtist;

  _FacebookLoginEvent({@required this.isArtist});
}

class LoginState extends Equatable {
  final bool isLoading;
  final String email;
  final String password;
  final AuthResult authResult;

  LoginState({
    this.isLoading,
    this.email,
    this.password,
    this.authResult,
  }) : super([isLoading, email, password, authResult]);

  factory LoginState.initial() {
    return LoginState(
      isLoading: false,
      email: null,
      password: null,
      authResult: null,
    );
  }

  LoginState copyWith({
    bool isLoading,
    String email,
    String password,
    AuthResult authResult,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      authResult: authResult ?? null,
    );
  }
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc() : authRepository = Registry().authRepository();

  @override
  LoginState get initialState => LoginState.initial();

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    super.onTransition(transition);
    final event = transition.event;

    if (event is EmailLogin) {
      dispatch(_EmailLogin(isArtist: event.isArtist));
    }

    if (event is FacebookLoginEvent) {
      dispatch(_FacebookLoginEvent(
        isArtist: event.isArtist,
      ));
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

    if (event is EmailLogin || event is FacebookLoginEvent) {
      yield state.copyWith(isLoading: true);
    }

    if (event is _EmailLogin) {
      final authResult = await (authRepository as EmailAuthRepository)
          .emailLogin(event.isArtist, state.email, state.password);
      yield state.copyWith(authResult: authResult, isLoading: false);
    }

    if (event is _FacebookLoginEvent) {
      final authResult = await _facebookAuth(event.isArtist);
      yield state.copyWith(isLoading: false, authResult: authResult);
    }
  }

  Future<AuthResult> _facebookAuth(bool isArtist) async {
    final fbAuth = FacebookAuth();
    final result = await fbAuth.facebookAuth(
        loginBehaviour: FacebookLoginBehavior.nativeWithFallback);
    if (result.success) {
      final authResult = await (authRepository as FacebookAuthRepository)
          .facebookLogin(isArtist, result.facebookUID, result.accessToken);
      return authResult;
    } else {
      return AuthResult(
          success: false, isThirdParty: true, error: result.errorMessage);
    }
  }
}
