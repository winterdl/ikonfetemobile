import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/team/teram_bloc.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/widget/form_fields.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/overlays.dart';
import 'package:ikonfete/widget/random_gradient_image.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';

Screen teamScreen(String uid) {
  return Screen(
      title: "TEAM",
      contentBuilder: (ctx) {
        return TeamScreen(teamScreenBloc: TeamScreenBloc(uid: uid));
      });
}

class TeamScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TeamScreenBloc teamScreenBloc;

  TeamScreen({@required this.teamScreenBloc}) {
    teamScreenBloc.dispatch(LoadArtist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: BlocBuilder<TeamScreenEvent, TeamScreenState>(
          bloc: teamScreenBloc,
          builder: (ctx, state) {
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
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  OverlayBuilder(
                    child: Container(),
                    showOverlay: state.isLoading,
                    overlayBuilder: (context) => HudOverlay.getOverlay(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30.0),
                          Text(
                            "Hello ${state.artist?.name ?? ""}!\nThese are your top fans!",
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
                                teamScreenBloc.dispatch(TeamSearch(value)),
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
          }),
    );
  }

  Widget _buildList(BuildContext context, TeamScreenState state) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: state.teamMembers?.length ?? 0,
        itemExtent: 84.0,
        itemBuilder: (BuildContext context, int index) {
          final fan =
              state.teamMembers.isEmpty ? null : state.teamMembers[index];
          if (fan == null) {
            return Container();
          }

          return ListTile(
            contentPadding: EdgeInsets.all(0.0),
            leading: StringUtils.isNullOrEmpty(fan.profilePictureUrl)
                ? RandomGradientImage()
                : RandomGradientImage(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      backgroundImage:
                          CachedNetworkImageProvider(fan.profilePictureUrl),
                    ),
                  ),
            title: Text(
              fan.name,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
//            trailing: Text(
//              //followers
//              StringUtils.abbreviateNumber(fan.teamMemberCount, 1),
//              style: TextStyle(
//                fontSize: 13.0,
//                color: Color(0xFF707070),
//              ),
//            ),
            subtitle: Text(
              fan.feteScore.toString(),
              style: TextStyle(
                fontSize: 13.0,
                color: Color(0xFF707070),
              ),
            ),
            enabled: true,
//            onTap: () => bloc.dispatch(ArtistSelected(artist)),
//            onTap: () => _artistSelected(artist),
          );
        },
      ),
    );
  }
}
