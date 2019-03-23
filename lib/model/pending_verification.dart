import 'package:ikonfete/model/model.dart';

class PendingVerification extends Model<String> {
  String uid;
  DateTime dateCreated;
  String facebookId;
  String twitterId;
  String twitterUsername;
  String bio;

  @override
  void fromJson(Map json) {
    super.fromJson(json);
    this
      ..uid = json["uid"]
      ..facebookId = json["facebookId"]
      ..twitterId = json["twitterId"]
      ..twitterUsername = json["twitterUsername"]
      ..bio = json["bio"]
      ..dateCreated = json["dateCreated"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["dateCreated"]).toUtc()
          : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll({
      "uid": uid,
      "facebookId": facebookId,
      "twitterId": twitterId,
      "twitterUsername": twitterUsername,
      "bio": bio,
      "dateCreated": dateCreated?.toUtc()?.millisecondsSinceEpoch ??
          DateTime.now().toUtc().millisecondsSinceEpoch
    });
    return map;
  }
}
