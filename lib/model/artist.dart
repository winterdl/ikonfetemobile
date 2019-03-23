import 'package:ikonfete/model/user.dart';

class Artist extends User {
  bool isVerified = false;
  DateTime dateVerified;
  bool isPendingVerification = false;
  String bio;
  num teamMemberCount = 0;

//  String spotifyArtistId;
//  String deezerArtistId;

  @override
  void fromJson(Map json) {
    super.fromJson(json);
    this
      ..isVerified = json["isVerified"] ?? false
      ..isPendingVerification = json["isPendingVerification"] ?? false
      ..bio = json["bio"] ?? ""
      ..teamMemberCount = json["teamMemberCount"] ?? 0;

    this.dateVerified = json["dateVerified"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json["dateVerified"]).toUtc();
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll({
      "isVerified": isVerified,
      "dateVerified": dateVerified?.toUtc()?.millisecondsSinceEpoch ?? null,
      "isPendingVerification": isPendingVerification,
      "bio": bio,
      "teamMemberCount": teamMemberCount ?? 0,
    });
    return map;
  }
}
