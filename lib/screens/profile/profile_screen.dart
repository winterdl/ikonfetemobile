import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/app_config.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/icons.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/profile/edit_profile_dialog.dart';
import 'package:ikonfete/screens/profile/profile_screen_bloc.dart';
import 'package:ikonfete/twitter/twitter_config.dart';
import 'package:ikonfete/utils/facebook_auth.dart';
import 'package:ikonfete/utils/twitter_auth.dart';
import 'package:ikonfete/widget/form_fields.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/overlays.dart';
import 'package:ikonfete/zoom_scaffold/menu_ids.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold_screen.dart';
import 'package:transparent_image/transparent_image.dart';

Screen profileScreen(String uid) {
  return Screen(
    title: "Profile",
    contentBuilder: (ctx) {
      return BlocBuilder<AppEvent, AppState>(
        bloc: BlocProvider.of<AppBloc>(ctx),
        builder: (bldrCtx, appState) {
          final appConfig = AppConfig.of(ctx);
          final profileScreenBloc = ProfileScreenBloc(
            uid: uid,
            isArtist: appState.isArtist,
          );
          return ProfileScreen(
            bloc: profileScreenBloc,
            isArtist: appState.isArtist,
            uid: uid,
            twitterConfig: appConfig.twitterConfig,
          );
        },
      );
    },
  );
}

class ProfileScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final subHeaderTextStyle = TextStyle(
    fontFamily: "SanFranciscoDisplay",
    fontSize: 18.0,
    color: Colors.black87,
  );

  final ProfileScreenBloc bloc;
  final bool isArtist;
  final String uid;
  final TwitterConfig twitterConfig;

  ProfileScreen({
    @required this.bloc,
    @required this.isArtist,
    @required this.uid,
    @required this.twitterConfig,
  }) {
    bloc.dispatch(LoadProfile());
  }

  Future<bool> _willPop(BuildContext context) async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _willPop(context);
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: BlocBuilder<ProfileScreenEvent, ProfileScreenState>(
          bloc: bloc,
          builder: (BuildContext bldrContext, ProfileScreenState state) {
            _checkForErrors(bldrContext, state);

            final children = <Widget>[
              OverlayBuilder(
                child: Container(),
                showOverlay: state.isLoading,
                overlayBuilder: (context) => HudOverlay.getOverlay(),
              ),
              _buildProfileInfo(context, state),
              _buildEmail(state),
            ];
            if (isArtist) {
              children.add(_buildBio(context, state));
            }
            children.add(_buildSocialProfileConnector(state));
            children.add(Expanded(child: Container()));
            children.add(_buildSaveButton(context, state));

            return Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }

  _checkForErrors(BuildContext context, ProfileScreenState state) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    if (state.loadUserResult != null && !state.loadUserResult.first) {
      ScreenUtils.onWidgetDidBuild(() {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(state.loadUserResult.second),
          backgroundColor: errorColor,
        ));
      });
    }

