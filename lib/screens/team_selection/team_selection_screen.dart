import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/model/artist.dart';
import 'package:ikonfete/routes.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/team_selection/team_selection_bloc.dart';
import 'package:ikonfete/utils/logout_helper.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/widget/form_fields.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/overlays.dart';
import 'package:ikonfete/widget/random_gradient_image.dart';

Widget teamSelectionScreen(BuildContext context, String uid) {
  return BlocProvider<TeamSelectionBloc>(
    bloc: TeamSelectionBloc(),
    child: TeamSelectionScreen(uid: uid),
  );
}

class TeamSelectionScreen extends StatefulWidget {
  final String uid;

  TeamSelectionScreen({@required this.uid});

  @override
  _TeamSelectionScreenState createState() {
    return _TeamSelectionScreenState();
  }
}

class _TeamSelectionScreenState extends State<TeamSelectionScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<TeamSelectionBloc>(context);
    bloc.dispatch(LoadFan(widget.uid));
    bloc.state.listen((state) {
      if (state.loadFanResult != null) {
        if (state.loadFanResult.first) {
          bloc.dispatch(SearchEvent(""));
        }
      }
    });
  }

  Future<bool> _canLogout(BuildContext context) async {
    final appBloc = BlocProvider.of<AppBloc>(context);
    bool logout = await canLogout(context);
    if (logout) {
      appBloc.dispatch(Signout());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TeamSelectionBloc>(context);

    return WillPopScope(
      onWillPop: () async {
        return _canLogout(context);
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: BlocBuilder<TeamSelectionEvent, TeamSelectionState>(
          bloc: bloc,
          builder: (BuildContext ctx, TeamSelectionState state) {
            if (state.loadFanResult != null) {
              final result = state.loadFanResult;
              if (!result.first) {
                ScreenUtils.onWidgetDidBuild(() {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(result.second),
                    backgroundColor: errorColor,
                  ));
                });
              }
            }

            if (state.searchResult != null) {
              final result = state.searchResult;
              if (!result.first) {
                ScreenUtils.onWidgetDidBuild(() {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(result.second),
                    backgroundColor: errorColor,
                  ));
                });
              }
            }

            if (state.teamSelectionResult != null) {
              final result = state.teamSelectionResult;
              if (result.first) {
                ScreenUtils.onWidgetDidBuild(() {
                  Navigator.of(context).pushReplacementNamed(
                      Routes.fanHomeScreenRoute(uid: widget.uid));
                });
              } else {
                ScreenUtils.onWidgetDidBuild(() {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(result.second),
                    backgroundColor: errorColor,
                  ));
                });
              }
            }

            return Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.top + 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  OverlayBuilder(
                    child: Container(),
                    showOverlay: state.isLoading,
                    overlayBuilder: (context) => HudOverlay.getOverlay(),
                  ),
                  _buildTitleAndBackButton(context),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30.0),
                          Text(
                            state.fan == null
                                ? ""
                                : "Hello, ${state?.fan?.name ?? ""}!\nJoin your favourite Artist's Team",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              height: 1.4,
                              fontSize: 18.0,
                              color: bodyColor.withOpacity(0.80),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          SearchField(
                            onChanged: (String value) =>
                                bloc.dispatch(SearchEvent(value)),
                          ),
                          SizedBox(height: 20.0),
                          _buildList(context, state),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
              "Select Team",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w100),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Navigator.canPop(context)
                ? IconButton(
                    icon: Icon(CupertinoIcons.back, color: Color(0xFF181D28)),
                    onPressed: () async {
                      bool logout = await _canLogout(context);
                      if (logout) {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.login);
                        }
                      }
                    },
                  )
                : Container(),
          ],
        )
      ],
    );
  }

  Widget _buildList(BuildContext context, TeamSelectionState state) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: state.artists.length,
        itemExtent: 84.0,
        itemBuilder: (BuildContext context, int index) {
          final artist = state.artists.isEmpty ? null : state.artists[index];
          if (artist == null) {
            return Container();
          }

          return ListTile(
            contentPadding: EdgeInsets.all(0.0),
            leading: StringUtils.isNullOrEmpty(artist.profilePictureUrl)
                ? RandomGradientImage()
                : RandomGradientImage(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      backgroundImage:
                          CachedNetworkImageProvider(artist.profilePictureUrl),
                    ),
                  ),
            title: Text(
              artist.name,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              //followers
              StringUtils.abbreviateNumber(artist.teamMemberCount, 1),
              style: TextStyle(
                fontSize: 13.0,
                color: Color(0xFF707070),
              ),
            ),
            subtitle: Text(
              artist.country,
              style: TextStyle(
                fontSize: 13.0,
                color: Color(0xFF707070),
              ),
            ),
            enabled: true,
//            onTap: () => bloc.dispatch(ArtistSelected(artist)),
            onTap: () => _artistSelected(artist),
          );
        },
      ),
    );
  }

  void _artistSelected(Artist artist) async {
    final bloc = BlocProvider.of<TeamSelectionBloc>(context);
    bool selected = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text("Join Team"),
            content: Text("Do you want to join ${artist.name}'s team?"),
            actions: <Widget>[
              FlatButton(
                  child: Text("YES"),
                  onPressed: () => Navigator.pop(ctx, true)),
              FlatButton(
                  child: Text("NO"),
                  onPressed: () => Navigator.pop(ctx, false)),
            ],
          ),
    );
    if (selected) {
      bloc.dispatch(JoinTeam(artistUid: artist.uid, fanUid: widget.uid));
    }
  }

