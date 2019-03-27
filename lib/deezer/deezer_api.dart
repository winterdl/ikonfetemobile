import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'deezer_models.dart';

class DeezerSession {
  final bool success;
  final String accessToken;
  final String userId;
  final DateTime expires;

  DeezerSession({
    @required this.success,
    this.accessToken,
    this.userId,
    this.expires,
  });

  factory DeezerSession.fromMap(Map<dynamic, dynamic> map) {
    return DeezerSession(
      success: map["success"],
      accessToken: map["accessToken"] ?? null,
      userId: map["userId"] ?? null,
      expires: map["expires"] != null
          ? DateTime.fromMillisecondsSinceEpoch(map["expires"])
          : null,
    );
  }
}

class DeezerApi {
  static final DeezerApi _singleton = new DeezerApi._internal();

  final deezerMethodChannel = "ikonfete_deezer_method_channel";
  final deezerPlayerEventChannel = "ikonfete_deezer_player_event_channel";
  final deezerPlayerBufferEventChannel =
      "ikonfete_deezer_player_buffer_event_channel";

  MethodChannel _methodChannel;
  EventChannel _playerEventChannel;
  EventChannel _playerBufferEventChannel;

  StreamController<DeezerPlayerEvent> _playerEventStreamController;
  StreamController<DeezerBufferEvent> _playerBufferEventStreamController;

  factory DeezerApi() {
    return _singleton;
  }

  DeezerApi._internal() {
    _methodChannel = new MethodChannel(deezerMethodChannel);
    _playerEventChannel = new EventChannel(deezerPlayerEventChannel);
    _playerBufferEventChannel =
        new EventChannel(deezerPlayerBufferEventChannel);

    _playerEventStreamController = StreamController.broadcast();
    _playerBufferEventStreamController = StreamController.broadcast();
  }

  Stream<DeezerPlayerEvent> get playerEventStream =>
      _playerEventStreamController.stream;

  Stream<DeezerBufferEvent> get playerBufferEventStream =>
      _playerBufferEventStreamController.stream;

  // IOS ready, Android Ready
  Future<DeezerSession> authenticate() async {
    Map result = await _methodChannel.invokeMethod("authorize");
    final dzrResult = DeezerSession.fromMap(result);
    return dzrResult;
  }

  // IOS ready, Android Ready
  Future<bool> isSessionValid() async {
    try {
      bool isValid = await _methodChannel.invokeMethod("isSessionValid");
      return isValid;
    } on PlatformException catch (e) {
      throw e;
    }
  }

  // IOS ready, Android Ready
  Future<DeezerSession> getCurrentSession() async {
    Map result = await _methodChannel.invokeMethod("getCurrentSession");
    final dzrResult = DeezerSession.fromMap(result);
    return dzrResult;
  }

  // todo
  Future logout() async {
    try {
      await _methodChannel.invokeMethod("logout");
    } on PlatformException catch (e) {
      return;
    }
  }

  // todo
  Future<DeezerUser> getCurrentUser() async {
    try {
      Map userData = await _methodChannel.invokeMethod("getCurrentUser");
      DeezerUser user = new DeezerUser.fromMap(userData);
      return user;
    } on PlatformException catch (e) {
      throw e;
    }
  }

  // todo
  Future<DeezerTrack> getTrack(int trackId) async {
    try {
      Map trackData =
          await _methodChannel.invokeMethod("getTrack", {"trackId": trackId});
      DeezerTrack track = new DeezerTrack.fromMap(trackData);
      return track;
    } on PlatformException catch (e) {
      throw e;
    }
  }

  // todo
  Future<bool> initializeTrackPlayer() async {
    try {
      bool success = await _methodChannel.invokeMethod("initializeTrackPlayer");
      _playerEventChannel.receiveBroadcastStream().listen((dynamic data) {
        Map map = data as Map;
        final event = DeezerPlayerEvent.fromMap(map);
        _playerEventStreamController.add(event);
      }).onError((err) {
        // TODO: handle playback error
      });

      _playerBufferEventChannel.receiveBroadcastStream().listen((dynamic data) {
        Map map = data as Map;
        final event = DeezerBufferEvent.fromMap(map);
        _playerBufferEventStreamController.add(event);
      }).onError((err) {
        // TODO: handle event
      });
      return success;
    } on PlatformException catch (e) {
      if (e.code == "deezer_invalid_session") return false;
      throw e;
    }
  }

  // todo
  Future closePlayer() async {
    try {
      await _methodChannel.invokeMethod("closePlayer");
    } on PlatformException {}
  }

  // todo
  Future playTrack(int trackId) async {
    try {
      await _methodChannel.invokeMethod("playTrack", {"trackId": trackId});
    } on PlatformException {}
  }

  Future pause() async {
    try {
      await _methodChannel.invokeMethod("pause");
    } on PlatformException {}
  }

  // todo
  Future resume() async {
    try {
      await _methodChannel.invokeMethod("resume");
    } on PlatformException {}
  }

  // todo
  Future stop() async {
    try {
      await _methodChannel.invokeMethod("stop");
    } on PlatformException {}
  }
}
