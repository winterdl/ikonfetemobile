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
import 'package:ikonfete/screens/profile/profile_screen_bloc.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/overlays.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';
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
            twitterConfig: appConfig.twitterConfig,
            uid: uid,
            isArtist: appState.isArtist,
          );
          return ProfileScreen(
              bloc: profileScreenBloc, isArtist: appState.isArtist, uid: uid);
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

  ProfileScreen(
      {@required this.bloc, @required this.isArtist, @required this.uid}) {
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
            _checkForErrors(state);

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

  _checkForErrors(ProfileScreenState state) {
    if (state.loadUserResult != null && !state.loadUserResult.first) {
      ScreenUtils.onWidgetDidBuild(() {
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(state.loadUserResult.second)));
      });
    }

    if (state.enableFacebookResult != null &&
        !state.enableFacebookResult.first) {
      ScreenUtils.onWidgetDidBuild(() {
        scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text(state.enableFacebookResult.second)));
      });
    }

    if (state.enableTwitterResult != null && !state.enableTwitterResult.first) {
      ScreenUtils.onWidgetDidBuild(() {
        scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text(state.enableTwitterResult.second)));
      });
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
//              backgroundImage: state.newProfilePicture != null
//                  ? FileImage(state.newProfilePicture)
//                  : StringUtils.isNullOrEmpty(state.profilePictureUrl)
//                      ? MemoryImage(kTransparentImage)
//                      : CachedNetworkImageProvider(state.profilePictureUrl),
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
                RichText(
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
//    final result = await Navigator.of(context).push<EditProfileInfoResult>(
//      CupertinoPageRoute(
//        builder: (ctx) => EditProfileInfoScreen(
//              bloc: bloc,
//            ),
//      ),
//    );
//    if (result != null) {
//      bloc.dispatch(ProfileInfoChange(
//        profilePicture: result.profilePicture,
//        country: result.country,
//        countryIsoCode: result.countryIsoCode,
//        displayName: result.displayName,
//      ));
//    }
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
    final editBioTapHandler = TapGestureRecognizer();
    editBioTapHandler.onTap = () {
      _editBio(context, state);
    };

    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Bio",
            style: subHeaderTextStyle,
          ),
          SizedBox(height: 10.0),
          Row(
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
          )
        ],
      ),
    );
  }

  void _editBio(BuildContext context, ProfileScreenState state) async {
//    String updatedBio = await Navigator.of(context).push(
//      CupertinoPageRoute(
//        builder: (ctx) {
//          return EditBioScreen(bio: state.bio);
//        },
//      ),
//    );
//    bloc.dispatch(BioUpdated(updatedBio));
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
            bloc.dispatch(EnableFacebook(val));
          },
          activeColor: primaryColor,
        ),
      ],
    );
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
            bloc.dispatch(EnableTwitter(val));
          },
          activeColor: primaryColor,
        ),
      ],
    );
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
      onTap: () {
        _saveChanges(state);
      },
    );
  }

//  bool _changesMade(ProfileScreenState state) {
//    return state.displayName != state.newDisplayName ||
//        state.newProfilePicture != null ||
//        state.countryIsoCode != state.newCountryIsoCode ||
//        state.country != state.newCountry ||
//        state.bio != state.newBio ||
//        state.facebookId != state.newFacebookId ||
//        state.twitterId != state.newTwitterId;
//  }

  void _saveChanges(ProfileScreenState state) async {
//    final data = EditProfileData();
//    data.isArtist = isArtist;
//    data.uid = uid;
//    data.displayName = state.newDisplayName.trim();
//    data.facebookId = state.newFacebookId;
//    data.twitterId = state.newTwitterId;
//    data.bio = state.newBio.trim();
//    data.countryIsoCode = state.newCountryIsoCode;
//    data.profilePicture = state.newProfilePicture;
//    data.oldProfilePictureUrl = state.profilePictureUrl;
//    data.removeFacebook = !StringUtils.isNullOrEmpty(state.facebookId) &&
//        StringUtils.isNullOrEmpty(state.newFacebookId) &&
//        !state.facebookEnabled;
//    data.removeTwitter = !StringUtils.isNullOrEmpty(state.twitterId) &&
//        StringUtils.isNullOrEmpty(state.newTwitterId) &&
//        !state.twitterEnabled;
//    bloc.dispatch(EditProfile(data));
  }
}
