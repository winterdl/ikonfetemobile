import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:ikonfete/model/settings.dart';
import 'package:ikonfete/registry.dart';
import 'package:ikonfete/repository/settings_repository.dart';
import 'package:ikonfete/utils/types.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsScreenEvent {}

class LoadSettings extends SettingsScreenEvent {
  LoadSettings();
}

class _LoadSettings extends SettingsScreenEvent {
  _LoadSettings();
}

class EnableDeezerEvent extends SettingsScreenEvent {
  final bool enable;

  EnableDeezerEvent(this.enable);
}

class EnableNotificationsEvent extends SettingsScreenEvent {
  final bool enable;

  EnableNotificationsEvent(this.enable);
}

class SaveSettings extends SettingsScreenEvent {}

class _SaveSettings extends SettingsScreenEvent {}

class SettingsState extends Equatable {
  final bool isLoading;
  final Settings settings;
  final Pair<bool, String> loadSettingsResult;
  final bool enableNotifications;
  final String deezerUid;
  final Pair<bool, String> saveSettingsResult;

  SettingsState({
    @required this.isLoading,
    @required this.settings,
    @required this.loadSettingsResult,
    @required this.enableNotifications,
    @required this.deezerUid,
    @required this.saveSettingsResult,
  }) : super([
          isLoading,
          settings,
          loadSettingsResult,
          enableNotifications,
          deezerUid,
          saveSettingsResult
        ]);

  factory SettingsState.initial() {
    return SettingsState(
      isLoading: false,
      settings: null,
      loadSettingsResult: null,
      enableNotifications: null,
      deezerUid: null,
      saveSettingsResult: null,
    );
  }

  SettingsState copyWith({
    bool isLoading,
    Settings settings,
    Pair<bool, String> loadSettingsResult,
    bool enableNotifications,
    String deezerUid,
    Pair<bool, String> saveSettingsResult,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
      loadSettingsResult: loadSettingsResult,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      deezerUid: deezerUid ?? this.deezerUid,
      saveSettingsResult: saveSettingsResult,
    );
  }

  bool get changesMade =>
      ((settings == null) &&
          (enableNotifications != null || deezerUid != null)) ||
      (settings != null &&
          (enableNotifications != settings.enableNotifications ||
              deezerUid != settings.deezerUserId));

//  @override
//  bool operator ==(other) =>
//      identical(this, other) &&
//      other is SettingsState &&
//      runtimeType == other.runtimeType &&
//      settings == other.settings &&
//      isLoading == other.isLoading &&
//      loadSettingsResult == other.loadSettingsResult &&
//      enableNotifications == other.enableNotifications &&
//      deezerUid == other.deezerUid &&
//      saveSettingsResult == other.saveSettingsResult;
//
//  @override
//  int get hashCode =>
//      isLoading.hashCode ^
//      settings.hashCode ^
//      loadSettingsResult.hashCode ^
//      enableNotifications.hashCode ^
//      deezerUid.hashCode ^
//      saveSettingsResult.hashCode;
}

class SettingsBloc extends Bloc<SettingsScreenEvent, SettingsState> {
  final SettingsRepository _settingsRepository;
  final String uid;

  SettingsBloc({this.uid})
      : _settingsRepository = Registry().settingsRepository();

  @override
  SettingsState get initialState => SettingsState.initial();

  @override
  void onTransition(Transition<SettingsScreenEvent, SettingsState> transition) {
    final event = transition.event;
    if (event is LoadSettings) {
      dispatch(_LoadSettings());
    }

    if (event is SaveSettings) {
      dispatch(_SaveSettings());
    }
  }

  @override
  Stream<SettingsState> mapEventToState(
      SettingsState state, SettingsScreenEvent event) async* {
    if (event is LoadSettings || event is SaveSettings) {
      yield state.copyWith(isLoading: true);
    }

    if (event is _LoadSettings) {
      try {
        final settings = await _settingsRepository.findByUid(uid);
        yield state.copyWith(
          isLoading: false,
          settings: settings,
          loadSettingsResult: Pair.from(true, null),
        );
      } on PlatformException catch (e) {
        yield state.copyWith(
          isLoading: false,
          loadSettingsResult: Pair.from(false, e.message),
        );
      } on Exception catch (e) {
        yield state.copyWith(
          isLoading: false,
          loadSettingsResult: Pair.from(false, e.toString()),
        );
      }
//      final settings = (await loadSettings(event.uid)) ?? Settings.empty();
//      yield state.copyWith(
//          isLoading: false, hasError: false, settings: settings);
    }

    if (event is EnableDeezerEvent) {
//        final deezerApi = DeezerApi();
//        bool success = await deezerApi.authenticate();
//        if (success) {
//          final deezerUser = await deezerApi.getCurrentUser();
//          final Settings settings = state.settings;
//          settings.deezerUserId = "${deezerUser.id}";
//          yield state.copyWith(
//              hasError: false, isLoading: false, settings: settings);
//        }
    }

    if (event is EnableNotificationsEvent) {
      yield state.copyWith(isLoading: false, enableNotifications: event.enable);
    }

    if (event is _SaveSettings) {
      try {
        Settings settings = Settings()
          ..uid = uid
          ..deezerUserId = state.deezerUid
          ..spotifyUserId = null
          ..appleMusicUserId = null
          ..enableNotifications = state.enableNotifications ?? false;
        if (state.settings == null) {
          settings = await _settingsRepository.create(settings);
        } else {
          await _settingsRepository.update(settings.id, settings);
        }

        yield state.copyWith(
          isLoading: false,
          saveSettingsResult: Pair.from(true, null),
          enableNotifications: state.enableNotifications,
          deezerUid: state.deezerUid,
          settings: state.settings,
        );
      } on PlatformException catch (e) {
        yield state.copyWith(
          isLoading: false,
          saveSettingsResult: Pair.from(false, e.message),
          enableNotifications: state.enableNotifications,
          deezerUid: state.deezerUid,
          settings: state.settings,
        );
      } on Exception catch (e) {
        yield state.copyWith(
          isLoading: false,
          saveSettingsResult: Pair.from(false, e.toString()),
          enableNotifications: state.enableNotifications,
          deezerUid: state.deezerUid,
          settings: state.settings,
        );
      }
    }
  }
}