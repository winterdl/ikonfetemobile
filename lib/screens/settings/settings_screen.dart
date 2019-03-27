import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/icons.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/settings/settings_bloc.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/overlays.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';

Screen settingsScreen(String uid) {
  return Screen(
    title: "Settings",
    contentBuilder: (context) {
      return SettingsScreen(SettingsBloc(uid: uid));
    },
  );
}

class SettingsScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SettingsBloc settingsBloc;

  SettingsScreen(this.settingsBloc) {
    settingsBloc.dispatch(LoadSettings());
  }

  final settingHeaderTextStyle = TextStyle(
    fontFamily: "SanFranciscoDisplay",
    fontSize: 18.0,
    color: Colors.black87,
  );

  final settingInfoTextStyle = TextStyle(
    fontFamily: "SanFranciscoDisplay",
    fontSize: 14.0,
    color: Colors.black54,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: BlocBuilder<SettingsScreenEvent, SettingsState>(
        bloc: settingsBloc,
        builder: (bldContext, settingsState) {
          if (settingsState.loadSettingsResult != null) {
            final result = settingsState.loadSettingsResult;
            if (!result.first) {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(result.second),
                    backgroundColor: errorColor,
                  ),
                );
              });
            }
          }

          if (settingsState.enableDeezerResult != null) {
            final result = settingsState.enableDeezerResult;
            if (!result.first) {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(result.second),
                    backgroundColor: errorColor,
                  ),
                );
              });
            }
          }

          if (settingsState.saveSettingsResult != null) {
            final result = settingsState.saveSettingsResult;
            if (result.first) {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text("Settings updated"),
                  ),
                );
              });
            } else {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(result.second),
                    backgroundColor: errorColor,
                  ),
                );
              });
            }
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                OverlayBuilder(
                  child: Container(),
                  showOverlay: settingsState.isLoading,
                  overlayBuilder: (context) => HudOverlay.getOverlay(),
                ),
                Text(
                  "Connected Streaming Accounts",
                  style: settingHeaderTextStyle,
                ),
                SizedBox(height: 30.0),
                _buildAppleMusicConnector(),
                SizedBox(height: 30.0),
                _buildSpotifyConnector(settingsState),
                SizedBox(height: 30.0),
                _buildDeezerConnector(context, settingsState),
                SizedBox(height: 40.0),
                _buildNotificationSettings(settingsState),
                SizedBox(height: 30.0),
                _buildAboutLink(),
                Expanded(child: Container()),
                _buildSaveButton(context, settingsState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppleMusicConnector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: itunesColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Icon(FontAwesome5Icons.itunes, color: Colors.white),
        ),
        SizedBox(width: 20.0),
        Text("Apple Music", style: settingHeaderTextStyle),
        Expanded(child: Container()),
        CupertinoSwitch(
          value: false,
          onChanged: (val) {},
          activeColor: primaryColor,
        ),
      ],
    );
  }

  Widget _buildSpotifyConnector(SettingsState settingsState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: spotifyColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Icon(FontAwesome5Icons.spotify, color: Colors.white),
        ),
        SizedBox(width: 20.0),
        Text("Spotify", style: settingHeaderTextStyle),
        Expanded(child: Container()),
        CupertinoSwitch(
//          value: _spotifyEnabled, TODO:
          value: settingsState.settings == null
              ? false
              : !StringUtils.isNullOrEmpty(
                  settingsState.settings.spotifyUserId),
          onChanged: (val) async {
//            setState(() => _spotifyEnabled = val);
//            if (val) {
//              _bloc.spotifyAuthBloc.authorizeSpotify();
//            } else if (_settings != null) {
//              _settings.spotifyUserId = "";
//            }
          },
          activeColor: primaryColor,
        ),
      ],
    );
  }

  Widget _buildDeezerConnector(
      BuildContext context, SettingsState settingsState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 40.0,
          height: 40.0,
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Color(0xFF162737),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Image.asset("assets/images/deezer.png", fit: BoxFit.contain),
        ),
        SizedBox(width: 20.0),
        Text("Deezer", style: settingHeaderTextStyle),
        Expanded(child: Container()),
        CupertinoSwitch(
          value: settingsState.deezerEnabled,
          onChanged: (val) => settingsBloc.dispatch(EnableDeezerEvent(val)),
          activeColor: primaryColor,
        ),
      ],
    );
  }

  Widget _buildNotificationSettings(SettingsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notifications",
                style: settingHeaderTextStyle,
              ),
              SizedBox(height: 5.0),
              Text(
                "We send notifications about new tracks, albums and other important things",
                style: settingInfoTextStyle,
              ),
            ],
          ),
        ),
        SizedBox(width: 5.0),
        CupertinoSwitch(
          value: state.enableNotifications ??
              state.settings?.enableNotifications ??
              false,
          onChanged: (val) =>
              settingsBloc.dispatch(EnableNotificationsEvent(val)),
          activeColor: primaryColor,
        ),
      ],
    );
  }

  Widget _buildAboutLink() {
    final aboutTapHandler = TapGestureRecognizer();
    aboutTapHandler.onTap = () {};

    return RichText(
      text: TextSpan(
        text: "About Ikonfete",
        style: settingHeaderTextStyle,
        recognizer: aboutTapHandler,
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, SettingsState state) {
    return PrimaryButton(
      width: MediaQuery.of(context).size.width - 40.0,
      height: 50.0,
      defaultColor: primaryButtonColor,
      activeColor: primaryButtonActiveColor,
      text: "SAVE SETTINGS",
      disabled: !state.changesMade,
      onTap: () => settingsBloc.dispatch(SaveSettings()),
    );
  }
}
