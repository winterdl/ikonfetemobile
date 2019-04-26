import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/exceptions.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/repository/artist_repository.dart';
import 'package:ikonfete/repository/fan_repository.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';

abstract class TeamSelectionEvent {}

class LoadFan extends TeamSelectionEvent {
  final String uid;

  LoadFan(this.uid);
}

class _LoadFan extends TeamSelectionEvent {
  final String uid;

  _LoadFan(this.uid);
}

class SearchEvent extends TeamSelectionEvent {
  final String query;

  SearchEvent(this.query);
}

class _SearchEvent extends TeamSelectionEvent {
  final String query;

  _SearchEvent(this.query);
}

class JoinTeam extends TeamSelectionEvent {
  final String artistUid;
  final String fanUid;

  JoinTeam({@required this.artistUid, @required this.fanUid});
}

class _JoinTeam extends TeamSelectionEvent {
  final String artistUid;
  final String fanUid;

  _JoinTeam({@required this.artistUid, @required this.fanUid});
}

class TeamSelectionState extends Equatable {
  final bool isLoading;
  final Pair<bool, String> loadFanResult;
  final Fan fan;
  final List<Artist> artists;
  final bool isSearching;
  final Pair<bool, String> searchResult;
  final Pair<bool, String> teamSelectionResult;

  TeamSelectionState({
    @required this.isLoading,
    @required this.loadFanResult,
    @required this.fan,
    @required this.isSearching,
    @required this.searchResult,
    @required this.artists,
    @required this.teamSelectionResult,
  }) : super([
          isLoading,
          loadFanResult,
          fan,
          isSearching,
          searchResult,
          artists,
          teamSelectionResult
        ]);

  factory TeamSelectionState.initial() {
    return TeamSelectionState(
      isLoading: false,
      loadFanResult: null,
      fan: null,
      artists: [],
      isSearching: false,
      searchResult: null,
      teamSelectionResult: null,
    );
  }

  TeamSelectionState copyWith(
      {bool isLoading,
      Fan fan,
      List<Artist> artists,
      bool isSearching,
      Pair<bool, String> loadFanResult,
      Pair<bool, String> searchResult,
      Pair<bool, String> teamSelectionResult}) {
    return TeamSelectionState(
      isLoading: isLoading ?? this.isLoading,
      fan: fan ?? this.fan,
      artists: artists ?? this.artists,
      isSearching: isSearching ?? this.isSearching,
      loadFanResult: loadFanResult ?? null,
      searchResult: searchResult ?? null,
      teamSelectionResult: teamSelectionResult ?? null,
    );
  }
}

class TeamSelectionBloc extends Bloc<TeamSelectionEvent, TeamSelectionState> {
  final FanRepository fanRepository;
  final ArtistRepository artistRepository;

  TeamSelectionBloc()
      : fanRepository = Registry().fanRepository(),
        artistRepository = Registry().artistRepository();

  @override
  TeamSelectionState get initialState {
    print("Calling initialState");
    return TeamSelectionState.initial();
  }

  @override
  void onTransition(
      Transition<TeamSelectionEvent, TeamSelectionState> transition) {
    super.onTransition(transition);
    final event = transition.event;

    if (event is LoadFan) {
      dispatch(_LoadFan(event.uid));
    }

    if (event is JoinTeam) {
      dispatch(_JoinTeam(artistUid: event.artistUid, fanUid: event.fanUid));
    }
  }

  // TODO: implement infinite scrolling list
  @override
  Stream<TeamSelectionState> mapEventToState(
      TeamSelectionState state, TeamSelectionEvent event) async* {
    if (event is LoadFan || event is JoinTeam) {
      yield state.copyWith(
          isLoading: true, loadFanResult: state.teamSelectionResult);
    }

    if (event is _LoadFan) {
      try {
        print("Loading fan...");
        final fan = await _loadFan(event.uid);
        print("Loaded fan");
        yield state.copyWith(
            isLoading: false, fan: fan, loadFanResult: Pair.from(true, null));
        // search
        final artists = await _searchForArtist("");
        yield state.copyWith(isLoading: false, fan: fan, artists: artists);
      } on AppException catch (e) {
        yield state.copyWith(
            isLoading: false, loadFanResult: Pair.from(false, e.message));
      }
    }

    if (event is SearchEvent) {
      try {
        final artists = await _searchForArtist(event.query);
        yield state.copyWith(
          isLoading: false,
          isSearching: false,
          artists: artists,
          searchResult: Pair.from(true, null),
        );
      } on AppException catch (e) {
        yield state.copyWith(
            isLoading: false,
            isSearching: false,
            searchResult: Pair.from(false, e.message));
      }
    }

    if (event is _JoinTeam) {
      final result = await _addFanToArtistTeam(
          artistUid: event.artistUid, fanUid: event.fanUid);
      yield state.copyWith(
          isLoading: false, isSearching: false, teamSelectionResult: result);
    }
  }

  Future<Fan> _loadFan(String uid) async {
    try {
      final fan = await fanRepository.findByUID(uid);
      if (fan == null) {
        throw AppException("Fan not found");
      }
      dispatch(SearchEvent(""));
      return fan;
    } on PlatformException catch (e) {
      print("Failed to load fan $uid. ${e.message}");
      throw AppException("Failed to load fan");
    } on Exception catch (e) {
      print("Failed to load fan $uid. ${e.toString()}");
      throw AppException("An unknown error occurred");
    }
  }

  Future<List<Artist>> _searchForArtist(String query) async {
    final artists = await artistRepository.searchByNameOrUsername(query);
    return artists;
  }

  Future<Pair<bool, String>> _addFanToArtistTeam(
      {@required String artistUid, @required String fanUid}) async {
    try {
      final fan = await fanRepository.findByUID(fanUid);
      if (fan == null) {
        return Pair.from(false, "Fan does not exist");
      }
      final artist = await artistRepository.findByUID(artistUid);
      if (artist == null) {
        return Pair.from(false, "Artist does not exist");
      }

      bool added = await artistRepository.addTeamMember(artist.id, fan.id);

      return Pair.from(added, added ? null : "Failed to join team");
    } on PlatformException catch (e) {
      print("Failed to add fan to artist team: ${e.message}");
      return Pair.from(false, e.message);
    } on Exception catch (e) {
      print("Failed to add fan to artist team: ${e.toString()}");
      return Pair.from(false, e.toString());
    }
  }
}
