import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/model/model.dart';

class LiveSession extends Model<String> {
  Artist artist;
  List<Fan> members;
  DateTime startTime;
  DateTime endTime;

  @override
  void fromJson(Map json) {
    super.fromJson(json);
    this
      ..artist = Artist()
      ..fromJson(json["artist"])
      ..startTime = DateTime.fromMillisecondsSinceEpoch(json["startTime"])
      ..endTime = json["endTime"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["endTime"])
          : null;

    List<Map> memmersJson = json["members"];
    this.members = <Fan>[];
    for (Map m in memmersJson) {
      Fan f = Fan()..fromJson(m);
      this.members.add(f);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll({
      "artist": artist.toJson(),
      "startTime": startTime.millisecondsSinceEpoch,
      "endTime": endTime?.millisecondsSinceEpoch ?? null,
      "members": members.map((f) => f.toJson()).toList(),
    });
    return map;
  }
}

class SessionMessage extends Model<String> {
  String sessionId;
  String text;
  
}
