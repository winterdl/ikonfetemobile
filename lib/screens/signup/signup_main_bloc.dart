import 'package:bloc/bloc.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/screens/signup/bloc_models.dart';
import 'package:meta/meta.dart';

abstract class SignupMainScreenEvent {}

class NameEntered extends SignupMainScreenEvent {
  final String name;

  NameEntered(this.name);
}

class EmailEntered extends SignupMainScreenEvent {
  final String email;

  EmailEntered(this.email);
}

class PasswordEntered extends SignupMainScreenEvent {
  final String password;

  PasswordEntered(this.password);
}

class ValidateForm extends SignupMainScreenEvent {
  final bool isArtist;

  ValidateForm({this.isArtist});
}

class _ValidateForm extends SignupMainScreenEvent {
  final bool isArtist;

  _ValidateForm({this.isArtist});
}

class SignupMainScreenState {
  final String name;
  final String email;
  final String password;
  final bool isLoading;
  final SignupValidationResult result;

  SignupMainScreenState({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.isLoading,
    @required this.result,
  });

  factory SignupMainScreenState.initial() {
    return SignupMainScreenState(
      name: null,
      email: null,
      password: null,
      isLoading: false,
      result: null,
    );
  }

  SignupMainScreenState copyWith({
    String name,
    String email,
    String password,
    bool isLoading,
    SignupValidationResult result,
  }) {
    return SignupMainScreenState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
    );
  }

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is SignupMainScreenState &&
      runtimeType == other.runtimeType &&
      name == other.name &&
      email == other.email &&
      password == other.password &&
      result == other.result;

  @override
  int get hashCode =>
      name.hashCode ^ email.hashCode ^ password.hashCode ^ result.hashCode;
}

class SignupMainBloc
    extends Bloc<SignupMainScreenEvent, SignupMainScreenState> {
  final EmailAuth emailAuthRepository;

  SignupMainBloc() : emailAuthRepository = Registry().emailAuthRepository();

  @override
  SignupMainScreenState get initialState => SignupMainScreenState.initial();

  @override
  void onTransition(
      Transition<SignupMainScreenEvent, SignupMainScreenState> transition) {
    final event = transition.event;
    if (event is ValidateForm) {
      dispatch(_ValidateForm(isArtist: event.isArtist));
    }
  }

  @override
  Stream<SignupMainScreenState> mapEventToState(
      SignupMainScreenState state, SignupMainScreenEvent event) async* {
    if (event is NameEntered) {
      yield state.copyWith(name: event.name);
    }
    if (event is EmailEntered) {
      yield state.copyWith(email: event.email);
    }
    if (event is PasswordEntered) {
      yield state.copyWith(password: event.password);
    }

    if (event is ValidateForm) {
      yield state.copyWith(isLoading: true);
    }

    if (event is _ValidateForm) {
      final result = await validateForm(state);
      yield state.copyWith(result: result, isLoading: false);
    }
  }

  Future<SignupValidationResult> validateForm(
      SignupMainScreenState state) async {
    final validationResult =
        await emailAuthRepository.validateEmail(state.email);
    return SignupValidationResult(
        name: state.name,
        email: state.email,
        password: state.password,
        success: validationResult.isValid,
        error: validationResult.error);
  }

//  Future<AuthResult> _emailSignup(SignupState state, bool isArtist) async {
//    final authActionRequest = AuthActionRequest(
//        provider: AuthProvider.email,
//        userType: isArtist ? AuthUserType.artist : AuthUserType.fan);
//
//    final authApi = AuthApiFactory.authApi(
//        appConfig.serverBaseUrl, authActionRequest.userType);
//    final signupResult = AuthResult(request: authActionRequest);
//
//    try {
//      final authResult =
//          await authApi.signup(state.name, state.email, state.password);
//      await FirebaseAuth.instance.signInWithEmailAndPassword(
//          email: state.email, password: state.password);
//      if (authActionRequest.isArtist) {
//        signupResult.artist = authResult;
//      } else {
//        signupResult.fan = authResult;
//      }
//      return signupResult;
//    } on Exception catch (e) {
//      signupResult.errorMessage = e.toString();
//      return signupResult;
//    }
//  }
//
//  Future<AuthResult> _facebookSignup(SignupState state, bool isArtist) async {
//    final authRequest = AuthActionRequest(
//        provider: AuthProvider.facebook,
//        userType: isArtist ? AuthUserType.artist : AuthUserType.fan);
//    final authApi =
//        AuthApiFactory.authApi(appConfig.serverBaseUrl, authRequest.userType);
//
//    try {
//      final facebookLogin = FacebookLogin();
//      facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
//      await facebookLogin.logOut();
//      final facebookLoginResult = await facebookLogin.logInWithReadPermissions(
//        [
//          'email',
//          'public_profile',
//          'user_posts',
//          'user_events',
//        ],
//      );
//
//      if (facebookLoginResult.status != FacebookLoginStatus.loggedIn) {
//        return AuthResult.error(
//            authRequest,
//            facebookLoginResult.status == FacebookLoginStatus.cancelledByUser
//                ? "Login Cancelled"
//                : facebookLoginResult.errorMessage);
//      }
//
////      final firebaseUser = await FirebaseAuth.instance.signInWithFacebook(
////          accessToken: facebookLoginResult.accessToken.token);
//      final facebookAuthCredential = FacebookAuthProvider.getCredential(
//          accessToken: facebookLoginResult.accessToken.token);
//      final firebaseUser = await FirebaseAuth.instance
//          .signInWithCredential(facebookAuthCredential);
//      if (firebaseUser == null) {
//        return AuthResult.error(authRequest, "Facebook Sign up failed");
//      }
//
//      final signupResult = AuthResult(request: authRequest);
//      final artistOrFan = await authApi.facebookSignup(
//          firebaseUser.uid, facebookLoginResult.accessToken.userId);
//      if (artistOrFan.isFirst) {
//        signupResult.artist = artistOrFan.first;
//      } else {
//        signupResult.fan = artistOrFan.second;
//      }
//      return signupResult;
//    } on PlatformException catch (e) {
//      return AuthResult.error(authRequest, e.message);
//    } on Exception catch (e) {
//      return AuthResult.error(authRequest, e.toString());
//    }
//  }
}
