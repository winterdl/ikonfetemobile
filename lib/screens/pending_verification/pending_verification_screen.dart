import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/icons.dart';
import 'package:ikonfete/routes.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/pending_verification/pending_verification_bloc.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'dart:ui' as ui;

Widget pendingVerificationScreen(BuildContext context, String uid) {
  final bloc = PendingVerificationBloc();
  return PendingVerificationScreen(
    uid: uid,
    bloc: bloc,
  );
}

class PendingVerificationScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String uid;
  final PendingVerificationBloc bloc;

  PendingVerificationScreen({@required this.uid, this.bloc}) {
    bloc.dispatch(LoadUser(uid));
  }

  @override
  Widget build(BuildContext context) {
    final connectStreamingTapHandler = TapGestureRecognizer();
    connectStreamingTapHandler.onTap = () {};

    final appBloc = BlocProvider.of<AppBloc>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      body: BlocBuilder<PendingVerificationScreenEvents,
          PendingVerificationScreenState>(
        bloc: bloc,
        builder: (BuildContext context, PendingVerificationScreenState state) {
          if (state.loadArtistResult != null) {
            final result = state.loadArtistResult;
            if (!result.first) {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(result.second),
                  backgroundColor: errorColor,
                ));
              });
            }
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: state.hasError
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              state.hasData &&
                                      !StringUtils.isNullOrEmpty(
                                          state.artist.profilePictureUrl)
                                  ? Image(
                                      image: CachedNetworkImageProvider(
                                          state.artist.profilePictureUrl),
                                      fit: BoxFit.cover)
                                  : Container(),
                              state.hasData &&
                                      !StringUtils.isNullOrEmpty(
                                          state.artist.profilePictureUrl)
                                  ? BackdropFilter(
                                      filter: ui.ImageFilter.blur(
                                          sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.2),
                                        child: Container(),
                                      ),
                                    )
                                  : Container(),
                              Positioned(
                                top: MediaQuery.of(context).padding.top + 20.0,
                                right:
                                    MediaQuery.of(context).padding.right + 20.0,
                                child: IconButton(
                                    icon: Icon(
                                      LineAwesomeIcons.signOut,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      appBloc.dispatch(Signout());
                                      Navigator.of(context)
                                          .pushReplacementNamed(Routes.login);
                                    }),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.5),
                                    radius: 45.0,
                                    backgroundImage: state.hasData &&
                                            !StringUtils.isNullOrEmpty(
                                                state.artist.profilePictureUrl)
                                        ? CachedNetworkImageProvider(
                                            state.artist.profilePictureUrl)
                                        : null,
                                    child: !state.hasData ||
                                            StringUtils.isNullOrEmpty(
                                                state.artist.profilePictureUrl)
                                        ? Icon(
                                            FontAwesome5Icons.solidUser,
                                            size: 40.0,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    state.hasData ? state.artist.name : "",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22.0),
                                  ),
                                  Text(
                                    state.hasData ? state.artist.email : "",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Thank you!",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text("Once your email account is verified, we will\n"
                              "send you an email confirmation\n\n"
                              "In the meantime, you can connect your\n"
                              "streaming services to your profile."),
                          SizedBox(height: 30.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                LineAwesomeIcons.playCircle,
                                color: primaryColor,
                                size: 24.0,
                              ),
                              SizedBox(width: 10.0),
                              RichText(
                                text: TextSpan(
                                  recognizer: connectStreamingTapHandler,
                                  text: "Connect Streaming Services",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 18.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  width: MediaQuery.of(context).size.width - 80,
                  height: 50.0,
                  defaultColor: primaryButtonColor,
                  activeColor: primaryButtonActiveColor,
                  text: "SIGN OUT",
                  // REGISTER
                  onTap: () {
                    appBloc.dispatch(Signout());
                    Navigator.of(context).pushReplacementNamed(Routes.login);
                  },
                ),
                SizedBox(height: 40.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
