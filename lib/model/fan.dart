import 'package:ikonfete/model/user.dart';

class Fan extends User {
  String currentTeamId;

  @override
  void fromJson(Map json) {
    super.fromJson(json);
    this.currentTeamId = json["currentTeamId"] ?? null;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll({
      "currentTeamId": currentTeamId,
    });
    return map;
  }
}
