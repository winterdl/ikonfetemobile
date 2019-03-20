import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/exceptions.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/repository/fan_repository.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

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

//class _SearchQuery extends TeamSelectionEvent {
//  final String query;
//
//  _SearchQuery(this.query);
//}
//
//class TeamSelected extends TeamSelectionEvent {
//  final Artist artist;
//
//  TeamSelected(this.artist);
//}
//
//class AddFanToTeam extends TeamSelectionEvent {
//  final String teamId;
//  final String fanUid;
//
//  AddFanToTeam({@required this.teamId, @required this.fanUid});
//}
//
//class _AddFanToTeam extends TeamSelectionEvent {
//  final String teamId;
//  final String fanUid;
//
//  _AddFanToTeam({@required this.teamId, @required this.fanUid});
//}
//
//class ClearSelectedTeam extends TeamSelectionEvent {}

class TeamSelectionState {
  final bool isLoading;
  final Pair<bool, String> loadFanResult;
  final Fan fan;
  final List<Artist> artists;
  final bool isSearching;
  final Pair<bool, String> searchResult;
  final Artist selectedArtist;

  TeamSelectionState({
    @required this.isLoading,
    @required this.loadFanResult,
    @required this.fan,
    @required this.isSearching,
    @required this.searchResult,
    @required this.artists,
    @required this.selectedArtist,
  });

  factory TeamSelectionState.initial() {
    return TeamSelectionState(
      isLoading: false,
      loadFanResult: null,
      fan: null,
      artists: [],
      isSearching: false,
      searchResult: null,
      selectedArtist: null,
    );
  }

  TeamSelectionState copyWith({
    bool isLoading,
    Fan fan,
    List<Artist> artists,
    bool isSearching,
    Artist selectedArtist,
    Pair<bool, String> loadFanResult,
    Pair<bool, String> searchResult,
  }) {
    return TeamSelectionState(
      isLoading: isLoading ?? this.isLoading,
      fan: fan ?? this.fan,
      artists: artists ?? this.artists,
      isSearching: isSearching ?? this.isSearching,
      selectedArtist: selectedArtist ?? this.selectedArtist,
      loadFanResult: loadFanResult,
      searchResult: searchResult,
    );
  }

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is TeamSelectionState &&
      runtimeType == other.runtimeType &&
      isLoading == other.isLoading &&
      fan == other.fan &&
      artists == other.artists &&
      isSearching == other.isSearching &&
      selectedArtist == other.selectedArtist &&
      loadFanResult == other.loadFanResult &&
      searchResult == other.searchResult;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      artists.hashCode ^
      fan.hashCode ^
      isSearching.hashCode ^
      selectedArtist.hashCode ^
      loadFanResult.hashCode ^
      searchResult.hashCode;
}

class TeamSelectionBloc extends Bloc<TeamSelectionEvent, TeamSelectionState> {
  final FanRepository fanRepository;

  TeamSelectionBloc() : fanRepository = Registry().fanRepository();

  @override
  TeamSelectionState get initialState => TeamSelectionState.initial();

  @override
  void onTransition(
      Transition<TeamSelectionEvent, TeamSelectionState> transition) {
    super.onTransition(transition);
    final event = transition.event;

    if (event is LoadFan) {
      dispatch(_LoadFan(event.uid));
    }

    if (event is SearchEvent) {
      dispatch(_SearchEvent(event.query));
    }

//    if (event is SearchQuery) {
//      dispatch(_SearchQuery(event.query));
//    }
//
//    if (event is TeamSelected) {
////      dispatch(_LoadArtistForTeam(event.team));
//    }
//
//    if (event is AddFanToTeam) {
//      dispatch(_AddFanToTeam(teamId: event.teamId, fanUid: event.fanUid));
//    }
  }

  @override
  Stream<TeamSelectionEvent> transform(Stream<TeamSelectionEvent> events) {
    return (events as Observable<TeamSelectionEvent>)
        .debounce(Duration(milliseconds: 100));
  }

