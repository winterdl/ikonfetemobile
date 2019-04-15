import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ikonfete/model/user.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/repository/fan_repository.dart';
import 'package:meta/meta.dart';

abstract class TPSignupEvent {}

class TPProfileEntered extends TPSignupEvent {
  final bool isArtist;
  final String uid;
  final String username;
  final File profilePicture;
  final String countryCode;
  final String countryName;

  TPProfileEntered({
    @required this.isArtist,
    @required this.uid,
    @required this.username,
    @required this.profilePicture,
    @required this.countryCode,
    @required this.countryName,
  });
}

class _TPProfileEntered extends TPSignupEvent {
  final bool isArtist;
  final String uid;
  final String username;
  final File profilePicture;
  final String countryCode;
  final String countryName;

  _TPProfileEntered({
    @required this.isArtist,
    @required this.uid,
    @required this.username,
    @required this.profilePicture,
    @required this.countryCode,
    @required this.countryName,
  });
}

class TPSignupState extends Equatable {
  final bool isLoading;

  TPSignupState({this.isLoading}) : super([isLoading]);

  factory TPSignupState.initial() {
    return TPSignupState(isLoading: false);
  }

  TPSignupState copyWith({bool isLoading}) {
    return TPSignupState(isLoading: isLoading ?? this.isLoading);
  }
}

class ThirdPartySignupProfileBloc extends Bloc<TPSignupEvent, TPSignupState> {
  final ArtistRepository artistRepository;
  final FanRepository fanRepository;

  ThirdPartySignupProfileBloc()
      : artistRepository = Registry().artistRepository(),
        fanRepository = Registry().fanRepository();

  @override
  TPSignupState get initialState => TPSignupState.initial();

  @override
  void onTransition(Transition<TPSignupEvent, TPSignupState> transition) {
    super.onTransition(transition);
    final event = transition.event;
    if (event is TPProfileEntered) {
      dispatch(
        _TPProfileEntered(
          isArtist: event.isArtist,
          uid: event.uid,
          username: event.username,
          profilePicture: event.profilePicture,
          countryCode: event.countryCode,
          countryName: event.countryName,
        ),
      );
    }
  }

  @override
  Stream<TPSignupState> mapEventToState(
      TPSignupState currentState, TPSignupEvent event) async* {
    if (event is TPProfileEntered) {
      yield currentState.copyWith(isLoading: true);
    }

    if (event is _TPProfileEntered) {
      _updateThirdPartyUser(event.isArtist, event.uid, event.username,
          event.profilePicture, event.countryCode, event.countryName);
    }
  }

  Future _updateThirdPartyUser(bool isArtist, String uid, String username,
      File profilePicture, String countryCode, String countryName) async {
    User user;
    if (isArtist) {
      user = await artistRepository.findByUID(uid);
    } else {
      user = await fanRepository.findByUID(uid);
    }
  }
}
