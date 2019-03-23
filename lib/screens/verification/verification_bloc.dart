import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:ikonfete/app_config.dart';
import 'package:ikonfete/model/pending_verification.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/repository/pending_verification_repository.dart';
import 'package:ikonfete/utils/facebook_auth.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/utils/twitter_auth.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';

abstract class VerificationScreenEvent {}

class AddFacebook extends VerificationScreenEvent {}

class AddTwitter extends VerificationScreenEvent {}

class AddBio extends VerificationScreenEvent {
  final String bio;

  AddBio(this.bio);
}

class SubmitVerification extends VerificationScreenEvent {
  final String uid;

  SubmitVerification(this.uid);
}

class _SubmitVerification extends VerificationScreenEvent {
  final String uid;

  _SubmitVerification(this.uid);
}

class VerificationScreenState {
  final bool isLoading;
  final String facebookId;
  final String twitterId;
  final String twitterUsername;
  final String bio;
  final Pair<bool, String> addFacebookResult;
  final Pair<bool, String> addTwitterResult;
  final Pair<bool, String> verificationResult;

  VerificationScreenState({
    @required this.isLoading,
    @required this.facebookId,
    @required this.twitterId,
    @required this.twitterUsername,
    @required this.bio,
    @required this.addFacebookResult,
    @required this.addTwitterResult,
    @required this.verificationResult,
  });

  bool get canSubmit =>
      !StringUtils.isNullOrEmpty(facebookId) &&
      !StringUtils.isNullOrEmpty(twitterId) &&
      !StringUtils.isNullOrEmpty(bio);

  factory VerificationScreenState.initial() {
    return VerificationScreenState(
      isLoading: false,
      facebookId: null,
      twitterId: null,
      twitterUsername: null,
      bio: null,
      addFacebookResult: null,
      addTwitterResult: null,
      verificationResult: null,
    );
  }

  VerificationScreenState copyWith({
    bool isLoading,
    String facebookId,
    String twitterId,
    String twitterUsername,
    String bio,
    Pair<bool, String> addFacebookResult,
    Pair<bool, String> addTwitterResult,
    Pair<bool, String> verificationResult,
  }) {
    return VerificationScreenState(
      isLoading: isLoading ?? this.isLoading,
      facebookId: facebookId ?? this.facebookId,
      twitterId: twitterId ?? this.twitterId,
      twitterUsername: twitterUsername ?? this.twitterUsername,
      bio: bio ?? this.bio,
      addFacebookResult: addFacebookResult,
      addTwitterResult: addTwitterResult,
      verificationResult: verificationResult,
    );
  }

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is VerificationScreenState &&
      runtimeType == other.runtimeType &&
      isLoading == other.isLoading &&
      facebookId == other.facebookId &&
      twitterId == other.twitterId &&
      twitterUsername == other.twitterUsername &&
      bio == other.bio &&
      addFacebookResult == other.addFacebookResult &&
      addTwitterResult == other.addTwitterResult &&
      verificationResult == other.verificationResult;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      facebookId.hashCode ^
      twitterId.hashCode ^
      twitterUsername.hashCode ^
      bio.hashCode ^
      addFacebookResult.hashCode ^
      addTwitterResult.hashCode ^
      verificationResult.hashCode;
}