//  Widget _buildArtistModal(BuildContext context, Artist artist, Fan fan) {
//    final widthRatio = 0.8;
//    final heightRatio = 0.5;
//    final screenSize = MediaQuery.of(context).size;
//    final maxHeight = heightRatio * screenSize.height;
//    final maxWidth = widthRatio * screenSize.width;
//    final contentBackgroundColor = Colors.white;
//    final borderRadius = BorderRadius.circular(10.0);
//
//    return Stack(
//      children: [
//        Container(
//          width: double.infinity,
//          height: double.infinity,
//          color: const Color(0x77000000),
//        ),
//        Positioned(
//          left: (screenSize.width - maxWidth) / 2,
//          width: maxWidth,
//          top: (screenSize.height - maxHeight) / 2,
//          height: maxHeight,
//          child: Theme(
//            data: Theme.of(context).copyWith(),
//            child: Container(
//              decoration: BoxDecoration(
//                color: contentBackgroundColor,
//                borderRadius: borderRadius,
//              ),
//              child: _buildTeamDetailDialogContent(artist, fan),
//            ),
//          ),
//        ),
//      ],
//    );
//  }
//
//  Widget _buildTeamDetailDialogContent(Artist artist, Fan fan) {
//    final bloc = BlocProvider.of<TeamSelectionBloc>(context);
//    final whiteText = Colors.white.withOpacity(0.9);
//    return Container(
//      color: Colors.transparent,
//      child: Column(
//        children: <Widget>[
//          Expanded(
//            flex: 2,
//            child: Container(
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.only(
//                  topLeft: Radius.circular(10.0),
//                  topRight: Radius.circular(10.0),
//                ),
//                image: DecorationImage(
//                  image: CachedNetworkImageProvider(artist.profilePictureUrl),
//                  fit: BoxFit.cover,
//                ),
//              ),
//            ),
//          ),
//          Expanded(
//            flex: 3,
//            child: Container(
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.only(
//                  bottomLeft: Radius.circular(10.0),
//                  bottomRight: Radius.circular(10.0),
//                ),
//                color: const Color(0xFFCC181F),
//              ),
//              child: Container(
//                padding: const EdgeInsets.all(10.0),
//                width: double.infinity,
//                height: double.infinity,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.max,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      artist.name,
//                      style: Theme.of(context).textTheme.body1.copyWith(
//                            fontSize: 20.0,
//                            fontWeight: FontWeight.w500,
//                            color: whiteText,
//                          ),
//                    ),
//                    SizedBox(height: 10.0),
//                    SizedBox(
//                      height: 100.0,
//                      child: Text(
//                        artist.bio,
//                        overflow: TextOverflow.ellipsis,
//                        maxLines: 7,
//                        textAlign: TextAlign.start,
//                        style: Theme.of(context)
//                            .textTheme
//                            .body1
//                            .copyWith(color: whiteText),
//                      ),
//                    ),
//                    Expanded(child: Container()),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      mainAxisSize: MainAxisSize.max,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        FlatButton(
//                          child: Text(
//                            "Cancel",
//                            style: TextStyle(color: Colors.white),
//                          ),
////                          onPressed: () => bloc.dispatch(ClearSelectedTeam()), todo:
//                          onPressed: () => {},
//                        ),
//                        Expanded(child: Container()),
//                        FlatButton(
//                          child: Text("Join Team",
//                              style: TextStyle(color: Colors.white),
//                              overflow: TextOverflow.ellipsis),
////                          onPressed: () => bloc.dispatch(AddFanToTeam(teamId: team.id, fanUid: fan.uid)),// TODO:
//                          onPressed: () => null,
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
}
