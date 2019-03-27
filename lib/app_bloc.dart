import 'package:bloc/bloc.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/preferences.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppEvent {}

class OnBoardDone extends AppEvent {
  final bool isArtist;

  OnBoardDone({@required this.isArtist});
}

class SwitchMode extends AppEvent {
  final bool isArtist;

  SwitchMode({@required this.isArtist});
}

class Signout extends AppEvent {}

class AppState {
  final bool isOnBoarded;
  final bool isLoggedIn;
  final bool isArtist;

  AppState({
    this.isOnBoarded,
    this.isLoggedIn,
    this.isArtist,
  });

  factory AppState.initial(
      SharedPreferences preferences, ExclusivePair<Artist, Fan> artistOrFan) {
    // get shared prefs
    final isArtist = preferences.getBool(PreferenceKeys.isArtist) ?? false;
    final isOnBoarded =
        preferences.getBool(PreferenceKeys.isOnBoarded) ?? false;
    final isLoggedIn = preferences.getBool(PreferenceKeys.isLoggedIn) ?? false;

    return AppState(
      isOnBoarded: isOnBoarded,
      isLoggedIn: isLoggedIn,
      isArtist: isArtist,
    );
  }

  AppState copyWith({
    bool isOnBoarded,
    bool isLoggedIn,
    bool isArtist,
    CurrentUserHolder currentUser,
  }) {
    return AppState(
      isOnBoarded: isOnBoarded ?? this.isOnBoarded,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isArtist: isArtist ?? this.isArtist,
    );
  }

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is AppState &&
      runtimeType == other.runtimeType &&
      isOnBoarded == other.isOnBoarded &&
      isLoggedIn == other.isLoggedIn &&
      isArtist == other.isArtist;

  @override
  int get hashCode =>
      isOnBoarded.hashCode ^ isLoggedIn.hashCode ^ isArtist.hashCode;
}

class AppBloc extends Bloc<AppEvent, AppState> {
  final SharedPreferences preferences;
  final ExclusivePair<Artist, Fan> initialCurrentArtistOrFan;
  final EmailAuth emailAuthRepo;

  AppBloc(
      {@required this.preferences, @required this.initialCurrentArtistOrFan})
      : emailAuthRepo = Registry().emailAuthRepository();

  @override
  AppState get initialState =>
      AppState.initial(preferences, initialCurrentArtistOrFan);

  @override
  Stream<AppState> mapEventToState(AppState state, AppEvent event) async* {
    if (event is OnBoardDone) {
      bool isArtist = event.isArtist;
      preferences.setBool(PreferenceKeys.isOnBoarded, true);
      preferences.setBool(PreferenceKeys.isArtist, isArtist);
      yield state.copyWith(isOnBoarded: true, isArtist: isArtist);
    }

    if (event is SwitchMode) {
      bool isArtist = event.isArtist;
      preferences.setBool(PreferenceKeys.isArtist, isArtist);
      yield state.copyWith(isArtist: isArtist);
    }

    if (event is Signout) {
      await emailAuthRepo.signOut();
      yield state.copyWith(isLoggedIn: false);
    }
  }
}
