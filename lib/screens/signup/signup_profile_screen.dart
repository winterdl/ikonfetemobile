import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/activation/activation_screen.dart';
import 'package:ikonfete/screens/signup/signup_profile_bloc.dart';
import 'package:ikonfete/screens/signup/signup_profile_form.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/overlays.dart';

Widget signupProfileScreen(BuildContext context,
    {@required String name,
    @required String email,
    @required String password}) {
  return BlocProvider<SignupProfileBloc>(
    bloc: SignupProfileBloc(name: name, email: email, password: password),
    child: SignupProfileScreen(email, password),
  );
}

class SignupProfileScreen extends StatefulWidget {
  final String email, password;

  SignupProfileScreen(this.email, this.password);

  @override
  _SignupProfileScreenState createState() {
    return new _SignupProfileScreenState();
  }
}

class _SignupProfileScreenState extends State<SignupProfileScreen> {
  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    final bloc = BlocProvider.of<SignupProfileBloc>(context);

    return BlocBuilder<AppEvent, AppState>(
      bloc: appBloc,
      builder: (BuildContext ctx, AppState appState) {
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          key: scaffoldKey,
          body: BlocBuilder<SignupProfileScreenEvent, SignupProfileScreenState>(
            bloc: bloc,
            builder: (context, state) {
              if (state.result != null) {
                final result = state.result;
                if (result.success) {
                  ScreenUtils.onWidgetDidBuild(() {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (ctx) => activationScreen(
                          ctx,
                          result.uid,
                          widget.email,
                          widget.password),
                    ));
                  });
                } else {
                  ScreenUtils.onWidgetDidBuild(() {
                    scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(result.error),
                        backgroundColor: errorColor,
                      ),
                    );
                  });
                }
              }

              return Container(
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
                      showOverlay: state.isLoading,
                      overlayBuilder: (context) => HudOverlay.getOverlay(),
                    ),
                    _buildTitleAndBackButton(context),
                    SizedBox(height: 20.0),
                    _buildIntroText(),
                    SizedBox(height: 40.0),
                    BlocBuilder<AppEvent, AppState>(
                      bloc: appBloc,
                      builder: (context, appState) {
                        return UserSignupProfileForm(
                          formKey: formKey,
                          onSaved: (String username, File profilePic,
                              Country country) {
                            bloc.dispatch(SignupProfileEntered(
                                isArtist: appState.isArtist,
                                username: username,
                                profilePicture: profilePic,
                                countryCode: country.isoCode,
                                countryName: country.name));
                          },
                        );
                      },
                    ),
                    Expanded(child: Container()),
                    _buildButton(context),
                    SizedBox(height: 40.0),
                  ],
                ),
              );
            },
          ),
        );
      },
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
              "YOU",
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
          text: "PROCEED",
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