class VerificationBloc
    extends Bloc<VerificationScreenEvent, VerificationScreenState> {
  final AppConfig appConfig;
  final PendingVerificationRepository _pendingVerificationRepository;
  final ArtistRepository _artistRepository;

  VerificationBloc({@required this.appConfig})
      : _pendingVerificationRepository =
            Registry().pendingVerificationRepository(),
        _artistRepository = Registry().artistRepository();

  @override
  VerificationScreenState get initialState => VerificationScreenState.initial();

  @override
  void onTransition(
      Transition<VerificationScreenEvent, VerificationScreenState> transition) {
    super.onTransition(transition);
    final event = transition.event;
    if (event is SubmitVerification) {
      dispatch(_SubmitVerification(event.uid));
    }
  }

  @override
  Stream<VerificationScreenState> mapEventToState(
      VerificationScreenState currentState,
      VerificationScreenEvent event) async* {
    if (event is SubmitVerification) {
      yield currentState.copyWith(
        isLoading: true,
        addTwitterResult: currentState.addTwitterResult,
        addFacebookResult: currentState.addFacebookResult,
      );
    }

    if (event is AddFacebook) {
      try {
        final facebookResult = await _addFacebook();
        if (facebookResult.success) {
          yield currentState.copyWith(
              isLoading: false,
              addFacebookResult: Pair.from(true, null),
              facebookId: facebookResult.facebookUID);
        } else {
          yield currentState.copyWith(
              isLoading: false,
              addFacebookResult: Pair.from(false, facebookResult.errorMessage));
        }
      } on Exception catch (e) {
        yield currentState.copyWith(
            isLoading: false,
            addFacebookResult: Pair.from(false, e.toString()));
      }
    }

    if (event is AddTwitter) {
      try {
        final twitterResult = await _addTwitter();
        if (twitterResult.success) {
          yield currentState.copyWith(
              isLoading: false,
              twitterId: twitterResult.twitterUID,
              twitterUsername: twitterResult.twitterUsername,
              addTwitterResult: Pair.from(true, null));
        } else {
          yield currentState.copyWith(
              isLoading: false,
              addTwitterResult: Pair.from(false, twitterResult.errorMessage));
        }
      } on Exception catch (e) {
        yield currentState.copyWith(
            isLoading: false, addTwitterResult: Pair.from(false, e.toString()));
      }
    }

    if (event is AddBio) {
      yield currentState.copyWith(isLoading: false, bio: event.bio);
    }

    if (event is _SubmitVerification) {
      if (!currentState.canSubmit) {
        final errMsg = StringUtils.isNullOrEmpty(currentState.facebookId)
            ? "Please Setup your Facebook Account"
            : (StringUtils.isNullOrEmpty(currentState.twitterId)
                ? "Please setup your twitter account"
                : "Please enter your bio");
        yield currentState.copyWith(
            isLoading: false, verificationResult: Pair.from(false, errMsg));
      }

      final result = await _submitPendingVerification(
        uid: event.uid,
        bio: currentState.bio,
        facebookId: currentState.facebookId,
        twitterId: currentState.twitterId,
        twitterUsername: currentState.twitterUsername,
      );
      yield currentState.copyWith(isLoading: false, verificationResult: result);
    }
  }

  Future<FacebookAuthResult> _addFacebook() async {
    final fbAuth = FacebookAuth();
    final fbResult = await fbAuth.facebookAuth(
        loginBehaviour: FacebookLoginBehavior.nativeWithFallback);
    return fbResult;
  }

  Future<TwitterAuthResult> _addTwitter() async {
    final twitterAuth = TwitterAuth(
      consumerKey: appConfig.twitterConfig.consumerKey,
      consumerSecret: appConfig.twitterConfig.consumerSecret,
    );
    final tResult = await twitterAuth.twitterAuth();
    return tResult;
  }

  Future<Pair<bool, String>> _submitPendingVerification(
      {String uid,
      String bio,
      String facebookId,
      String twitterId,
      String twitterUsername}) async {
    try {
      final pendingVerification = PendingVerification()
        ..uid = uid
        ..bio = bio
        ..facebookId = facebookId
        ..twitterId = twitterId
        ..twitterUsername = twitterUsername;
      await _pendingVerificationRepository.create(pendingVerification);
      final artist = await _artistRepository.findByUID(uid);
      artist.isPendingVerification = true;
      artist.isVerified = true;
      await _artistRepository.update(artist.id, artist);

      return Pair.from(true, null);
    } on PlatformException catch (e) {
      return Pair.from(false, e.message);
    } on Exception catch (e) {
      return Pair.from(false, e.toString());
    }
  }
}
