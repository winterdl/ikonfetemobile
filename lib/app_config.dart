import 'package:flutter/material.dart';
import 'package:ikonfete/facebook/facebook_config.dart';
import 'package:ikonfete/twitter/twitter_config.dart';
import 'package:meta/meta.dart';

class AppConfig extends InheritedWidget {
  AppConfig({
    @required this.appName,
    @required this.flavorName,
    @required this.facebookConfig,
    @required this.twitterConfig,
    @required Widget child,
  }) : super(child: child);

  final String appName;
  final String flavorName;
  final FacebookConfig facebookConfig;
  final TwitterConfig twitterConfig;

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