  // TODO: implement infinite scrolling list
  @override
  Stream<TeamSelectionState> mapEventToState(
      TeamSelectionState state, TeamSelectionEvent event) async* {
    if (event is LoadFan) {
      yield state.copyWith(isLoading: true);
    }

    if (event is SearchEvent) {
      yield state.copyWith(isSearching: true);
    }

    if (event is _LoadFan) {
      try {
        final fan = await _loadFan(event.uid);
        yield state.copyWith(
            isLoading: false, fan: fan, loadFanResult: Pair.from(true, null));
      } on AppException catch (e) {
        yield state.copyWith(
            isLoading: false, loadFanResult: Pair.from(false, e.message));
      }
    }

    if (event is _SearchEvent) {
      try {
        final artists = await _searchForArtist(event.query);
        yield state.copyWith(
          isLoading: false,
          isSearching: false,
          artists: artists,
          loadFanResult: Pair.from(true, null),
        );
      } on AppException catch (e) {
        yield state.copyWith(
            isLoading: false,
            isSearching: false,
            searchResult: Pair.from(false, e.message));
      }
    }

//    if (event is LoadFan || event is AddFanToTeam) {
//      yield state.copyWith(isLoading: true, hasError: false);
//    }
//
//    if (event is SearchQuery) {
//      yield state.copyWith(isSearching: true, hasError: false);
//    }

//    if (event is TeamSelected) {
//      yield state.copyWith(
//          selectedTeam: event.team, isLoading: true, hasError: false);
//    }

//    if (event is ClearSelectedTeam) {
//      yield TeamSelectionState.initial()
//          .copyWith(fan: state.fan, teams: state.teams);
//    }

//    try {
//      if (event is _LoadFan) {
//        final fan = await _loadFan(event.uid);
//        dispatch(SearchQuery(""));
//        yield state.copyWith(isLoading: false, fan: fan, hasError: false);
//      }
//
//      if (event is _SearchQuery) {
//        final teams = await _searchArtistTeams(event.query);
//        yield state.copyWith(isSearching: false, teams: teams, hasError: false);
//      }
//
//      if (event is _LoadArtistForTeam) {
//        final artist = await _loadArtistForTeam(event.team);
//        yield state.copyWith(
//            selectedArtist: artist.second,
//            isLoading: false,
//            hasError: false,
//            showArtistModal: true);
//      }
//
//      if (event is _AddFanToTeam) {
//        final fan = state.fan;
//        final result = await _addFanToTeam(event.teamId, event.fanUid);
//        fan.currentTeamId = event.teamId;
//        final newState =
//        TeamSelectionState.initial().copyWith(fan: fan, teams: state.teams);
//        if (!result) {
//          yield newState.copyWith(
//            teamSelectionResult: false,
//            isLoading: false,
//            hasError: true,
//            showArtistModal: false,
//            errorMessage: "Failed to join team",
//          );
//        } else {
//          yield newState.copyWith(
//            isLoading: false,
//            teamSelectionResult: true,
//            hasError: false,
//            showArtistModal: false,
//          );
//        }
//      }
//    } on ApiException catch (e) {
//      yield state.withError(e.message);
//    }
  }

  Future<Fan> _loadFan(String uid) async {
    try {
      final fan = await fanRepository.findByUID(uid);
      if (fan == null) {
        throw AppException("Fan not found");
      }
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
    return [];
  }

//  Future<List<Team>> _searchArtistTeams(String query) async {
//    final teamApi = TeamApi(appConfig.serverBaseUrl);
//    List<Team> teams;
//    if (query.trim().isEmpty) {
//      teams = await teamApi.getTeams(1, 20);
//    } else {
//      teams = await teamApi.searchTeams(query, 1, 20);
//    }
//    return teams;
//  }
//
//  Future<Pair<Team, Artist>> _loadArtistForTeam(Team team) async {
//    final artistApi = ArtistApi(appConfig.serverBaseUrl);
//    final artist = await artistApi.findByUID(team.artistUid);
//    return Pair.from(team, artist);
//  }
//
//  Future<bool> _addFanToTeam(String teamId, String fanUid) async {
//    final teamApi = TeamApi(appConfig.serverBaseUrl);
//    final success = await teamApi.addFanToTeam(teamId, fanUid);
//    return success;
//  }
}
