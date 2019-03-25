import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/repository/fan_repository.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';

abstract class TeamScreenEvent {}

class LoadArtist extends TeamScreenEvent {}

class LoadTeam extends TeamScreenEvent {}

class TeamSearch extends TeamScreenEvent {
  final String query;

  TeamSearch(this.query);
}

class TeamScreenState extends Equatable {
  final bool isLoading;
  final Artist artist;
  final List<Fan> teamMembers;
  final Pair<bool, String> loadArtistResult;

  TeamScreenState(
      {this.isLoading, this.artist, this.teamMembers, this.loadArtistResult})
      : super([isLoading, artist, teamMembers, loadArtistResult]);

  factory TeamScreenState.initial() => TeamScreenState(
        isLoading: true,
        artist: null,
        teamMembers: null,
        loadArtistResult: null,
      );

  TeamScreenState copyWith({
    bool isLoading,
    Artist artist,
    List<Fan> teamMembers,
    Pair<bool, String> loadArtistResult,
  }) {
    return TeamScreenState(
      isLoading: isLoading ?? this.isLoading,
      artist: artist ?? this.artist,
      teamMembers: teamMembers ?? this.teamMembers,
      loadArtistResult: loadArtistResult,
    );
  }
}

class TeamScreenBloc extends Bloc<TeamScreenEvent, TeamScreenState> {
  final String uid;
  final ArtistRepository _artistRepository;
  final FanRepository _fanRepository;

  TeamScreenBloc({@required this.uid})
      : _artistRepository = Registry().artistRepository(),
        _fanRepository = Registry().fanRepository();

  @override
  TeamScreenState get initialState => TeamScreenState.initial();

  @override
  Stream<TeamScreenState> mapEventToState(
      TeamScreenState currentState, TeamScreenEvent event) async* {
    if (event is LoadArtist) {
      try {
        final artist = await _artistRepository.findByUID(uid);
        if (artist == null) {
          throw PlatformException(message: "Artist not found", code: "");
        }

        yield currentState.copyWith(
            isLoading: false,
            artist: artist,
            loadArtistResult: Pair.from(true, null));
        dispatch(LoadTeam());
      } on PlatformException catch (e) {
        print("Failed to load artist $uid. ${e.message}");
        yield currentState.copyWith(
            isLoading: false, loadArtistResult: Pair.from(false, e.message));
      } on Exception catch (e) {
        print("Failed to load artist $uid. ${e.toString()}");
        yield currentState.copyWith(
            isLoading: false, loadArtistResult: Pair.from(false, e.toString()));
      }
    }

    if (event is LoadTeam) {}
  }
}
