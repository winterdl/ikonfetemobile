import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:meta/meta.dart';

abstract class SignupProfileScreenEvent {}

class SignupProfileEntered extends SignupProfileScreenEvent {
  final bool isArtist;
  final String username;
  final File profilePicture;
  final String countryCode;
  final String countryName;

  SignupProfileEntered({
    @required this.isArtist,
    @required this.username,
    @required this.profilePicture,
    @required this.countryCode,
    @required this.countryName,
  });
}

class _SignupProfileEntered extends SignupProfileScreenEvent {
  final bool isArtist;
  final String username;
  final File profilePicture;
  final String countryCode;
  final String countryName;

  _SignupProfileEntered({
    @required this.isArtist,
    @required this.username,
    @required this.profilePicture,
    @required this.countryCode,
    @required this.countryName,
  });
}

class SignupProfileScreenState {
  final bool isLoading;
  final String username;
  final File profilePicture;
  final String countryIsoCode;
  final String countryName;
  final SignupResult result;

  SignupProfileScreenState({
    this.isLoading,
    this.username,
    this.profilePicture,
    this.countryIsoCode,
    this.countryName,
    this.result,
  });

  factory SignupProfileScreenState.initial() {
    return SignupProfileScreenState(
      isLoading: false,
      username: null,
      profilePicture: null,
      countryIsoCode: null,
      countryName: null,
      result: null,
    );
  }

  SignupProfileScreenState copyWith({
    bool isLoading,
    String username,
    File profilePicture,
    String countryIsoCode,
    String countryName,
    SignupResult result,
  }) {
    return SignupProfileScreenState(
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      profilePicture: profilePicture ?? this.profilePicture,
      countryIsoCode: countryIsoCode ?? this.countryIsoCode,
      countryName: countryName ?? this.countryName,
      result: result,
    );
  }

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is SignupProfileScreenState &&
      runtimeType == other.runtimeType &&
      isLoading == other.isLoading &&
      username == other.username &&
      profilePicture == other.profilePicture &&
      countryIsoCode == other.countryIsoCode &&
      countryName == other.countryName &&
      result == other.result;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      username.hashCode ^
      profilePicture.hashCode ^
      countryIsoCode.hashCode ^
      countryName.hashCode ^
      result.hashCode;
}

class SignupProfileBloc
    extends Bloc<SignupProfileScreenEvent, SignupProfileScreenState> {
  final String name;
  final String email;
  final String password;
  final EmailAuth authRepository;

  SignupProfileBloc({
    @required this.name,
    @required this.email,
    @required this.password,
  }) : authRepository = Registry().emailAuthRepository();

  @override
  SignupProfileScreenState get initialState =>
      SignupProfileScreenState.initial();

  @override
  void onTransition(
      Transition<SignupProfileScreenEvent, SignupProfileScreenState>
          transition) {
    super.onTransition(transition);
    final event = transition.event;
    if (event is SignupProfileEntered) {
      dispatch(_SignupProfileEntered(
          isArtist: event.isArtist,
          username: event.username,
          profilePicture: event.profilePicture,
          countryCode: event.countryCode,
          countryName: event.countryName));
    }
  }

  @override
  Stream<SignupProfileScreenState> mapEventToState(
      SignupProfileScreenState currentState,
      SignupProfileScreenEvent event) async* {
    if (event is SignupProfileEntered) {
      yield currentState.copyWith(isLoading: true);
    }

    if (event is _SignupProfileEntered) {
      final result = await _createUser(event.isArtist,
          username: event.username,
          countryIsoCode: event.countryCode,
          countryName: event.countryName,
          profilePicture: event.profilePicture);
      yield currentState.copyWith(isLoading: false, result: result);
    }
  }

  Future<SignupResult> _createUser(bool isArtist,
      {@required String username,
      @required String countryIsoCode,
      @required String countryName,
      File profilePicture}) async {
    final user = isArtist ? Artist() : Fan();
    user
      ..name = name
      ..email = email
      ..username = username
      ..countryIsoCode = countryIsoCode
      ..country = countryName;

    final signupData =
        SignupData(user, password, profilePicture: profilePicture);
    final signupResult = await authRepository.signup(signupData);
    return signupResult;
  }
}
