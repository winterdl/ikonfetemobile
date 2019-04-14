import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ikonfete/preferences.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/auth_repository.dart';
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

class LoadCurrentUser extends AppEvent {}

class Signout extends AppEvent {}

class AppState extends Equatable {
  final bool isOnBoarded;
  final bool isLoggedIn;
  final bool isArtist;
  final CurrentUserHolder currentUser;

  AppState({
    this.isOnBoarded,
    this.isLoggedIn,
    this.isArtist,
    this.currentUser,
  }) : super([isOnBoarded, isLoggedIn, isArtist, currentUser]);

  factory AppState.initial(
      SharedPreferences preferences, CurrentUserHolder currentUser) {
    // get shared prefs
    final isArtist = preferences.getBool(PreferenceKeys.isArtist) ?? false;
    final isOnBoarded =
        preferences.getBool(PreferenceKeys.isOnBoarded) ?? false;
    final isLoggedIn = preferences.getBool(PreferenceKeys.isLoggedIn) ?? false;

    return AppState(
      isOnBoarded: isOnBoarded,
      isLoggedIn: isLoggedIn,
      isArtist: isArtist,
      currentUser: currentUser,
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
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

class AppBloc extends Bloc<AppEvent, AppState> {
  final SharedPreferences preferences;
  final CurrentUserHolder initialCurrentUser;
  final EmailAuth emailAuthRepo;

  AppBloc({@required this.preferences, @required this.initialCurrentUser})
      : emailAuthRepo = Registry().emailAuthRepository();

  @override
  AppState get initialState =>
      AppState.initial(preferences, initialCurrentUser);

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

    if (event is LoadCurrentUser) {
      print("LOADING CURRENT USER...");
      final user = await emailAuthRepo.getCurrentUser();
      print("LOADED CURRENT USER...");
      yield currentState.copyWith(currentUser: user);
    }

    if (event is Signout) {
      await emailAuthRepo.signOut();
      yield state.copyWith(isLoggedIn: false);
    }
  }
}
