import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/model/fan.dart';
import 'package:ikonfete/repository/auth_repository.dart';
import 'package:ikonfete/screens/signup/signup_profile_form.dart';
import 'package:ikonfete/screens/signup/third_party_profile_form.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/overlays.dart';

Widget thirdPartySignupProfileScreen(CurrentUserHolder user) {
  return ThirdPartySignupProfileScreen(user: user);
}

class ThirdPartySignupProfileScreen extends StatefulWidget {
  final CurrentUserHolder user;

  ThirdPartySignupProfileScreen({@required this.user});

  @override
  _ThirdPartySignupProfileScreenState createState() =>
      _ThirdPartySignupProfileScreenState();
}

class _ThirdPartySignupProfileScreenState
    extends State<ThirdPartySignupProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewInsets.top + 40.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            OverlayBuilder(
              child: Container(),
              showOverlay: false,//state.isLoading,
              overlayBuilder: (context) => HudOverlay.getOverlay(),
            ),
            _buildTitleAndBackButton(context),
            SizedBox(height: 20.0),
            _buildIntroText(),
            SizedBox(height: 40.0),
            UserSignupProfileForm(
              formKey: formKey,
              onSaved: (String username, File profilePic, Country country) {
                print("On saved");
//                    bloc.dispatch(SignupProfileEntered(
//                        isArtist: appState.isArtist,
//                        username: username,
//                        profilePicture: profilePic,
//                        countryCode: country.isoCode,
//                        countryName: country.name));
              },
              pictureUrl: widget.user.user.profilePictureUrl,
            ),
            Expanded(child: Container()),
            _buildButton(context),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndBackButton(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "UPDATE YOUR PROFILE",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w100),
            ),
          ],
        ),
        Navigator.of(context).canPop()
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Navigator.canPop(context)
                      ? IconButton(
                          icon: Icon(CupertinoIcons.back,
                              color: Color(0xFF181D28)),
                          onPressed: () => Navigator.of(context).maybePop(),
                        )
                      : Container(),
                ],
              )
            : Container()
      ],
    );
  }

  Widget _buildIntroText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 14.0, color: Colors.black),
        text:
            "Select a display picture and username\nthat you will be identified with.",
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        PrimaryButton(
          width: screenSize.width - 80,
          height: 50.0,
          defaultColor: primaryButtonColor,
          activeColor: primaryButtonActiveColor,
          text: "UPDATE PROFILE",
          // REGISTER
          onTap: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
            }
          },
        ),
      ],
    );
  }
}
