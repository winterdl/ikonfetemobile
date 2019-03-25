import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';

abstract class ResetPasswordScreenEvent {}

class EmailEntered extends ResetPasswordScreenEvent {
  final String email;

  EmailEntered(this.email);
}

class GetResetLink extends ResetPasswordScreenEvent {}

class _GetReseLink extends ResetPasswordScreenEvent {}

class CodeEntered extends ResetPasswordScreenEvent {
  final String code;

  CodeEntered(this.code);
}

class ResetPasswordState extends Equatable {
  final bool isLoading;
  final String email;

  ResetPasswordState({
    @required this.isLoading,
    @required this.email,
    @required this.sendEmailResult,
  }) : super([isLoading, email, sendEmailResult]);

  final Pair<bool, String> sendEmailResult;

  factory ResetPasswordState.initial() => ResetPasswordState(
        isLoading: false,
        email: null,
        sendEmailResult: null,
      );

  ResetPasswordState copyWith({
    bool isLoading,
    String email,
    Pair<bool, String> sendEmailResult,
  }) {
    return ResetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      sendEmailResult: sendEmailResult ?? null,
    );
  }
}

class ResetPasswordBloc
    extends Bloc<ResetPasswordScreenEvent, ResetPasswordState> {
  final bool isArtist;
  final FirebaseAuth _firebaseAuth;

  ResetPasswordBloc({@required this.isArtist})
      : _firebaseAuth = FirebaseAuth.instance;

  @override
  ResetPasswordState get initialState {
    print("CALLING INIT STATE");
    return ResetPasswordState.initial();
  }

  @override
  void onTransition(
      Transition<ResetPasswordScreenEvent, ResetPasswordState> transition) {
    final event = transition.event;
    if (event is GetResetLink) {
      dispatch(_GetReseLink());
    }
  }

  @override
  Stream<ResetPasswordState> mapEventToState(
      ResetPasswordState currentState, ResetPasswordScreenEvent event) async* {
    if (event is GetResetLink) {
      yield currentState.copyWith(isLoading: true);
    }

    if (event is EmailEntered) {
      yield currentState.copyWith(isLoading: false, email: event.email);
    }

    if (event is _GetReseLink) {
      try {
        await _firebaseAuth.sendPasswordResetEmail(email: currentState.email);
        yield currentState.copyWith(
            isLoading: false, sendEmailResult: Pair.from(true, null));
      } on PlatformException catch (e) {
        if (e.code == "ERROR_INVALID_EMAIL") {
          print("Failed send password reset email. ${e.message}");
          yield currentState.copyWith(
              isLoading: false, sendEmailResult: Pair.from(false, e.message));
        } else if (e.code == "ERROR_USER_NOT_FOUND") {
          print("Failed send password reset email. ${e.message}");
          yield currentState.copyWith(
              isLoading: false, sendEmailResult: Pair.from(false, e.message));
        }
      } on Exception catch (e) {
        print("Failed send password reset email. ${e.toString()}");
        yield currentState.copyWith(
            isLoading: false, sendEmailResult: Pair.from(false, e.toString()));
      }
    }
  }
}
