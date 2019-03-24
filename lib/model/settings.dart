import 'package:ikonfete/model/model.dart';

class Settings extends Model<String> {
  String uid;
  String deezerUserId;
  String spotifyUserId;
  String appleMusicUserId;
  bool enableNotifications;

  Settings.empty() {
    this
      ..id = null
      ..uid = null
      ..deezerUserId = null
      ..spotifyUserId = null
      ..appleMusicUserId = null
      ..enableNotifications = false;
  }

  Settings();

  @override
  void fromJson(Map json) {
    super.fromJson(json);
    this
      ..uid = json["uid"]
      ..deezerUserId = json["deezerUserId"] ?? null
      ..spotifyUserId = json["spotifyUserId"] ?? null
      ..appleMusicUserId = json["appleMusicUserId"] ?? null
      ..enableNotifications = json["enableNotifications"] ?? false;
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      "uid": uid,
      "deezerUserId": deezerUserId,
      "spotifyUserId": spotifyUserId,
      "appleMusicUserId": appleMusicUserId,
      "enableNotifications": enableNotifications ?? false,
    });
    return data;
  }

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is Settings &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      uid == other.uid &&
      deezerUserId == other.deezerUserId &&
      spotifyUserId == other.spotifyUserId &&
      appleMusicUserId == other.appleMusicUserId &&
      enableNotifications == other.enableNotifications;

  @override
  int get hashCode =>
      id.hashCode ^
      uid.hashCode ^
      deezerUserId.hashCode ^
      spotifyUserId.hashCode ^
      appleMusicUserId.hashCode ^
      enableNotifications.hashCode;
}
