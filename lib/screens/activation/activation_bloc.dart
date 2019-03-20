import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/activation_repository.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';

abstract class ActivationScreenEvent {}

class ActivationCodeEntered extends ActivationScreenEvent {
  final String code;
  final bool isArtist;

  ActivationCodeEntered({@required this.code, @required this.isArtist});
}

class ActivateUser extends ActivationScreenEvent {
  final bool isArtist;
  final String uid;

  ActivateUser({@required this.isArtist, @required this.uid});
}

class _ActivateUser extends ActivationScreenEvent {
  final bool isArtist;
  final String uid;

  _ActivateUser({@required this.isArtist, @required this.uid});
}

class ResendActivation extends ActivationScreenEvent {
  final String uid;
  final bool isArtist;

  ResendActivation({@required this.isArtist, @required this.uid});
}

class _ResendActivation extends ActivationScreenEvent {
  final String uid;
  final bool isArtist;

  _ResendActivation({@required this.isArtist, @required this.uid});
}

class ActivationResult {
  final bool success;
  final String error;
  final bool isArtist;

  ActivationResult(
      {@required this.isArtist, @required this.success, this.error});
}

class ActivationScreenState {
  final bool isLoading;
  final String activationCode;
  final ActivationResult result;
  final Pair<bool, String> resendActivationResult;

  ActivationScreenState({
    @required this.isLoading,
    @required this.activationCode,
    @required this.result,
    @required this.resendActivationResult,
  });

  factory ActivationScreenState.initial() {
    return ActivationScreenState(
      isLoading: false,
      activationCode: null,
      result: null,
      resendActivationResult: null,
    );
  }

  ActivationScreenState copyWith({
    bool isLoading,
    String activationCode,
    ActivationResult result,
    Pair<bool, String> resendActivationResult,
  }) {
    return ActivationScreenState(
      isLoading: isLoading ?? this.isLoading,
      activationCode: activationCode ?? this.activationCode,
      result: result,
      resendActivationResult: resendActivationResult,
    );
  }

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is ActivationScreenState &&
      runtimeType == other.runtimeType &&
      isLoading == other.isLoading &&
      activationCode == other.activationCode &&
      result == other.result &&
      resendActivationResult == other.resendActivationResult;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      activationCode.hashCode ^
      result.hashCode ^
      resendActivationResult.hashCode;
}

class ActivationBloc
    extends Bloc<ActivationScreenEvent, ActivationScreenState> {
  final ActivationRepository _activationRepository;
  final CloudFunctions _cloudFunctions;
  final FirebaseAuth _firebaseAuth;
  final String email;
  final String password;

  ActivationBloc({@required this.email, @required this.password})
      : _activationRepository = Registry().activationRepository(),
        _cloudFunctions = CloudFunctions.instance,
        _firebaseAuth = FirebaseAuth.instance;

  @override
  ActivationScreenState get initialState => ActivationScreenState.initial();

  @override
  void onTransition(
      Transition<ActivationScreenEvent, ActivationScreenState> transition) {
    super.onTransition(transition);
    final event = transition.event;
    if (event is ActivateUser) {
      dispatch(_ActivateUser(isArtist: event.isArtist, uid: event.uid));
    }

    if (event is ResendActivation) {
      dispatch(_ResendActivation(isArtist: event.isArtist, uid: event.uid));
    }
  }

  @override
  Stream<ActivationScreenState> mapEventToState(
      ActivationScreenState state, ActivationScreenEvent event) async* {
    if (event is ActivateUser || event is ResendActivation) {
      yield state.copyWith(isLoading: true);
    }

    if (event is ActivationCodeEntered) {
      final code = event.code;
      yield state.copyWith(activationCode: code);
    }

    if (event is _ActivateUser) {
      final result =
          await _activateUser(state.activationCode, event.uid, event.isArtist);
      yield state.copyWith(
        isLoading: false,
        result: result,
        resendActivationResult: null,
      );
    }

    if (event is _ResendActivation) {
      final result = await _resendActivation(event.uid);
      yield state.copyWith(
        isLoading: false,
        result: null,
        resendActivationResult: result,
      );
    }
  }

  Future<Pair<bool, String>> _resendActivation(String uid) async {
    final result = await CloudFunctions.instance
        .call(functionName: "resendActivationCode", parameters: {"uid": uid});
    if (result == null || result["success"] == false) {
      var msg =
          result == null ? "Failed to resend activation" : result["error"];
      return Pair.from(false, msg);
    }

    return Pair.from(true, null);
  }

  Future<ActivationResult> _activateUser(
      String code, String uid, bool isArtist) async {
    try {
      // find activation by uid
      final activation = await _activationRepository.findByUID(uid);
      if (activation == null) {
        return ActivationResult(
            isArtist: isArtist, success: false, error: "User not signed up");
      }

      // check for valid code
      if (activation.code != code) {
        return ActivationResult(
            isArtist: isArtist,
            success: false,
            error: "Incorrect activation code");
      }

      // check for expired activation
      if (activation.isExpired) {
        return ActivationResult(
            isArtist: isArtist,
            success: false,
            error:
                "This activation code has expired. Please request for another.");
      }

      _firebaseAuth.signOut();

      // call cloud function
      final result = await _cloudFunctions
          .call(functionName: "activateUser", parameters: {"uid": uid});
      if (result == null || result["success"] == false) {
        String msg = result == null ? "" : result["error"];
        print("Failed to update firebase auth entry for user $uid. $msg");
        return ActivationResult(
            isArtist: isArtist, success: false, error: "Activation failed");
      }

      // no errors, delete activation
      await _activationRepository.delete(activation.id);

      _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return ActivationResult(isArtist: isArtist, success: true);
    } on PlatformException catch (e) {
      return ActivationResult(
          isArtist: isArtist, success: false, error: e.message);
    } on Exception catch (e) {
      final msg = "An unknown exception occurred: ${e.toString()}";
      print(msg);
      return ActivationResult(isArtist: isArtist, success: false, error: msg);
    }
  }
}
