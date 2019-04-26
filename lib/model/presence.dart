import 'package:ikonfete/model/model.dart';

class UserPresence extends Model<String> {
  String uid;
  bool online;
  DateTime lastSeen;

  @override
  void fromJson(Map json) {
    super.fromJson(json);
    this
      ..uid = json["uid"]
      ..online = json["online"]
      ..lastSeen = json["lastSeen"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["lastSeen"])
          : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll({
      "uid": this.uid,
      "online": this.online,
      "lastSeen": this.lastSeen.millisecondsSinceEpoch,
    });
    return map;
  }
}