//    if (state.enableFacebookResult != null &&
//        !state.enableFacebookResult.first) {
//      ScreenUtils.onWidgetDidBuild(() {
//        scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text(state.enableFacebookResult.second),
//          backgroundColor: errorColor,
//        ));
//      });
//    }
//
//    if (state.enableTwitterResult != null && !state.enableTwitterResult.first) {
//      ScreenUtils.onWidgetDidBuild(() {
//        scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text(state.enableTwitterResult.second),
//          backgroundColor: errorColor,
//        ));
//      });
//    }

    if (state.updateProfileResult != null) {
      if (state.updateProfileResult.first) {
        appBloc.dispatch(LoadCurrentUser());

        ScreenUtils.onWidgetDidBuild(() async {
          scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Your profile has been updated.")));
        });
      } else {
        ScreenUtils.onWidgetDidBuild(() {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(state.updateProfileResult.second),
            backgroundColor: errorColor,
          ));
        });
      }
    }
  }

  Widget _buildProfileInfo(BuildContext context, ProfileScreenState state) {
    final editProfileTapHandler = TapGestureRecognizer();
    editProfileTapHandler.onTap = () {
      _editProfileInfo(context, state);
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: SizedBox(
        height: 90.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 45.0,
              foregroundColor: Colors.black45,
              backgroundColor: Colors.black45,
              backgroundImage: state.profilePicture != null
                  ? (state.profilePicture.isFirst
                      ? CachedNetworkImageProvider(state.profilePicture.first)
                      : FileImage(state.profilePicture.second))
                  : MemoryImage(kTransparentImage),
            ),
            SizedBox(width: 20.0),
            SizedBox(
              width: 170.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    state.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black87,
                      fontFamily: "SanFranciscoDisplay",
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "@${state.username}",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontFamily: "SanFranciscoDisplay",
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    state.country,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black45,
                      fontFamily: "SanFranciscoDisplay",
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                state.user == null
                    ? Container()
                    : RichText(
                        text: TextSpan(
                          text: "Edit",
                          recognizer: editProfileTapHandler,
                          style: TextStyle(
                            color: primaryColor,
                            fontFamily: "SanFranciscoDisplay",
                            fontSize: 16.0,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editProfileInfo(BuildContext context, ProfileScreenState state) async {
    final editProfileResult = await Navigator.of(context)
        .push<EditProfileInfoResult>(EditProfileDialog(
            name: state.user.name,
            username: state.user?.username,
            profilePictureUrl: state.user?.profilePictureUrl ?? "",
            countryCode: state.user?.countryIsoCode,
            countryName: state.user?.country));
    if (editProfileResult != null) {
      bloc.dispatch(ProfileInfoEdited(
          profilePicture: editProfileResult.profilePicture,
          displayName: editProfileResult.displayName,
          countryIsoCode: editProfileResult.countryIsoCode,
          country: editProfileResult.country));
    }
  }

  Widget _buildEmail(ProfileScreenState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Email",
          style: subHeaderTextStyle,
        ),
        SizedBox(height: 10.0),
        Text(
          state.email,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black54,
            fontFamily: "SanFranciscoDisplay",
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildBio(BuildContext context, ProfileScreenState state) {
    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            state.editBio ? "Edit Bio" : "Bio",
            style: subHeaderTextStyle,
          ),
          SizedBox(height: 10.0),
          state.editBio ? _bioEditor(state) : _bioDetails(state),
        ],
      ),
    );
  }

  Widget _bioDetails(ProfileScreenState state) {
    final editBioTapHandler = TapGestureRecognizer();
    editBioTapHandler.onTap = () {
      bloc.dispatch(EditBio());
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            splashColor: Colors.grey.withOpacity(0.3),
            child: SizedBox(
              width: 280.0,
              height: 70.0,
              child: Text(
                state.bio,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 4,
                style: TextStyle(
                  fontFamily: "SanFranciscoDisplay",
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
        Expanded(child: Container()),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "Edit",
                recognizer: editBioTapHandler,
                style: TextStyle(
                  color: primaryColor,
                  fontFamily: "SanFranciscoDisplay",
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bioEditor(ProfileScreenState state) {
    return BioEditorForm(
      initialBio: state.bio,
      onCancel: () => bloc.dispatch(CancelEditBio()),
      onSave: (newBio) => bloc.dispatch(BioEdited(newBio)),
    );
  }

  Widget _buildSocialProfileConnector(ProfileScreenState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Connected Social Profiles",
          style: subHeaderTextStyle,
        ),
        SizedBox(height: 30.0),
        _buildFacebookConnector(state),
        SizedBox(height: 20.0),
        _buildTwitterConnector(state),
      ],
    );
  }

  Widget _buildFacebookConnector(ProfileScreenState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildSocialIcon(ThemifyIcons.facebook, facebookColor),
        SizedBox(width: 20.0),
        Text("Facebook", style: subHeaderTextStyle),
        Expanded(child: Container()),
        CupertinoSwitch(
          value: state.facebookEnabled,
          onChanged: (val) {
            _enableFacebook(val);
          },
          activeColor: primaryColor,
        ),
      ],
    );
  }

  void _enableFacebook(bool enable) async {
    if (!enable) {
      bloc.dispatch(UpdateFacebookId(""));
    } else {
      final result = await FacebookAuth().facebookAuth();
      if (result.success) {
        bloc.dispatch(UpdateFacebookId(result.facebookUID));
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(result.errorMessage),
          backgroundColor: errorColor,
        ));
      }
    }
  }

  Widget _buildTwitterConnector(ProfileScreenState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildSocialIcon(ThemifyIcons.twitter, twitterColor),
        SizedBox(width: 20.0),
        Text("Twitter", style: subHeaderTextStyle),
        Expanded(child: Container()),
        CupertinoSwitch(
          value: state.twitterEnabled,
          onChanged: (val) {
            _enableTwitter(val);
          },
          activeColor: primaryColor,
        ),
      ],
    );
  }

  void _enableTwitter(bool enable) async {
    if (!enable) {
      bloc.dispatch(UpdateTwitterId(""));
    } else {
      final result = await TwitterAuth(
              consumerSecret: twitterConfig.consumerSecret,
              consumerKey: twitterConfig.consumerKey)
          .twitterAuth();
      if (result.success) {
        bloc.dispatch(UpdateTwitterId(result.twitterUID));
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(result.errorMessage),
          backgroundColor: errorColor,
        ));
      }
    }
  }

  Widget _buildSocialIcon(IconData iconData, Color iconBGColor) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: iconBGColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Icon(iconData, color: Colors.white),
    );
  }

  Widget _buildSaveButton(BuildContext context, ProfileScreenState state) {
    return PrimaryButton(
      width: MediaQuery.of(context).size.width - 40.0,
      height: 50.0,
      defaultColor: primaryButtonColor,
      activeColor: primaryButtonActiveColor,
      text: "SAVE SETTINGS",
      disabled: !state.changesMade,
      onTap: () => bloc.dispatch(SaveProfile()),
    );
  }
}

class BioEditorForm extends StatefulWidget {
  final String initialBio;
  final Function onCancel;
  final Function(String) onSave;

  BioEditorForm({
    this.initialBio = "",
    @required this.onCancel,
    @required this.onSave,
  });

  @override
  _BioEditorFormState createState() => _BioEditorFormState();
}

class _BioEditorFormState extends State<BioEditorForm> {
  TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.initialBio);
  }

  @override
  Widget build(BuildContext context) {
    final cancelTapHandler = TapGestureRecognizer();
    cancelTapHandler.onTap = () => widget.onCancel();

    final saveTapHandler = TapGestureRecognizer();
    saveTapHandler.onTap = () => widget.onSave(_bioController.text);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        LoginFormField(
          maxLines: 4,
          controller: _bioController,
          textAlign: TextAlign.start,
          validator: FormFieldValidators.notEmpty("Bio"),
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "Cancel",
                recognizer: cancelTapHandler,
                style: TextStyle(
                  color: primaryColor,
                  fontFamily: "SanFranciscoDisplay",
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(width: 20),
            RichText(
              text: TextSpan(
                text: "Save",
                recognizer: saveTapHandler,
                style: TextStyle(
                  color: primaryColor,
                  fontFamily: "SanFranciscoDisplay",
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
