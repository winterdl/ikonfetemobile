import 'package:meta/meta.dart';

class FacebookConfig {
  FacebookConfig({
    @required this.appId,
    @required this.appSecret,
  });

  final String appId;
  final String appSecret;
}