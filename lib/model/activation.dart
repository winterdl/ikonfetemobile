import 'package:ikonfete/model/model.dart';

class Activation extends Model<String> {
  String uid;
  bool isArtist;
  String code;
  DateTime expiryDate;

  bool get isExpired {
    return expiryDate.toUtc().isBefore(DateTime.now().toUtc());
  }

  @override
  void fromJson(Map json) {
    super.fromJson(json);
    this
      ..uid = json["uid"]
      ..isArtist = json["isArtist"]
      ..code = json["code"]
      ..expiryDate = json["expires"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["expires"]).toUtc();
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll({
      "uid": uid,
      "isArtist": isArtist,
      "code": code,
      "expires": expiryDate.toUtc().millisecondsSinceEpoch,
    });
    return map;
  }
}
