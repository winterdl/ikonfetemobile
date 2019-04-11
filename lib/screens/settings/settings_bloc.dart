import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:ikonfete/deezer/deezer_api.dart';
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
  final Pair<bool, String> enableDeezerResult;
  final Pair<bool, String> saveSettingsResult;

  bool get deezerEnabled =>
      (deezerUid != null && deezerUid.trim().isNotEmpty) ||
      (settings != null &&
          settings.deezerUserId != null &&
          settings.deezerUserId.isNotEmpty);

  SettingsState({
    @required this.isLoading,
    @required this.settings,
    @required this.loadSettingsResult,
    @required this.enableNotifications,
    @required this.deezerUid,
    @required this.saveSettingsResult,
    @required this.enableDeezerResult,
  }) : super([
          isLoading,
          settings,
          loadSettingsResult,
          enableNotifications,
          deezerUid,
          saveSettingsResult,
          enableDeezerResult
        ]);

  factory SettingsState.initial() {
    return SettingsState(
      isLoading: false,
      settings: null,
      loadSettingsResult: null,
      enableNotifications: null,
      deezerUid: null,
      saveSettingsResult: null,
      enableDeezerResult: null,
    );
  }

  SettingsState copyWith({
    bool isLoading,
    Settings settings,
    Pair<bool, String> loadSettingsResult,
    bool enableNotifications,
    String deezerUid,
    Pair<bool, String> saveSettingsResult,
    Pair<bool, String> enableDeezerResult,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
      loadSettingsResult: loadSettingsResult,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      deezerUid: deezerUid ?? this.deezerUid,
      saveSettingsResult: saveSettingsResult ?? null,
      enableDeezerResult: enableDeezerResult ?? null,
    );
  }

  bool get changesMade =>
      ((settings == null) &&
          (enableNotifications != null || deezerUid != null)) ||
      (settings != null &&
          (enableNotifications != settings.enableNotifications ||
              deezerUid != settings.deezerUserId));
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
    }

    if (event is EnableDeezerEvent) {
      if (event.enable) {
        try {
          final deezerApi = DeezerApi();
          DeezerSession deezerSession;
          if ((await deezerApi.isSessionValid())) {
            deezerSession = await deezerApi.getCurrentSession();
          } else {
            deezerSession = await deezerApi.authenticate();
          }

          if (deezerSession.success) {
            yield state.copyWith(
                isLoading: false,
                deezerUid: deezerSession.userId,
                enableDeezerResult: Pair.from(true, null));
          } else {
            yield state.copyWith(
                isLoading: false,
                enableDeezerResult:
                    Pair.from(false, "Failed to enable deezer"));
          }
        } on PlatformException catch (e) {
          print("Failed to enable Deezer. ${e.message}");
          yield state.copyWith(
              isLoading: false,
              deezerUid: "",
              enableDeezerResult: Pair.from(false, "Failed to enable Deezer"));
        }
      } else {
        yield state.copyWith(isLoading: false, deezerUid: "");
      }
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
